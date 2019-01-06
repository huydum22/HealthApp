//
//  Listfood.swift
//  HealthApp
//
//  Created by queo on 12/19/18.
//  Copyright © 2018 CodeWith2w1m. All rights reserved.
//

import UIKit

class ListFood: UITableViewController,UISearchBarDelegate {
    
    var activityIndicator:UIActivityIndicatorView!
    var defaultSearchText : String?
    var searchText = ""
    var flag = 10
    var isSearched = false
    
    
    func fetchImage() {
           let Flag = String(flag)
       // let UrlString = "https://api.edamam.com/search?q=breakfast&app_id=b4a89907&app_key=%20396294c0d71e6da8ccd65fba4a384db8"
         let UrlString = "https://api.edamam.com/search?q=\(searchText)&app_id=b4a89907&app_key=%20396294c0d71e6da8ccd65fba4a384db8&from=0&to=\(Flag)"
        guard let url = URL(string: UrlString) else {  return  }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else {  return }
            
            do {
                let json = try JSONDecoder().decode(JsonData.self, from: data)
                for hit in json.hits! {
                    urlFoodArr.insert(hit.recipe!, at: 0)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
                
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            
            }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchText = defaultSearchText!
        self.setUpNaBar()
        self.tableView.register(ImageViewCell.self, forCellReuseIdentifier: "imageViewCell")
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.fetchImage()
            
            DispatchQueue.main.async {
                self.setUpRefreshControl()
                self.setUpActivityIndicator()
            }
        }
    }
    func setUpNaBar() {
        let searchbar = UISearchController(searchResultsController: nil)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.searchController = searchbar
        navigationItem.hidesSearchBarWhenScrolling = false
        searchbar.searchBar.delegate = self
        searchbar.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
    }
    
    func setUpActivityIndicator()
    {
        activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.center = tableView.center
        activityIndicator.color = .red
        self.activityIndicator.hidesWhenStopped = true
        tableView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        self.tableView.reloadData()
    }
    func setUpRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .red
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        self.tableView.reloadData()
        
    }
    @objc func requestData() {
        flag += 10
        fetchImage()
        let deadline = DispatchTime.now() + .milliseconds(2000)
        DispatchQueue.main.asyncAfter(deadline : deadline) {
            self.refreshControl!.endRefreshing()
        }
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageViewCell") as! ImageViewCell
        
        cell.mainImageView.loadImageUsingUrlString(urlString: urlFoodArr[indexPath.row].image!)
        if cell.mainImageView.image == nil {
            cell.mainImageView.image = UIImage(named: "placeholder")
        }
        cell.foodName.text = urlFoodArr[indexPath.row].label!
        let calories = Int(urlFoodArr[indexPath.row].calories ?? 0) / Int(urlFoodArr[indexPath.row].yield ?? 1)
        cell.calories.text = String(calories) + " Calories"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urlFoodArr.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = storyboard?.instantiateViewController(withIdentifier: "DetailFood") as? DetailFood
        
        cell!.mainImageView.loadImageUsingUrlString(urlString: urlFoodArr[indexPath.row].image!)
        cell?.foodName = urlFoodArr[indexPath.row].label ?? "FOOD"
        cell?.yield = Int(urlFoodArr[indexPath.row].yield ?? 0)
        cell?.calories = Int(urlFoodArr[indexPath.row].calories ?? 0)
        cell?.proWeight = Int(urlFoodArr[indexPath.row].totalNutrients?.PROCNT?.quantity ?? 0)
        cell?.carbsWeight = Int(urlFoodArr[indexPath.row].totalNutrients?.CHOCDF?.quantity ?? 0)
        cell?.fatWeight = Int(urlFoodArr[indexPath.row].totalNutrients?.FAT?.quantity ?? 0)
        cell?.fat1 = Int(urlFoodArr[indexPath.row].totalNutrients?.FASAT?.quantity ?? 0)
        cell?.fat2 = Int(urlFoodArr[indexPath.row].totalNutrients?.FAMS?.quantity ?? 0)
        cell?.carbs1 = Int(urlFoodArr[indexPath.row].totalNutrients?.FIBTG?.quantity ?? 0)
        cell?.carbs2 = Int(urlFoodArr[indexPath.row].totalNutrients?.SUGAR?.quantity ?? 0)
        cell?.other1 = Int(urlFoodArr[indexPath.row].totalNutrients?.CHOLE?.quantity ?? 0)
        cell?.other2 = Int(urlFoodArr[indexPath.row].totalNutrients?.NA?.quantity ?? 0)
        cell?.other3 = Int(urlFoodArr[indexPath.row].totalNutrients?.K?.quantity ?? 0)
        
        self.navigationController?.pushViewController(cell!, animated: true)
    }
    func  searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        flag = 10
        searchText = searchBar.text!
        searchText = searchText.replacingOccurrences(of: " ", with: "%20")
        urlFoodArr = [foodData]()
        fetchImage()
        searchBar.endEditing(true)
        activityIndicator.startAnimating()
        self.tableView.reloadData()
    }
       override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return tableView.frame.width / CGFloat(1.0)
      }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchText != "" {
            flag = 10
            searchText = defaultSearchText!
            searchBar.text = ""
            urlFoodArr = [foodData]()
            fetchImage()
            searchBar.endEditing(true)
            activityIndicator.startAnimating()
            self.tableView.reloadData()
        }
    }
}

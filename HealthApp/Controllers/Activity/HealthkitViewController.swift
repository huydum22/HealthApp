//
//  HealthkitViewController.swift
//  HealthApp
//
//  Created by queo on 1/10/19.
//  Copyright © 2019 CodeWith2w1m. All rights reserved.
//

import UIKit
import HealthKit
let healthKitStore:HKHealthStore = HKHealthStore()
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func dcm(_ sender: Any) {
        self.authorize()
    }
    func authorize() {
        let read: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!
        ]
        if !HKHealthStore.isHealthDataAvailable()
        {
            return
        }
        healthKitStore.requestAuthorization(toShare: nil, read: read)
        { (success, error) -> Void in
        }
    }
    func getTodaysSteps(completion: @escaping (Double) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
            let query = HKObserverQuery(sampleType: stepsQuantityType, predicate: nil) { (query, completionHandler, error) in
               
             /*   guard let completionHandler = query else {
                    print("Failed to fetch steps rate")
                    completion(resultCount)
                    return
                }*/
                let now = Date()
                let startOfDay = Calendar.current.startOfDay(for: now)
                let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
                
                let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
                    var resultCount = 0.0
                    guard let result = result else {
                        print("Failed to fetch steps rate")
                        completion(resultCount)
                        return
                    }
                    if let sum =  result.sumQuantity() {
                        resultCount = sum.doubleValue(for: HKUnit.count())
                    }
                    
                    DispatchQueue.main.async {
                        completion(resultCount)
                    }
                }
                
                healthKitStore.execute(query)
                
            }
                healthKitStore.execute(query)
                healthKitStore.enableBackgroundDelivery(for: stepsQuantityType, frequency: .immediate) { (complete, error) in
                }
            
    }
    func getTodayCalo(completion: @escaping (Double) -> Void) {
        
        let caloType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        
         let query = HKObserverQuery(sampleType: caloType, predicate: nil) { (query, completionHandler, error) in
        
            let now = Date()
            let startOfDay = Calendar.current.startOfDay(for: now)
            let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
            let query = HKStatisticsQuery(quantityType: caloType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
                var resultCount = 0.0
                guard let result = result else {
                    print("Failed to fetch steps rate")
                    completion(resultCount)
                    return
                }
                if let sum =  result.sumQuantity() {
                    resultCount = sum.doubleValue(for: HKUnit.kilocalorie())
                   
                }
                
                DispatchQueue.main.async {
                    completion(resultCount)
                }
            }
            healthKitStore.execute(query)
        }
        healthKitStore.execute(query)
        healthKitStore.enableBackgroundDelivery(for: caloType, frequency: .immediate) { (complete, error) in
        }
    }
    @IBOutlet weak var totalCalo: UILabel!
    @IBOutlet weak var totalSteps: UILabel!
    @IBAction func getTotalSteps(_ sender: Any) {
        getTodaysSteps { (steps) in
            print("\(steps)")
            DispatchQueue.main.async {
                self.totalSteps.text = "\(steps)"
            }
        }
    }
    @IBAction func getCalo(_ sender: Any) {
        getTodayCalo { (calo) in
            print("\(calo)")
            DispatchQueue.main.async {
                self.totalCalo.text = "\(calo)"
            }
        }
    }
}

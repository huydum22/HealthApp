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
       setUp()
    }
    func setUp() {
        getTodaysSteps { (info) in
            DispatchQueue.main.async {
                self.totalSteps.text = String(info[0])
                self.totalPush.text = String(info[1])
                self.totalDistance.text = String(info[2])
                self.totalCalo.text = String(info[3])
            }
        }
    }
    @IBAction func authorizeClick(_ sender: Any) {
        self.authorize()
    }
    func authorize() {
        let infoToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .pushCount)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
        ]
        if !HKHealthStore.isHealthDataAvailable()
        {
            return
        }
        healthKitStore.requestAuthorization(toShare: nil, read: infoToRead)
        { (success, error) -> Void in
        }
    }
    func getTodaysSteps(completion: @escaping ([Double]) -> Void) {
        let types = [
            HKQuantityType.quantityType(forIdentifier: .stepCount)!,
            HKQuantityType.quantityType(forIdentifier: .pushCount)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
            ]
        
        var resultCount = [0.0,0.0,0.0,0.0]
        for type in types
        {
            let query = HKObserverQuery(sampleType: type, predicate: nil) { (query, completionHandler, error) in
                
                /*   guard let completionHandler = query else {
                 print("Failed to fetch steps rate")
                 completion(resultCount)
                 return
                 }*/
                let now = Date()
                let startOfDay = Calendar.current.startOfDay(for: now)
                let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
                
                let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
                    
                    guard let result = result else {
                        print("Failed to fetch steps rate")
                        completion(resultCount)
                        return
                    }
                    switch type {
                    case HKQuantityType.quantityType(forIdentifier: .pushCount) :
                        if let sum =  result.sumQuantity() {
                            resultCount[1] = sum.doubleValue(for: HKUnit.count())
                        }
                    case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) :
                        if let sum =  result.sumQuantity() {
                            resultCount[2] = sum.doubleValue(for: HKUnit.mile())
                        }
                    case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned ) :
                        if let sum =  result.sumQuantity() {
                            resultCount[3] = sum.doubleValue(for: HKUnit.kilocalorie())
                        }
                    default:
                        if let sum =  result.sumQuantity() {
                            resultCount[0] = sum.doubleValue(for: HKUnit.count())
                        }
                    }
                   
                    
                    DispatchQueue.main.async {
                        completion(resultCount)
                    }
                }
                
                healthKitStore.execute(query)
                
            }
            healthKitStore.execute(query)
            healthKitStore.enableBackgroundDelivery(for: type, frequency: .immediate) { (complete, error) in
            }
        }
        
            
    }
    @IBOutlet weak var totalDistance: UILabel!
    @IBOutlet weak var totalPush: UILabel!
    @IBOutlet weak var totalCalo: UILabel!
    @IBOutlet weak var totalSteps: UILabel!
}

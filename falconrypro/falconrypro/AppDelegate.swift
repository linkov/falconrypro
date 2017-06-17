//
//  AppDelegate.swift
//  falconrypro
//
//  Created by Alex Linkov on 4/8/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Fabric
import Crashlytics
import Eureka
import UserNotifications
import SwiftDate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    let center = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound];
    let dataStore:SDWDataStore = SDWDataStore.sharedInstance
    
    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.all
//    var localNotification:UILocalNotification
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    public func application(_ application: UIApplication,  didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        // Override point for customization after application launch.
        Fabric.with([Crashlytics.self])
        UINavigationBar.appearance().tintColor = AppUtility.app_color_black
        UISearchBar.appearance().tintColor = AppUtility.app_color_black
        UINavigationBar.appearance().backgroundColor = UIColor.white
        
        let proxyButton = UIButton.appearance()
//        proxyButton.setTitleColor(AppUtility.app_color_black, for: .normal)
        proxyButton.tintColor = AppUtility.app_color_black
        
        let proxyImageView = UIImageView.appearance()
        proxyImageView.tintColor = AppUtility.app_color_black
        

        let proxyCell = UITableViewCell.appearance()
        proxyCell.tintColor = AppUtility.app_color_black
        proxyCell.textLabel?.textColor = AppUtility.app_color_black
        
        
        let proxyTitleLabel = UILabel.appearance(whenContainedInInstancesOf: [FormViewController.self])
        proxyTitleLabel.tintColor = AppUtility.app_color_black
        
        proxyTitleLabel.textColor = AppUtility.app_color_black
        
        center.delegate = self
        
        
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("Something went wrong")
            } else {
                self.createNotification()
            }
        }

        
//        let myOwnDate = Date()
//        dateFormatter.dateFormat = "dd/MM/yyyy"
//        let currentDate = dateFormatter.string(from: myOwnDate)
//        let dateTime = currentDate + "9:00PM"
//        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
//        let date = dateFormatter.date(from: dateTime)!
//        
//        localNotification.fireDate = date
//        localNotification.repeatInterval = NSCalendar.Unit.weekday
//        localNotification.alertBody = "Your alarm is ringing!"
//        let app = UIApplication.shared
//        app.scheduleLocalNotification(localNotification)
        
        
//        let proxyImageView = UIImageView.appearance()
//        proxyImageView.tintColor = AppUtility.app_color_black
//        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func createNotification() {
        
        let currentUser = self.dataStore.currentUser()
        
        let bird = self.dataStore.currentBird()
        
        if (bird == nil || currentUser == nil || currentUser?.model.sunsetTime == nil) {
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Don't forget to feed \(bird?.name ?? "" )"
        content.body = "Add food given to your diary item for today"
        content.sound = UNNotificationSound.default()
        
        
        let date = currentUser?.model.sunsetTime
        let swiftDate:DateInRegion = date!.inDefaultRegion()
        let hourBeforeSunset = swiftDate - 1.hour
        let absolute = hourBeforeSunset.absoluteDate
        
        
        //        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
        //
        //        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate,
        //                                                    repeats: false)
        
        //        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 300,
        //                                                        repeats: false)
        //
        let triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second,], from: absolute)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
        
        let identifier = "UYLLocalNotification"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(" center.add error - \(error.localizedDescription)")
            }
        })
        
 
        
        
        

        

        
    }
    
    public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(
            app,
            open: url as URL!,
            sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
            annotation: options[UIApplicationOpenURLOptionsKey.annotation]
        )
    }
    
    public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url as URL!,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let bird = self.dataStore.currentBird()
        let season = self.dataStore.currentSeason()
        
        if (bird == nil || season == nil) {
            return
        }
        let todayDiaryItem = self.dataStore.currentTodayItemForBird(bird_id: (bird?.remoteID)!, inSeason: (season?.remoteID)!)
        
        if (todayDiaryItem == nil || todayDiaryItem?.weights?.count == 0) {
            
            completionHandler([.alert,.sound])
        }
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // Determine the user action
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Default")
        case "Snooze":
            print("Snooze")
        case "Delete":
            print("Delete")  
        default:
            print("Unknown action")
        }
        completionHandler()
    }




}


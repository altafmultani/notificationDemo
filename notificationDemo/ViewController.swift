//
//  ViewController.swift
//  notificationDemo
//
//  Created by helpmac on 22/12/20.
//  Copyright © 2020 TechnoTouch Infotech. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class ViewController: UIViewController,UNUserNotificationCenterDelegate {

    //MARK: Properties and outlets
       let time:TimeInterval = 10.0
       let snooze:TimeInterval = 5.0
       var isGrantedAccess = false
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        UNUserNotificationCenter.current().delegate = self
               UNUserNotificationCenter.current().requestAuthorization(
                   options: [.alert,.sound,.badge],
                   completionHandler: { (granted,error) in
                       self.isGrantedAccess = granted
                       if granted{
                           self.setCategories()
                       } else {
                           let alert = UIAlertController(title: "Notification Access", message: "In order to use this application, turn on notification permissions.", preferredStyle: .alert)
                           let alertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                           alert.addAction(alertAction)
                           self.present(alert , animated: true, completion: nil)
                       }
               })
        
    }
    
    //this method set the category
    func setCategories(){
        let snoozeAction = UNNotificationAction(
            identifier: "snooze",
            title: "Snooze 5 Sec",
            options: [])
        
        let alarmCategory = UNNotificationCategory(
            identifier: "alarm.category",
            actions: [snoozeAction],
            intentIdentifiers: [],
            options: [])
        
        
        UNUserNotificationCenter.current().setNotificationCategories([alarmCategory])
    }
    
    func addNotification(content:UNNotificationContent,trigger:UNNotificationTrigger?, indentifier:String){
        let request = UNNotificationRequest(identifier: indentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {
            (errorObject) in
            if let error = errorObject{
                print("Error \(error.localizedDescription) in notification \(indentifier)")
            }
        })
    }
    
    
    @IBAction func btnSave(_ sender: Any) {
        
   if isGrantedAccess{
       let content = UNMutableNotificationContent()
       content.title = "Alarm"
       content.subtitle = "First Alarm"
       content.body = "First Alarm"
    content.sound = UNNotificationSound.default
       content.categoryIdentifier = "alarm.category"
       let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
       addNotification(content: content, trigger: trigger , indentifier: "Alarm")
   }
    
}
    
    // MARK: - Delegates
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
    }
    
    //Add this method to handle snooz after once appear
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
        let identifier = response.actionIdentifier
        let request = response.notification.request
        if identifier == "snooze"{
        }
        let newContent = request.content.mutableCopy() as! UNMutableNotificationContent
        let newTrigger = UNTimeIntervalNotificationTrigger(timeInterval: snooze, repeats: false)
        addNotification(content: newContent, trigger: newTrigger, indentifier: request.identifier)


    }
}

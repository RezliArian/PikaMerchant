//
//  PushNotificationSender.swift
//  PIkaMerchant
//
//  Created by Rezli Arian Perdana on 25/11/19.
//  Copyright © 2019 Apple Developer Academy. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class PushNotificationManager : NSObject, MessagingDelegate, UNUserNotificationCenterDelegate{
  let userID: String
  init(userID: String){
    self.userID = userID
    super.init()
  }
  
  func registerForPushNotifications(){
    
    if #available(iOS 10.0, *){
      let center = UNUserNotificationCenter.current()
      center.delegate = self
      
      let options: UNAuthorizationOptions = [.sound, .alert, .badge]
      
      center.requestAuthorization(options: options) { (granted, err) in
        if let error = err{
          print(err)
        }
        print(granted)
      }
      Messaging.messaging().delegate = self
    } else{
      let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
      UIApplication.shared.registerUserNotificationSettings(settings)
    }
    UIApplication.shared.registerForRemoteNotifications()
   updateFirestorePushTokenIfNeeded()
  }
  
  func updateFirestorePushTokenIfNeeded(){
    if let token = Messaging.messaging().fcmToken{
      let userRef = Firestore.firestore().collection("user_table").document(userID)   //Di Ganti dengan punya kita
      userRef.setData(["fcmToken":token], merge: true)
    }
  }
  
  func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
    print(remoteMessage.appData)
  }
  
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
    print("fcmToken: \(fcmToken)")
    UserDefaults.standard.set(fcmToken, forKey: "userFCMToken")
    updateFirestorePushTokenIfNeeded()
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    
    print(response)
  }
}



class PushNotificationSender{
  func sendPushNotification(to token: String, title: String, body: String){
    let urlString = "https://fcm.googleapis.com/fcm/send"
    let url = NSURL(string: urlString)!
    let paramString: [String:Any] = ["to":token,
                                                                                                                   "notification":["title":title, "body":body, "sound":"notif_sound"],
                                     "data":["user":"test_id"]
    ]
    
    let request = NSMutableURLRequest(url: url as URL)
    request.httpMethod = "POST"
    request.httpBody = try? JSONSerialization.data(withJSONObject: paramString, options: [.prettyPrinted])
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("key=AIzaSyCEg1yDFh0rQ8C2gBfJg0lzXnhFc2OmJIE", forHTTPHeaderField: "Authorization")
    
    let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
      do{
        if let jsonData = data{
          if let jsonDataDict = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject]{
            NSLog("Received data:\n\(jsonDataDict)")
          }
        }
      } catch let err as NSError{
        print(err.debugDescription)
      }
    }
    task.resume()
  }
}

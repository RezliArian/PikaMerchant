//
//  MerchantModel.swift
//  PIkaMerchant
//
//  Created by Johanes Steven on 07/01/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase

struct Merchant: Codable {
  let merchantID: String
  let merchantName: String
  let imageUrl: String?
  let address: String
  let description: String?
  let phoneNumber: String
  let location: GeoPoint
  let fcmToken: String?
  var distance: Double?
  var isMerchantOpen: Bool
}

struct MerchantProfileCache {
  static let key = "savedMerchant"
  static func save(_ value: Merchant!) {
    UserDefaults.standard.set(try? PropertyListEncoder().encode(value), forKey: key)
  }
  
  static func get() -> Merchant! {
    var merchantData: Merchant!
    if let data = UserDefaults.standard.value(forKey: key) as? Data {
      merchantData = try? PropertyListDecoder().decode(Merchant.self, from: data)
      return merchantData!
    } else {
      return merchantData
    }
  }
  
  static func updateToFirestore(_ value: Merchant!, completionHandler: @escaping (Error?) -> Void) {
    let merchantData: Merchant! = value
    let db = Firestore.firestore()
    
    let customerRef = db.collection("Merchants")
    customerRef.document(merchantData.merchantID).updateData([
      "isMerchantOpen": merchantData.isMerchantOpen
      ]) { err in
      if let err = err {
          completionHandler(err)
      } else {
          completionHandler(nil)
      }
    }
  }
  
  static func getMerchantFromFirestore(merchantID: String, completionHandler: @escaping(Merchant?) -> Void) {
    let db = Firestore.firestore()
    let docRef = db.collection("Merchants").document(merchantID)
     
    docRef.getDocument { (document, err) in
      if let err = err {

      } else {
        let merchant = try! FirestoreDecoder().decode(Merchant.self, from: (document?.data())!)
        DispatchQueue.main.async {
          completionHandler(merchant)
        }
      }
    }

  }
  
  static func remove() {
    UserDefaults.standard.removeObject(forKey: key)
  }
}

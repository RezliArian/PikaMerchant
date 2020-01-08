//
//  OrderModel.swift
//  PIkaMerchant
//
//  Created by Johanes Steven on 25/11/19.
//  Copyright © 2019 Apple Developer Academy. All rights reserved.
//

import Foundation
import CodableFirebase
import Firebase

// MARK: - OrderModel
struct OrderModel: Codable {
  let customerID, customerName: String?
  let discount: Int?
  let merchantID: String?
  let orderDetail: [OrderDetail]?
  let orderID, status: String?
  let orderDate: Timestamp?
  let subtotal, orderNo, total: Int?
  let estimationTime: Timestamp?
  let paymentType: String?
}

// MARK: - OrderDetail
struct OrderDetail: Codable {
  let menuID, menuName, note: String?
  let price, quantity: Int?
}

extension Timestamp: TimestampType {}

struct UserModel: Codable {
  let uid: String
  let phoneNumber: String
  let email: String
  let firstName: String
  let fcmToken: String
  let userId: String
  var orderCounter: Int
}

struct OrderCache {
  static func getOrderDataByDate(merchantID: String, completionHandler: @escaping([OrderModel]?, Error?) -> Void) {
    
    var orders: [OrderModel] = []
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM dd, yyyy"
    
    let result = formatter.string(from: Date())

    let startDate = result + " " + "00:00:00"
    let endDate = result + " " + "23:59:00"

    formatter.dateFormat = "MMMM dd, yyyy HH:mm:ss"
    
    let startTime: Date = formatter.date(from: startDate)!
    let startTimestamp: Timestamp = Timestamp(date: startTime)

    let endTime: Date = formatter.date(from: endDate) ?? Date()
    let endTimestamp: Timestamp = Timestamp(date: endTime)
    
    let db = Firestore.firestore()
    let docRef = db.collection("Orders")
    var err: Error?
    
    print("starttimestamp : \(startTimestamp)")
    print("endtimestamp : \(endTimestamp)")
    
    docRef.whereField("merchantID", isEqualTo: merchantID)
    .whereField("orderDate", isGreaterThanOrEqualTo: startTimestamp)
    .whereField("orderDate", isLessThanOrEqualTo: endTimestamp)
    .addSnapshotListener { querySnapshot, error in
      guard let documents = querySnapshot?.documents
        else {
          print("Error fetching documents: \(error!)")
          err = error
          return
        }
      orders.removeAll()
      for document in documents {
        let order = try! FirestoreDecoder().decode(OrderModel.self, from: document.data())
        if order.status != "pending" {
          orders.append(order)
        }
      }
      DispatchQueue.main.async {
        completionHandler(orders, err)
      }
    }
  }
}

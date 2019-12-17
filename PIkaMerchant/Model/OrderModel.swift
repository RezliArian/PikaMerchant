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

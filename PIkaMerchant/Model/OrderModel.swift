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
struct Order: Codable {
  let customerID, customerName: String?
  let discount: Int?
  let merchantID: String
  let orderDetail: [OrderDetail]?
  let orderID, orderNo, status: String?
  let orderDate: Timestamp?
  let subtotal, total: Int?
}

// MARK: - OrderDetail
struct OrderDetail: Codable {
  let menuID, menuName, note: String?
  let price, quantity: Int?
}

extension Timestamp: TimestampType {}

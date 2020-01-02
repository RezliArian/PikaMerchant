//
//  MenuModel.swift
//  PIkaMerchant
//
//  Created by Rezli Arian Perdana on 30/12/19.
//  Copyright © 2019 Apple Developer Academy. All rights reserved.
//

import Foundation
import CodableFirebase
import Firebase

// MARK: - MerchantModel
struct MenuModel: Codable {
  let menu: [Menu]
}

struct Menu: Codable {
  let merchantID: String
  let merchantName: String
  let menuID: String?
  let menuName: String
  let price: Int
  let address: String
  let description: String?
  let recommended: Bool
  let imageUrl: String?
  var distance: Double = 0
  let location: GeoPoint
  let menuRating: Float?
  let queue: Int?
  //var favorite: Bool = false
}

extension GeoPoint: GeoPointType {}

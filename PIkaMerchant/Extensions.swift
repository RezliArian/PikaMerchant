//
//  Extensions.swift
//  PIkaMerchant
//
//  Created by Johanes Steven on 09/01/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import Foundation

extension Formatter {
  static let withSeparator: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.groupingSeparator = "."
    formatter.numberStyle = .decimal
    return formatter
  }()
  
  static func dateFormatter(seconds: Int, needDate: Bool) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
    dateFormatter.dateStyle = DateFormatter.Style.none
    if needDate {
      dateFormatter.dateStyle = DateFormatter.Style.long //Set date style
    }
    dateFormatter.timeZone = TimeZone.current
   
    let dateString = "\(String(describing: seconds))"
    let newDate = NSDate.init(timeIntervalSince1970: Double(dateString)!)

    let currentDate = dateFormatter.string(from: newDate as Date)
   
    return currentDate
  }
}

extension BinaryInteger {
  var formattedWithSeparator: String {
    return Formatter.withSeparator.string(for: self) ?? ""
  }
}

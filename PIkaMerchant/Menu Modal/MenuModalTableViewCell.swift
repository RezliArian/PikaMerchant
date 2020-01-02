//
//  MenuModalTableViewCell.swift
//  PIkaMerchant
//
//  Created by Rezli Arian Perdana on 30/12/19.
//  Copyright © 2019 Apple Developer Academy. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase

class MenuModalTableViewCell: UITableViewCell {

  @IBOutlet weak var view1: UIView!
  @IBOutlet weak var imgFood: UIImageView!
  @IBOutlet weak var lblPrice: UILabel!
  @IBOutlet weak var lblRate: UILabel!
  @IBOutlet weak var lblTime: UILabel!
  @IBOutlet weak var lblName: UILabel!
  @IBOutlet weak var lblDescription: UILabel!
  
  var userToken: String? = nil
  
  var dataMenu: [Menu]=[]
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    view1.setBorderShadow(color: .gray, shadowRadius: 8, shadowOpactiy: 0.16, shadowOffsetWidth: 0, shadowOffsetHeight: 4 )
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

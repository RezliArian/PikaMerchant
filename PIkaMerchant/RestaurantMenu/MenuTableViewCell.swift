//
//  MenuTableViewCell.swift
//  PIkaMerchant
//
//  Created by Rezli Arian Perdana on 23/12/19.
//  Copyright © 2019 Apple Developer Academy. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

  
  @IBOutlet weak var view1: UIView!
  @IBOutlet weak var lblMenuName: UILabel!
  @IBOutlet weak var lblStatus: UILabel!
  
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

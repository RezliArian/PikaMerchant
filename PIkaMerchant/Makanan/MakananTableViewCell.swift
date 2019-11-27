//
//  MakananTableViewCell.swift
//  PIkaMerchant
//
//  Created by Rezli Arian Perdana on 13/11/19.
//  Copyright © 2019 Apple Developer Academy. All rights reserved.
//

import UIKit

class MakananTableViewCell: UITableViewCell {

  @IBOutlet weak var lblMakanan: UILabel!
  @IBOutlet weak var lblDeskripsi: UILabel!
  @IBOutlet weak var lblPorsi: UILabel!
  @IBOutlet weak var border: UIView!
  

  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    border.setBorderShadow(color: .gray, shadowRadius: 8, shadowOpactiy: 0.16, shadowOffsetWidth: 0, shadowOffsetHeight: 4 )
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

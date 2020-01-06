//
//  PendapatanTableViewCell.swift
//  PIkaMerchant
//
//  Created by Rezli Arian Perdana on 03/01/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit

class PendapatanTableViewCell: UITableViewCell {
  
  
  @IBOutlet weak var lblTime: UILabel!
  @IBOutlet weak var lblName: UILabel!
  @IBOutlet weak var lblOrders: UILabel!
  @IBOutlet weak var lblPrice: UILabel!
  @IBOutlet weak var imgPayment: UIImageView!
  

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

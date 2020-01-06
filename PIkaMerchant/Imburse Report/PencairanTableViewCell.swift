//
//  PencairanTableViewCell.swift
//  PIkaMerchant
//
//  Created by Rezli Arian Perdana on 06/01/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit

class PencairanTableViewCell: UITableViewCell {

  @IBOutlet weak var imgImburse: UIImageView!
  @IBOutlet weak var lblTime: UILabel!
  @IBOutlet weak var lblStatus: UILabel!
  @IBOutlet weak var lblPrice: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

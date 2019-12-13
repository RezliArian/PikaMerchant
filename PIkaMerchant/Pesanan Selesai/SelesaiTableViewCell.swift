//
//  SelesaiTableViewCell.swift
//  PIkaMerchant
//
//  Created by Rezli Arian Perdana on 12/11/19.
//  Copyright © 2019 Apple Developer Academy. All rights reserved.
//

import UIKit

class SelesaiTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblItems: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
      
      
    }
    
}

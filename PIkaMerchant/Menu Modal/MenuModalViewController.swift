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

class MenuModalViewController: UIViewController {

  @IBOutlet weak var imageView: UIImageView!
  
  @IBOutlet weak var labelMenuName: UILabel!
  
  @IBOutlet weak var labelPrice: UILabel!
  
  @IBOutlet weak var labelDescription: UILabel!
  
  @IBOutlet weak var labelRate: UILabel!
  
  @IBOutlet weak var labelDistance: UILabel!
  
  var userToken: String? = nil
  
  var menuModal: Menu!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    setMenu()
  }


//  override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
//  func setMenuModel(menuDetails:[Menu]) {
//    for menuDetail in menuDetails {
//      detailMenu.append(menuDetail)
//    }
//  }
  
  
  func setMenuModel(menuModel: Menu) {
    menuModal = menuModel
  }
  
  func setMenu() {
    labelMenuName.text = menuModal.menuName
    labelDescription.text = menuModal.description
    labelPrice.text = "\(menuModal.price)"
    labelDistance.text = "\(menuModal.distance)"
    imageView.image = UIImage(named: menuModal.imageUrl!)
  }
  
//  init(menuModel: Menu) {
//    menuModal = menuModel
//
//   super.init(nibName: nil, bundle: nil)
//  }
  
}

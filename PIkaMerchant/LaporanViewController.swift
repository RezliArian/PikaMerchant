//
//  LaporanViewController.swift
//  PIkaMerchant
//
//  Created by Rezli Arian Perdana on 03/01/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit

class LaporanViewController: UIViewController {
  
  @IBOutlet weak var viewBalance: UIView!
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewBalance.setBorderShadow(color: .gray, shadowRadius: 8, shadowOpactiy: 0.16, shadowOffsetWidth: 0, shadowOffsetHeight: 4 )
  }
  
//  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//  }
//
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//  }
  
  
}

//
//  LaporanViewController.swift
//  PIkaMerchant
//
//  Created by Rezli Arian Perdana on 03/01/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase

class LaporanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var viewBalance: UIView!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var laporanTableView: UITableView!
  
  var dataIncome: [OrderModel]=[]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewBalance.setBorderShadow(color: .gray, shadowRadius: 8, shadowOpactiy: 0.16, shadowOffsetWidth: 0, shadowOffsetHeight: 4 )
    
    getCurrentDate()
    
    let nib = UINib(nibName: "PendapatanTableViewCell", bundle: nil)
    self.laporanTableView.register(nib, forCellReuseIdentifier: "incomeCell")
    
    laporanTableView.delegate = self
    laporanTableView.dataSource = self
    laporanTableView.rowHeight = 100
    
  }
  
  func getCurrentDate(){
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMMM yyyy"
    let str = formatter.string(from: Date())
    dateLabel.text = str
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataIncome.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
      let orders = dataIncome[indexPath.row]
      let cell = laporanTableView.dequeueReusableCell(withIdentifier: "incomeCell", for: indexPath) as! PendapatanTableViewCell
      
      cell.lblName.text = orders.customerName
      cell.lblTime.text = "06:40"
      cell.imgPayment.image = UIImage(named: orders.paymentType!)
      cell.lblPrice.text = "\(orders.total!)"
      cell.lblOrders.text = "\(orders.customerName?.count)"
      
      return cell
  }
}

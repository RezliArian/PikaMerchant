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
  
  @IBOutlet weak var totalAmountLabel: UILabel!
  
  var merchant: Merchant!
  var dataIncome: [OrderModel]=[]
  
  var totalAmount: Int = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    merchant = MerchantProfileCache.get()
    
    viewBalance.setBorderShadow(color: .gray, shadowRadius: 8, shadowOpactiy: 0.16, shadowOffsetWidth: 0, shadowOffsetHeight: 4 )
    
    getCurrentDate()
    
    let nib = UINib(nibName: "PendapatanTableViewCell", bundle: nil)
    self.laporanTableView.register(nib, forCellReuseIdentifier: "incomeCell")
    
    laporanTableView.delegate = self
    laporanTableView.dataSource = self
    laporanTableView.rowHeight = 100
    
    OrderCache.getOrderDataByDate(merchantID: merchant.merchantID) { (orders, error) in
      if let error = error {
        
      } else {
        guard let orders = orders else {return}
        self.dataIncome.removeAll()
        self.totalAmount = 0
        for order in orders {
          self.dataIncome.append(order)
          self.totalAmount += order.total!
        }
        
        let x = self.totalAmount.formattedWithSeparator

        self.totalAmountLabel.text = "Rp \(x)"
        self.laporanTableView.reloadData()
      }
    }
    
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
    
    var date = ""
    let seconds = orders.orderDate?.seconds
    if let seconds = seconds {
      date = Formatter.dateFormatter(seconds: Int(seconds), needDate: false)
    }
    cell.lblTime.text = "\(date)"
    cell.imgPayment.image = UIImage(named: orders.paymentType!)
    
    let x = orders.total!.formattedWithSeparator

    cell.lblPrice.text = "+ Rp \(x)"
    cell.lblOrders.text = "\((orders.orderDetail?.count)!) Macam Hidangan"
    
    return cell
  }
}

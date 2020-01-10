//
//  MakananViewController.swift
//  PIkaMerchant
//
//  Created by Rezli Arian Perdana on 13/11/19.
//  Copyright © 2019 Apple Developer Academy. All rights reserved.
//

import UIKit

class SiapCell:UITableViewCell {
  @IBOutlet weak var btnDone: UIButton!
  @IBOutlet weak var detailPembayaranLbl: UILabel!
  @IBOutlet weak var totalLbl: UILabel!
  @IBOutlet weak var priceLbl: UILabel!
  @IBOutlet weak var viewMetodePembayaran: UIImageView!
}

class MakananViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  var cekMakanan:[MakananModel]=[]
  var cekFood:[OrderDetail]=[]
  var cekSelesai:[OrderModel]=[]
  @IBOutlet weak var makananTableView: UITableView!
  
  @IBOutlet weak var nama: UILabel!
  @IBOutlet weak var orderId: UILabel!
  @IBOutlet weak var caraPenyajian: UILabel!
  @IBOutlet weak var lblCaraPenyajian: UILabel!
  @IBOutlet weak var estimasi: UILabel!
  
  @IBOutlet weak var dateModal: UILabel!
  @IBOutlet weak var diambilDalamlbl: UILabel!
  @IBOutlet weak var menuPesananlbl: UILabel!
  @IBOutlet weak var view1: UIView!
  @IBOutlet weak var view2: UIView!
  
  var delegate:doneServe?
  
  
  var orderModal: OrderModel!
  var makan: OrderDetail!
  var indikator:Int!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print("jumlah makanan:  ", cekFood.count)
    
    getCurrentDate()

    let nib4 = UINib(nibName: "MakananTableViewCell", bundle: nil)
    self.makananTableView.register(nib4, forCellReuseIdentifier: "makananCell")
    
    makananTableView.delegate = self
    makananTableView.dataSource = self
    
//    if indikator == 1{
//      nama.text = pesananModal.customerName
//    }else if indikator == 2{
//      nama.text = selesaiModal.customerName
//    }else if indikator == 3{
//      nama.text = diambilModal.customerName
//    }
    nama.text = orderModal.customerName
    
    nama.font = UIFont.boldSystemFont(ofSize: 20)
    lblCaraPenyajian.font = UIFont.boldSystemFont(ofSize: 20)
    caraPenyajian.font = UIFont.boldSystemFont(ofSize: 20)
    diambilDalamlbl.font = UIFont.boldSystemFont(ofSize: 20)
    menuPesananlbl.font = UIFont.boldSystemFont(ofSize: 20)

    view1.setBorderShadow(color: .gray, shadowRadius: 8, shadowOpactiy: 0.16, shadowOffsetWidth: 0, shadowOffsetHeight: 4 )
    view2.setBorderShadow(color: .gray, shadowRadius: 8, shadowOpactiy: 0.16, shadowOffsetWidth: 0, shadowOffsetHeight: 4 )
    
    orderId.text = orderModal.orderID
    
  }
  
  func setOrderModel(orderDetails: [OrderDetail]) {
    for orderDetail in orderDetails {
      cekFood.append(orderDetail)
    }
  }
  
  func getCurrentDate(){
    var date = ""
    let seconds = orderModal.orderDate?.seconds
    if let seconds = seconds {
      date = Formatter.dateFormatter(seconds: Int(seconds), needDate: true)
    }
    dateModal.text = "\(date)"
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0{
//      return cekMakanan.count
      return cekFood.count
    }
    return 1
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 0{
      return 100
    }
    return 200
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let menu = cekFood[indexPath.row]
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "makananCell", for: indexPath) as! MakananTableViewCell
      
      cell.lblMakanan.text = menu.menuName
      cell.lblDeskripsi.text = menu.note
      cell.lblPorsi.text = "\(menu.quantity!)"

      return cell
    }
    let cell = tableView.dequeueReusableCell(withIdentifier: "siapCell",for: indexPath) as! SiapCell
    
    let x = orderModal.total!.formattedWithSeparator

    cell.priceLbl.text = "Rp \(x)"

      
    return cell
  }
  
  @IBAction func btnServed(_ sender: UIButton) {
    if indikator == 0{
    delegate?.delFromRow()
    dismiss(animated: true, completion: nil)
    }else if indikator == 1{
      delegate?.delFromRow()
      dismiss(animated: true, completion: nil)
    }
  }
  
  
}

protocol doneServe {
  func delFromRow()
}

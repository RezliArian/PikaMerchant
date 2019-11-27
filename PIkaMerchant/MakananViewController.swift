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
  @IBOutlet weak var detailPembayaran: UILabel!
  @IBOutlet weak var total: UILabel!
  @IBOutlet weak var border1: UIView!
}

class MakananViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  var cekMakanan:[MakananModel]=[]
  @IBOutlet weak var makananTableView: UITableView!
  
  @IBOutlet weak var nama: UILabel!
  @IBOutlet weak var orderId: UILabel!
  @IBOutlet weak var jam: UILabel!
  @IBOutlet weak var caraPenyajian: UILabel!
  @IBOutlet weak var bungkus: UILabel!
  @IBOutlet weak var estimasi: UILabel!
  
  @IBOutlet weak var dateModal: UILabel!
  
  @IBOutlet weak var waktuPengambilan: UILabel!
  @IBOutlet weak var menuPesanan: UILabel!
  @IBOutlet weak var border: UIView!
  @IBOutlet weak var border2: UIView!
  
  var delegate:doneServe?
  
  
  var pesmod: PesananModel!
  var slsmod: SelesaiModel!
  var indikator:Int!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    getCurrentDate()

    let done = MakananModel(makanan: "Ayam mie", deskripsi: "Ayam yang digoreng dengan bumbu indomie", porsi: "10 porsi")
    
    cekMakanan.append(done)
    
    let nib4 = UINib(nibName: "MakananTableViewCell", bundle: nil)
    self.makananTableView.register(nib4, forCellReuseIdentifier: "makananCell")
    
    makananTableView.delegate = self
    makananTableView.dataSource = self
    
    if indikator == 1{
      nama.text = pesmod.name
      jam.text = pesmod.time
      estimasi.text = pesmod.estimation
    } else if indikator == 2{
      nama.text = slsmod.name
      jam.text = slsmod.time
      estimasi.text = slsmod.estimation
      
    }
    
    caraPenyajian.font = UIFont.boldSystemFont(ofSize: 20)
    nama.font = UIFont.boldSystemFont(ofSize: 25)
    waktuPengambilan.font = UIFont.boldSystemFont(ofSize: 20)
    menuPesanan.font = UIFont.boldSystemFont(ofSize: 20)
    caraPenyajian.font = UIFont.boldSystemFont(ofSize: 20)
    bungkus.font = UIFont.boldSystemFont(ofSize: 20)
    
    border.setBorderShadow(color: .gray, shadowRadius: 8, shadowOpactiy: 0.16, shadowOffsetWidth: 0, shadowOffsetHeight: 4 )
    
    border2.setBorderShadow(color: .gray, shadowRadius: 8, shadowOpactiy: 0.16, shadowOffsetWidth: 0, shadowOffsetHeight: 4 )
    
    
  }
  
  func getCurrentDate(){
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMMM yyyy"
    let str = formatter.string(from: Date())
    dateModal.text = str
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0{
      return cekMakanan.count
    }
    return 1
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 0{
      return 100
    }
    return 300
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let ngetes = cekMakanan[indexPath.row]
    if indexPath.section == 0{
      let cell = tableView.dequeueReusableCell(withIdentifier: "makananCell", for: indexPath) as! MakananTableViewCell

      
      cell.lblMakanan.text = ngetes.makanan
      cell.lblDeskripsi.text = ngetes.deskripsi
      cell.lblPorsi.text = ngetes.porsi
      
      return cell
    }else if indikator == 2{
      let cell = tableView.dequeueReusableCell(withIdentifier: "siapCell",for: indexPath) as! SiapCell
      
      cell.detailPembayaran.font = UIFont.boldSystemFont(ofSize: 20)
      cell.total.font = UIFont.boldSystemFont(ofSize: 20)
      cell.border1.setBorderShadow(color: .gray, shadowRadius: 8, shadowOpactiy: 0.16, shadowOffsetWidth: 0, shadowOffsetHeight: 4 )
      
      cell.btnDone.isHidden = true
      
      return cell
    }
    let cell = tableView.dequeueReusableCell(withIdentifier: "siapCell", for: indexPath) as! SiapCell
    cell.detailPembayaran.font = UIFont.boldSystemFont(ofSize: 20)
    cell.total.font = UIFont.boldSystemFont(ofSize: 20)
    cell.border1.setBorderShadow(color: .gray, shadowRadius: 8, shadowOpactiy: 0.16, shadowOffsetWidth: 0, shadowOffsetHeight: 4 )
    
    return cell
  }
  
  @IBAction func btnServed(_ sender: UIButton) {
    delegate?.delFromRow()
    dismiss(animated: true, completion: nil)
    let notip = PushNotificationSender()
    notip.sendPushNotification(to: "ebT4eQF8kVs:APA91bHa4qPAVMk_KSkgRkCj9mT8mOUMnJInw77rZ-MxH5d0N_0zu4gZovgnby83FvAJa0pC6_PhWTxoFRYIH0n8w9qLMgfBmxzxBVSj68DlaqH_usnk5z6nU7qoCwd0XMWx5ojGhnCv", title: "title", body: "body")
  }
  
  
}

protocol doneServe {
  func delFromRow()
}

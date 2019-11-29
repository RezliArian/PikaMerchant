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
  
}

class MakananViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  var cekMakanan:[MakananModel]=[]
  @IBOutlet weak var makananTableView: UITableView!
  
  @IBOutlet weak var nama: UILabel!
  @IBOutlet weak var orderId: UILabel!
  @IBOutlet weak var jam: UILabel!
  @IBOutlet weak var caraPenyajian: UILabel!
  @IBOutlet weak var estimasi: UILabel!
  
  @IBOutlet weak var dateModal: UILabel!
  
  
  var delegate:doneServe?
  
  
  var pesmod: Order!
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
      nama.text = pesmod.customerName
      jam.text = "10"
      estimasi.text = "10"
    } else if indikator == 2{
      nama.text = slsmod.name
      jam.text = slsmod.time
      estimasi.text = slsmod.estimation
      
    }
    
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
    return 200
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
      
      cell.btnDone.isHidden = true
      
      return cell
    }
    let cell = tableView.dequeueReusableCell(withIdentifier: "siapCell", for: indexPath)
    
    return cell
  }
  
  @IBAction func btnServed(_ sender: UIButton) {
    delegate?.delFromRow()
    dismiss(animated: true, completion: nil)
  }
  
  
}

protocol doneServe {
  func delFromRow()
}

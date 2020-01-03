//
//  RestoranViewController.swift
//  PIkaMerchant
//
//  Created by Rezli Arian Perdana on 27/12/19.
//  Copyright © 2019 Apple Developer Academy. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase

class RestoranViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var view1: UIView!
  @IBOutlet weak var menuTableView: UITableView!
  @IBOutlet weak var lblStatusRestoran: UILabel!
  @IBOutlet weak var switchStatus: UISwitch!
  
  var merchantID: String = "LAD01"
  var dataMenu: [Menu]=[]
  var selectedIndex: Int?
  
    override func viewDidLoad() {
      super.viewDidLoad()
      
      view1.setBorderShadow(color: .gray, shadowRadius: 8, shadowOpactiy: 0.16, shadowOffsetWidth: 0, shadowOffsetHeight: 4 )
      
      let nib = UINib(nibName: "MenuTableViewCell", bundle: nil)
      self.menuTableView.register(nib, forCellReuseIdentifier: "menuCell")
      
      let nib2 = UINib(nibName: "MenuModalTableViewCell", bundle: nil)
      self.menuTableView.register(nib2, forCellReuseIdentifier: "detailMenuCell")
      
      menuTableView.delegate = self
      menuTableView.dataSource = self
      menuTableView.rowHeight = 100
      
      self.setMenuByMerchant(merchantID: self.merchantID){
        self.menuTableView.reloadData()
      }
      
    }
  
  override func prepare(for segue:UIStoryboardSegue, sender: Any?){
//    if segue.identifier == "tesSegue"{
//      if let detailVC = segue.destination as? MenuModalTableViewCell{
//
//        detailVC.setMenuModel(menuDetails: [dataMenu[selectedIndex!]].self)
//        detailVC.menuModal = self.dataMenu[selectedIndex!]
//      }
//    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    selectedIndex = indexPath.row
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let menuDetailViewController = storyboard.instantiateViewController(withIdentifier: "menuModalVC") as! MenuModalViewController
    menuDetailViewController.setMenuModel(menuModel: dataMenu[selectedIndex!])
    
    self.present(menuDetailViewController, animated: true, completion: nil)
//    performSegue(withIdentifier: "tesSegue", sender: indexPath.row)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0{
      return dataMenu.count
    }
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let orders = dataMenu[indexPath.row]
      let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuTableViewCell
      
      cell.lblMenuName.text = orders.menuName
      if (orders.recommended){
        cell.lblStatus.text = "Tersedia"
        cell.lblStatus.textColor = .init(cgColor: #colorLiteral(red: 0.4745098039, green: 0.7098039216, blue: 0.08235294118, alpha: 1))
      }else {
        cell.lblStatus.text = "Tidak tersedia"
      }
      return cell
    }
    else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuTableViewCell
      return cell
    }
//    let detailOrders = dataMenu[indexPath.row]
//    let cell = tableView.dequeueReusableCell(withIdentifier: "detailMenuCell", for: indexPath) as! MenuModalTableViewCell
//
//    cell.lblName.text = detailOrders.menuName
//    cell.lblDescription.text = detailOrders.description
//    cell.lblPrice.text = "\(detailOrders.price)"
//    cell.lblTime.text = "\(detailOrders.distance)"
//    cell.imgFood.image = UIImage(named: detailOrders.imageUrl!)
//
//    return cell
  }
  
  @IBAction func switchFunction(_ sender: Any) {
    if switchStatus.isOn{
      lblStatusRestoran.text = "Buka"
      menuTableView.isHidden = false
    }else {
      lblStatusRestoran.text = "Tutup"
      menuTableView.isHidden = true
    }
  }
}

extension RestoranViewController {
  func getMenuByMerchant(merchantID: String, completionHandler: @escaping(QuerySnapshot?, Error?) -> Void) {
    
    let db = Firestore.firestore()

    let docRef = db.collection("Menus")
    let query = docRef.whereField("merchantID", isEqualTo: merchantID)
    
    query.getDocuments { (querySnapshot, err) in
      if let err = err {
        completionHandler(nil, err)
        
      } else {
        completionHandler(querySnapshot, nil)
      }
    }
  }
  func setMenuByMerchant(merchantID: String, completionHandler: @escaping() -> Void) {
    getMenuByMerchant(merchantID: merchantID) { (querySnapshot, error) in
      if error == nil && querySnapshot?.count != 0 {
        for document in querySnapshot!.documents {
          let menu = try! FirestoreDecoder().decode(Menu.self, from: document.data())
          self.dataMenu.append(menu)
        }
      }
      else if error != nil {
        print(error!)
      }
      DispatchQueue.main.async {
        completionHandler()
      }
    }
  }
}

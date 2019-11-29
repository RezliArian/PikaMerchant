//
//  PesananViewController.swift
//  PIkaMerchant
//
//  Created by Rezli Arian Perdana on 11/11/19.
//  Copyright © 2019 Apple Developer Academy. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase

class PesananViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
  var cekPesanan:[PesananModel]=[]
  var cekSelesai:[SelesaiModel]=[]
  var moveToDone: Order!
  
  var pesananModel: [Order] = []
  
  @IBOutlet weak var pesananTableView: UITableView!
  @IBOutlet weak var seqmen: UISegmentedControl!
  @IBOutlet weak var dateLabel: UILabel!

  var proses: UITableViewCell!
  var selesai: UITableViewCell!
  var selectedIndex: Int?
  
  func getCurrentDate(){
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMMM yyyy"
    let str = formatter.string(from: Date())
    dateLabel.text = str
  }
    
  override func viewDidLoad() {
        
    super.viewDidLoad()

    getCurrentDate()
      
    let nib2 = UINib(nibName: "PesananTableViewCell", bundle: nil)
    self.pesananTableView.register(nib2, forCellReuseIdentifier: "pesananCell")

    let nib3 = UINib(nibName: "SelesaiTableViewCell", bundle: nil)
    self.pesananTableView.register(nib3, forCellReuseIdentifier: "selesaiCell")


    pesananTableView.delegate = self
    pesananTableView.dataSource = self
    
    setPesananData {
      self.pesananTableView.reloadData()
      print("pesanan : \(self.pesananModel.count), ")
      
    }
    
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "tesSegue"{
      if let nextVC = segue.destination as? MakananViewController{
        if seqmen.selectedSegmentIndex == 0{
          nextVC.indikator = 1
          nextVC.pesmod = self.pesananModel[selectedIndex!]
          nextVC.delegate = self
        }else{
          nextVC.indikator = 2
          nextVC.slsmod = self.cekSelesai[selectedIndex!]
        }
      }
    }
  }
    
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
      
    let important = importantAction(at: indexPath)
    let delete = deleteAction(at: indexPath)
    return UISwipeActionsConfiguration(actions: [delete, important])
      
  }
    
  func importantAction(at indexPath:IndexPath) -> UIContextualAction {
    let todo = pesananModel[indexPath.row]
    let action = UIContextualAction(style: .normal, title: "Important") { (action, view, completion) in
      completion(true)
    }
    action.image = #imageLiteral(resourceName: "Alarm")
    action.backgroundColor = .gray
    return action
  }
    
  func deleteAction(at indexPath:IndexPath) -> UIContextualAction {
    let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
      self.cekPesanan.remove(at: indexPath.row)
      self.pesananTableView.deleteRows(at: [indexPath], with: .automatic)
    }
    action.image = #imageLiteral(resourceName: "Trash")
    action.backgroundColor = .red
    
    return action
  }
    
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
    
    moveToDone = pesananModel[indexPath.row]
    
    updatePesananStatus(orderID: moveToDone.orderID!) { (error) in
      if error != nil {
        self.pesananTableView.reloadData()
      }
    }
    
    
//    moveToDoneSegmen(moveToDone: moveToDone)
    let complete = completeAction(at: indexPath)
    
    return UISwipeActionsConfiguration(actions: [complete])
  }
    
  func completeAction(at indexPath:IndexPath) -> UIContextualAction {
    let action = UIContextualAction(style: .destructive, title: "Complete") { (action, view, completion) in
//      self.cekPesanan.remove(at: indexPath.row)
//      self.pesananTableView.deleteRows(at: [indexPath], with: .automatic)
    }
    action.image = #imageLiteral(resourceName: "Check")
    action.backgroundColor = .green
    
    return action
  }
  
  func moveToDoneSegmen(moveToDone: Order){
    let newSelesai = SelesaiModel(name: moveToDone.orderNo!, estimation: "10", items: moveToDone.orderDetail![0].menuName!, status: "Pesanan Selesai", time: "10", logo: "logo")
    cekSelesai.append(newSelesai)
  }
    
    @IBAction func UISegmentedControl(_ sender: UISegmentedControl) {
//        switch (seqmen.selectedSegmentIndex) {
//        case 0:
//            let nib2 = UINib(nibName: "PesananTableViewCell", bundle: nil)
//            self.pesananTableView.register(nib2, forCellReuseIdentifier: "pesananCell")
//            break
//        case 1:
//            let nib3 = UINib(nibName: "SelesaiTableViewCell", bundle: nil)
//            self.pesananTableView.register(nib3, forCellReuseIdentifier: "pesananCell")
//            break
//        default:
//            break
//        }
        
        pesananTableView.reloadData()
    }
    
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
    var returnValue = 0
    
    switch (seqmen.selectedSegmentIndex) {
      case 0:
        returnValue = pesananModel.count
        break
      case 1:
        returnValue = cekSelesai.count
        break
      default:
        break
    }
      
    return returnValue
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedIndex = indexPath.row
    performSegue(withIdentifier: "tesSegue", sender: indexPath.row)
  }
    
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    tableView.clearsContextBeforeDrawing = true
    tableView.rowHeight = 100
    
    if seqmen.selectedSegmentIndex == 0 {

      let ngetes = pesananModel[indexPath.row]
      let cell = tableView.dequeueReusableCell(withIdentifier: "pesananCell", for: indexPath) as! PesananTableViewCell
      
      cell.lblName.text = ngetes.orderID
      cell.lblPickupTime.text = "10"
//      cell.lblItems.text = ngetes.orderDetail![0].menuName!
      cell.lblTime.text = "10"
//      cell.imgLogo.image = UIImage(named: ngetes.logo)
      return cell
    }
    
    let ngetes1 = cekSelesai[indexPath.row]
    
    let cell1 = tableView.dequeueReusableCell(withIdentifier: "selesaiCell", for: indexPath) as! SelesaiTableViewCell
    
    cell1.lblName.text = ngetes1.name
    cell1.lblItems.text = ngetes1.items
    cell1.lblStatus.text = ngetes1.status
    cell1.lblTime.text = ngetes1.time
    cell1.imgLogo.image = UIImage(named: ngetes1.logo)
    
    return cell1
  }
  
}

extension PesananViewController {
  
  func updatePesananStatus(orderID: String, completionHandler: @escaping (Error?) -> Void) {
    
    let db = Firestore.firestore()
    let docRef = db.collection("Orders")
   
    docRef.document(orderID).updateData([
      "status": "ready"
      ]) { err in
      if let err = err {
          completionHandler(err)
      } else {
          completionHandler(nil)
      }
    }
  }
  
  func getPesananData(merchantID: String, completionHandler: @escaping(QuerySnapshot?, Error?) -> Void) {
    
    let db = Firestore.firestore()
    let docRef = db.collection("Orders")
    
    docRef.whereField("merchantID", isEqualTo: merchantID)
    .addSnapshotListener { querySnapshot, error in
      guard let documents = querySnapshot
        else {
          print("Error fetching documents: \(error!)")
          return
        }
      completionHandler(documents, error)
    }
  }
  func setPesananData(completionHandler: @escaping() -> Void) {
    getPesananData(merchantID: "WKO02") { (querySnapshot, error) in
      if error == nil && querySnapshot?.count != 0 {
        guard let documents = querySnapshot?.documents else { return }
        self.pesananModel.removeAll()
        for document in documents {
          print(document.data())
          let order = try! FirestoreDecoder().decode(Order.self, from: document.data())
          if order.status == "waiting" {
            self.pesananModel.append(order)
            print("order date : \(order.orderDate)")
          }
        }
        completionHandler()
      }
    }
  }
}

extension PesananViewController: doneServe {
  
  func delFromRow() {
    moveToDoneSegmen(moveToDone: pesananModel[self.selectedIndex!])
    pesananModel.remove(at: selectedIndex!)
    self.pesananTableView.reloadData()
    print("deleted!")
  }
  
}

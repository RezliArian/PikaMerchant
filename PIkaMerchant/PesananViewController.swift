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
import AVFoundation

class PesananViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var cekPesanan:[OrderModel]=[]
    var cekSelesai:[OrderModel]=[]
    var cekDiambil:[OrderModel]=[]
    var cekDibayar:[OrderModel]=[]
    var moveToDone: OrderModel!
    var moveToDone1: OrderModel!
    var tempFood: [OrderDetail]=[]
    var player: AVAudioPlayer?
  
    var userToken: String? = nil
  let pushNotifManager = PushNotificationManager(userID: "KAS01")
  
    @IBOutlet weak var pesananTableView: UITableView!
    @IBOutlet weak var seqmen: UISegmentedControl!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lblStatusDescription: UILabel!
  
  
    var proses: UITableViewCell!
    var selesai: UITableViewCell!
    var selectedIndex: Int?
  
  func playSound() {
    let url = Bundle.main.url(forResource: "notif_sound", withExtension: "mp3")!

      do {
        player = try AVAudioPlayer(contentsOf: url)
          guard let player = player else { return }

          player.prepareToPlay()
          player.play()

      } catch let error as NSError {
          print(error.description)
      }
  }
  
  func getCurrentDate(){
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMMM yyyy"
    let str = formatter.string(from: Date())
    dateLabel.text = str
  }
  
  func addDocument(alamat: String, menuID:String, merchantID: String, merchantName: String, menuName: String, price: Int,category:String, description: String, latitude: Double, longitude: Double) {

//    let db = Firestore.firestore()
//    let menuRef = db.collection("Menus_rezli")
    
    print("Masuk Database")
}
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
      
        getCurrentDate()
    
        
        let nib2 = UINib(nibName: "PesananTableViewCell", bundle: nil)
        self.pesananTableView.register(nib2, forCellReuseIdentifier: "pesananCell")

        let nib3 = UINib(nibName: "SelesaiTableViewCell", bundle: nil)
        self.pesananTableView.register(nib3, forCellReuseIdentifier: "selesaiCell")
      
        let nib4 = UINib(nibName: "SelesaiTableViewCell", bundle: nil)
        self.pesananTableView.register(nib4, forCellReuseIdentifier: "diambilCell")
      
        let nib5 = UINib(nibName: "SelesaiTableViewCell", bundle: nil)
        self.pesananTableView.register(nib5, forCellReuseIdentifier: "dibayarCell")
        
        
        pesananTableView.delegate = self
        pesananTableView.dataSource = self
      
      setPesananData {
        self.pesananTableView.reloadData()
        print("pesanan : \(self.cekPesanan.count), ")
      }
      pushNotifManager.updateFirestorePushTokenIfNeeded()

    }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "tesSegue"{
      if let nextVC = segue.destination as? MakananViewController{
        if seqmen.selectedSegmentIndex == 0 {
          nextVC.indikator = 1
          nextVC.setOrderModel(orderDetails: cekPesanan[selectedIndex!].orderDetail!)
          nextVC.selesaiModal = self.cekPesanan[selectedIndex!]
//          nextVC.cekFood = self.tempFood
          nextVC.delegate = self
        }else if seqmen.selectedSegmentIndex == 1{
          nextVC.indikator = 2
          nextVC.setOrderModel(orderDetails: cekSelesai[selectedIndex!].orderDetail!)
          nextVC.selesaiModal = self.cekSelesai[selectedIndex!]
        }else{
          nextVC.indikator = 3
          nextVC.setOrderModel(orderDetails: cekDiambil[selectedIndex!].orderDetail!)
          nextVC.selesaiModal = self.cekDiambil[selectedIndex!]
        }
      }
    }
  }
    

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
      let accept = UIContextualAction(style: .destructive, title: "Done") {
        (action, view, nil) in
        if self.seqmen.selectedSegmentIndex == 0{
          self.updatePesananStatus(orderID: self.cekPesanan[indexPath.row].orderID!, status: "ready") { (error) in
            
          }
        }else if self.seqmen.selectedSegmentIndex == 1{
          self.updatePesananStatus(orderID: self.cekSelesai[indexPath.row].orderID!, status: "collected") { (error) in
          }
        }
      }
      accept.backgroundColor = .green
      
      let notip = PushNotificationSender()
      
      if cekPesanan.count != 0{
        print("customerID: \(self.cekPesanan[indexPath.row].customerID!)")
        getUserData(userId: self.cekPesanan[indexPath.row].customerID!) { (document, err) in
          if err == nil && document != nil{
            let user = try! FirestoreDecoder().decode(UserModel.self, from: document.data()!)
            notip.sendPushNotification(to: user.fcmToken, title: "title", body: "body")
            self.userToken = user.fcmToken
          }else{
            print(err)
          }
          
        }
      }
         
      
      return UISwipeActionsConfiguration(actions: [accept])
    }
    
//    func completeAction(at indexPath:IndexPath) -> UIContextualAction {
//        let action = UIContextualAction(style: .destructive, title: "Complete") {
//          (action, view, nil) in
//          if self.seqmen.selectedSegmentIndex == 0{
//            self.cekPesanan.remove(at: indexPath.row)
//            self.pesananTableView.deleteRows(at: [indexPath], with: .automatic)
//            completion(true)
//          }else if self.seqmen.selectedSegmentIndex == 1{
//            self.cekSelesai.remove(at: indexPath.row)
//            self.pesananTableView.deleteRows(at: [indexPath], with: .automatic)
//            completion(true)
//          }
//
//        }
//        action.image = #imageLiteral(resourceName: "Check")
//        action.backgroundColor = #colorLiteral(red: 0.3930387795, green: 0.6226156354, blue: 0.4152288437, alpha: 1)
//
//      let notip = PushNotificationSender()
//      notip.sendPushNotification(to: "cSdd9FlaY04:APA91bGhfOzEwcozodWACBtNM0B5Jg0tFumQ6ybJ2TmuaMtK9GMMH6BzLltqeax2s33M02FcAe5gqXXot4y4v3ToWwSZy2YwOybvg7kZvSVOWYr0Ix9cCo8shN8qseVU9mRJ349Ba3M8", title: "title", body: "body")
//
//        return action
//    }
  
//  func moveToSelesaiSegment(moveToDone: OrderModel){
//    let newSelesai = OrderModel(customerID: moveToDone.customerID, customerName: moveToDone.customerName, discount: moveToDone.discount, merchantID: moveToDone.merchantID, orderDetail: moveToDone.orderDetail, orderID: moveToDone.orderID, status: moveToDone.status, orderDate: moveToDone.orderDate, subtotal: moveToDone.subtotal, orderNo: moveToDone.orderNo, total: moveToDone.total, estimationTime: moveToDone.estimationTime, paymentType: moveToDone.paymentType)
//    cekSelesai.append(newSelesai)
//  }
//
//  func moveToDiambilSegment(moveToDone1: OrderModel){
//    let newDiambil = OrderModel(customerID: moveToDone.customerID, customerName: moveToDone.customerName, discount: moveToDone.discount, merchantID: moveToDone.customerID, orderDetail: moveToDone.orderDetail, orderID: moveToDone.orderID, status: moveToDone.status, orderDate: moveToDone.orderDate, subtotal: moveToDone.subtotal, orderNo: moveToDone.orderNo, total: moveToDone.total, estimationTime: moveToDone.estimationTime, paymentType: moveToDone.paymentType)
//    cekDiambil.append(newDiambil)
//  }
  
    @IBAction func UISegmentedControl(_ sender: UISegmentedControl) {
        pesananTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var returnValue = 0
        
        switch (seqmen.selectedSegmentIndex) {
        case 0:
            returnValue = cekPesanan.count
            lblStatusDescription.text = "Pesanan Yang Perlu Disiapkan."
            break
        case 1:
            returnValue = cekSelesai.count
            lblStatusDescription.text = "Pesanan Sudah Siap Diambil."
            break
        case 2:
            returnValue = cekDiambil.count
            lblStatusDescription.text = "Pesanan Yang Sudah Diambil."
            break
        case 3:
          lblStatusDescription.text = "Transaksi yang sudah diteruskan ke Penjual."
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
       
            let orders = cekPesanan[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "pesananCell", for: indexPath) as! PesananTableViewCell
            
          //let date = String(orders.estimationTime?.dateValue())
          cell.lblName.text = orders.customerName
          cell.lblPickupTime.text = orders.orderID
          cell.lblItems.text = orders.orderDetail![0].menuName
          cell.lblTime.text = ""
          cell.imgLogo.image = UIImage(named: orders.paymentType!)
          return cell
        }else if seqmen.selectedSegmentIndex == 1{
        
            let done = cekSelesai[indexPath.row]
            
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "selesaiCell", for: indexPath) as! SelesaiTableViewCell
            
          cell1.lblName.text = done.customerName
          cell1.lblItems.text = done.orderDetail![0].menuName
          cell1.lblStatus.text = done.status
          cell1.lblTime.text = ""
          cell1.imgLogo.image = UIImage(named: done.paymentType!)
        
        return cell1
          
      }
      let take = cekDiambil[indexPath.row]
      
      let cell2 = tableView.dequeueReusableCell(withIdentifier: "diambilCell", for: indexPath) as! SelesaiTableViewCell
      
      cell2.lblName.text = take.customerName
      cell2.lblItems.text = take.orderDetail![0].menuName
      cell2.lblStatus.text = take.status
      cell2.lblTime.text = ""
      cell2.imgLogo.image = UIImage(named: take.paymentType!)
      
      return cell2
      
    }
  
}

extension PesananViewController: doneServe{
  func delFromRow() {
    if seqmen.selectedSegmentIndex == 0{
//      moveToSelesaiSegment(moveToDone: cekPesanan[self.selectedIndex!])
      cekPesanan.remove(at: selectedIndex!)
    }else if seqmen.selectedSegmentIndex == 1{
//      moveToDiambilSegment(moveToDone1: cekSelesai[self.selectedIndex!])
      cekSelesai.remove(at: selectedIndex!)
    }
    self.pesananTableView.reloadData()
    print("deleted!")
  }
  
}


extension PesananViewController {
  
  func updatePesananStatus(orderID: String, status: String, completionHandler: @escaping (Error?) -> Void) {
    
    let db = Firestore.firestore()
    let docRef = db.collection("Orders")
   
    docRef.document(orderID).updateData([
      "status": status
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
//      documents.documentChanges.forEach{ diff in
//        if (diff.type == .modified) {
//            self.playSound()
//            print("INI DATA BARU NIH")
//        }
//      }
      completionHandler(documents, error)
    }
    
  }
  
  func getUserData(userId: String, completionHandler: @escaping(DocumentSnapshot, Error?) -> Void) {
      
      let db = Firestore.firestore()
    let docRef = db.collection("Customers").document(userId)
    
    docRef.getDocument { (document, err) in
      if let document = document, document.exists{
        let dataDesc = document.data().map(String.init(describing: )) ?? "nil"
        print("Document data: \(dataDesc)")
        completionHandler(document, err)
      }else{
        print("Document does not exist")
      }
      
    }
    }
  
  func setUserToken(_ cusId: String, _ completionHandler: @escaping() -> Void){
    getUserData(userId: cusId) { (document, err) in
      if err == nil && document != nil{
        let user = try! FirestoreDecoder().decode(UserModel.self, from: document.data()!)
        self.userToken = user.fcmToken
      }else{
        print(err)
      }
    }
  }
  
  func setPesananData(completionHandler: @escaping() -> Void) {
    getPesananData(merchantID: "KAS01") { (querySnapshot, error) in
      if error == nil && querySnapshot?.count != 0 {
        guard let documents = querySnapshot?.documents else { return }
        self.cekPesanan.removeAll()
        self.cekSelesai.removeAll()
        for document in documents {
          print(document.data())
          let order = try! FirestoreDecoder().decode(OrderModel.self, from: document.data())
          querySnapshot?.documentChanges.forEach { diff in
            if (diff.type == .modified) {
              if order.status == "waiting"{
                self.playSound()
              }
            }
          }
          
          if order.status == "waiting" {
            self.cekPesanan.append(order)
            print("order date : \(order.orderDate)")
          } else if order.status == "ready" {
            self.cekSelesai.append(order)
            print("order date : \(order.orderDate)")
          } else if order.status == "collected"{
            self.cekDiambil.append(order)
            print("order date : \(order.orderDate)")
          }
        }
        completionHandler()
      }
    }
  }
}


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
    
  var merchantModel:Merchant!
  
  var cekPesanan:[OrderModel]=[]
  var cekSelesai:[OrderModel]=[]
  var cekDiambil:[OrderModel]=[]
  var cekDibayar:[OrderModel]=[]
  var moveToDone: OrderModel!
  var moveToDone1: OrderModel!
  var tempFood: [OrderDetail]=[]
  var player: AVAudioPlayer?

  var userToken: String? = nil
  var pushNotifManager: PushNotificationManager?

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
      
    
    MerchantProfileCache.getMerchantFromFirestore(merchantID: "LAD01") { (merchant) in
      if let merchant = merchant {
        MerchantProfileCache.save(merchant)
        self.merchantModel = MerchantProfileCache.get()
        self.setPesananData {
          self.pesananTableView.reloadData()
          print("pesanan : \(self.cekPesanan.count), ")
        }
        
        self.pushNotifManager = PushNotificationManager(userID: self.merchantModel.merchantID)
        self.pushNotifManager!.updateFirestorePushTokenIfNeeded()
      }
    }

  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "tesSegue"{
      if let nextVC = segue.destination as? MakananViewController{
        if seqmen.selectedSegmentIndex == 0 {
          nextVC.indikator = 1
          nextVC.setOrderModel(orderDetails: cekPesanan[selectedIndex!].orderDetail!)
          nextVC.orderModal = self.cekPesanan[selectedIndex!]
//          nextVC.cekFood = self.tempFood
          nextVC.delegate = self
        }else if seqmen.selectedSegmentIndex == 1 {
          nextVC.indikator = 2
          nextVC.setOrderModel(orderDetails: cekSelesai[selectedIndex!].orderDetail!)
          nextVC.orderModal = self.cekSelesai[selectedIndex!]
        }else if seqmen.selectedSegmentIndex == 2 {
          nextVC.indikator = 3
          nextVC.setOrderModel(orderDetails: cekDiambil[selectedIndex!].orderDetail!)
          nextVC.orderModal = self.cekDiambil[selectedIndex!]
        } else if seqmen.selectedSegmentIndex == 3 {
          nextVC.indikator = 4
          nextVC.setOrderModel(orderDetails: cekDibayar[selectedIndex!].orderDetail!)
          nextVC.orderModal = self.cekDibayar[selectedIndex!]
        }
      }
    }
  }
  
  func dateFormatter(seconds: Int) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
    dateFormatter.dateStyle = DateFormatter.Style.none //Set date style
    dateFormatter.timeZone = TimeZone.current
    
    let dateString = "\(String(describing: seconds))"
    let newDate = NSDate.init(timeIntervalSince1970: Double(dateString)!)
 
    let currentDate = dateFormatter.string(from: newDate as Date)
    
    return currentDate
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
            notip.sendPushNotification(to: user.fcmToken, title: "PikaFood", body: "Hai, makanan-mu sudah selesai dimasak, ayo ambil pesananmu !")
            self.userToken = user.fcmToken
          }else{
            print(err)
          }
          
        }
      }
         
      
      return UISwipeActionsConfiguration(actions: [accept])
    }
  
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
          returnValue = cekDibayar.count
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
    
      cell.lblName.text = orders.customerName
      cell.lblPickupTime.text = orders.orderID
      cell.lblItems.text = orders.orderDetail![0].menuName
          
      var date = ""
      let seconds = orders.orderDate?.seconds
      if let seconds = seconds {
        date = dateFormatter(seconds: Int(seconds))
      }
      cell.lblTime.text = "\(date)"
      cell.imgLogo.image = UIImage(named: orders.paymentType!)
      return cell
      
    } else if seqmen.selectedSegmentIndex == 1 {
        
      let done = cekSelesai[indexPath.row]
      
      let cell1 = tableView.dequeueReusableCell(withIdentifier: "selesaiCell", for: indexPath) as! SelesaiTableViewCell
            
      cell1.lblName.text = done.customerName
      cell1.lblItems.text = done.orderDetail![0].menuName
      cell1.lblStatus.text = done.status
      cell1.lblTime.text = ""
      cell1.imgLogo.image = UIImage(named: done.paymentType!)
        
      return cell1
          
    } else if seqmen.selectedSegmentIndex == 2 {
      let take = cekDiambil[indexPath.row]
      
      let cell2 = tableView.dequeueReusableCell(withIdentifier: "diambilCell", for: indexPath) as! SelesaiTableViewCell
      
      cell2.lblName.text = take.customerName
      cell2.lblItems.text = take.orderDetail![0].menuName
      cell2.lblStatus.text = take.status
      cell2.lblTime.text = ""
      cell2.imgLogo.image = UIImage(named: take.paymentType!)
      
      return cell2
    }
      let paid = cekDibayar[indexPath.row]
      
      let cell3 = tableView.dequeueReusableCell(withIdentifier: "dibayarCell", for: indexPath) as! SelesaiTableViewCell
      
      cell3.lblName.text = paid.customerName
      cell3.lblItems.text = paid.orderDetail![0].menuName
      cell3.lblStatus.text = paid.status
      cell3.lblTime.text = ""
      cell3.imgLogo.image = UIImage(named: paid.paymentType!)
      
      return cell3
      
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
    if status == "ready" {
      docRef.document(orderID).updateData([
        "status": status,
        "readyDate": FieldValue.serverTimestamp()
        ]) { err in
        if let err = err {
            completionHandler(err)
        } else {
            completionHandler(nil)
        }
      }
    } else if status == "collected" {
      docRef.document(orderID).updateData([
        "status": status,
        "collectedDate": FieldValue.serverTimestamp()
        ]) { err in
        if let err = err {
            completionHandler(err)
        } else {
            completionHandler(nil)
        }
      }
    }
    
  }
  
  func getPesananData(merchantID: String, completionHandler: @escaping(QuerySnapshot?, Error?) -> Void) {
    
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM dd, yyyy"
    
    let result = formatter.string(from: Date())

    let startDate = result + " " + "00:00:00"
    let endDate = result + " " + "23:59:00"

    formatter.dateFormat = "MMMM dd, yyyy HH:mm:ss"
    
    let startTime: Date = formatter.date(from: startDate)!
    let startTimestamp: Timestamp = Timestamp(date: startTime)

    let endTime: Date = formatter.date(from: endDate) ?? Date()
    let endTimestamp: Timestamp = Timestamp(date: endTime)
    
    let db = Firestore.firestore()
    let docRef = db.collection("Orders")
    
    docRef.whereField("merchantID", isEqualTo: merchantID)
    .whereField("orderDate", isGreaterThanOrEqualTo: startTimestamp)
    .whereField("orderDate", isLessThanOrEqualTo: endTimestamp)
    .addSnapshotListener { querySnapshot, error in
      guard let documents = querySnapshot
        else {
          print("Error fetching documents: \(error!)")
          return
        }
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
    getPesananData(merchantID: merchantModel.merchantID) { (querySnapshot, error) in
      if error == nil && querySnapshot?.count != 0 {
        guard let documents = querySnapshot?.documents else { return }
        self.cekPesanan.removeAll()
        self.cekSelesai.removeAll()
        self.cekDiambil.removeAll()
        self.cekDibayar.removeAll()
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
          } else if order.status == "paid"{
            self.cekDibayar.append(order)
          }
        }
        completionHandler()
      }
    }
  }
}


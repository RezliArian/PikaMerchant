//
//  PesananViewController.swift
//  PIkaMerchant
//
//  Created by Rezli Arian Perdana on 11/11/19.
//  Copyright © 2019 Apple Developer Academy. All rights reserved.
//

import UIKit
import Firebase

class PesananViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var cekPesanan:[PesananModel]=[]
    var cekSelesai:[SelesaiModel]=[]
    var moveToDone: PesananModel!
  
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
  
  func addDocument(alamat: String, menuID:String, merchantID: String, merchantName: String, menuName: String, price: Int,category:String, description: String, latitude: Double, longitude: Double) {

    let db = Firestore.firestore()
    let menuRef = db.collection("Menus_rezli")
//    var ref: DocumentReference? = nil


    menuRef.document("\(menuID)").setData([
      "address": "\(alamat)",

      "merchantID": "\(merchantID)",

      "menuID": "\(menuID)",

      "merchantName": "\(merchantName)",

      "menuName": "\(menuName)",

      "price": price,

      "category": category,

      "description": "\(description)",

      "location": GeoPoint(latitude: latitude, longitude: longitude)

    ])


// Random Document ID

//    ref = db.collection("Menus_rezli").addDocument(data: [
//
//    "address": "\(alamat)",
//
//    "merchantID": "\(merchantID)",
//
//    "menuID": "\(menuID)",
//
//    "merchantName": "\(merchantName)",
//
//    "menuName": "\(menuName)",
//
//    "price": price,
//
//    "category": category,
//
//    "description": "\(description)",
//
//    "location": GeoPoint(latitude: latitude, longitude: longitude)
//
//
//      ]) { err in
//
//      if let err = err {
//
//          print("Error adding document: \(err)")
//
//      } else {
//
//          print("Document added with ID: \(ref!.documentID)")
//
//      }
//  }


    print("Masuk Database")
}
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
      
      getCurrentDate()
      
//      addDocument()
        
      let pesan = PesananModel(name: "Randy Cagur", estimation: "16:20", items: "3 items", status: "", time: "08.20", logo: "Go Pay")
        
      let pesan1 = PesananModel(name: "Randy cingur", estimation: "10:20", items: "10 items", status: "", time: "10.20", logo: "Ovo")
        
      //let done = SelesaiModel(name: "Randy Noel", estimation: "", items: "3 items", status: "Pesanan Selesai", time: "09.11", logo: "Go Pay")
        
        cekPesanan.append(pesan)
        cekPesanan.append(pesan1)
        
        //cekSelesai.append(done)
        
        let nib2 = UINib(nibName: "PesananTableViewCell", bundle: nil)
        self.pesananTableView.register(nib2, forCellReuseIdentifier: "pesananCell")

        let nib3 = UINib(nibName: "SelesaiTableViewCell", bundle: nil)
        self.pesananTableView.register(nib3, forCellReuseIdentifier: "selesaiCell")
        
        
        pesananTableView.delegate = self
        pesananTableView.dataSource = self
        
        var data = readDataFromCSV(fileName: "MenuFix", fileType: "csv")
        data = cleanRows(file: data!)
        let csvRows = csv(data: data!)
        print(csvRows[1][0]) //UXM n. 166/167.
      //let i : Int=1
      var alamat: String = "default"
      var i = 1
      for row in csvRows{
        if i<548{
          print(row[0])

          switch row[0]{
          case "1":
            alamat = "Green Eatery GOP9 BSD City Sampora, Kec. Cisauk, Tangerang, Banten 15345"
          case "2":
            alamat = " Food Court The Breeze BSD City Sampora, Kec. Cisauk, Tangerang, Banten 15345"
          case "3":
            alamat = "The Breeze BSD City Sampora, Kec. Cisauk, Tangerang, Banten 15345"
          default:
            break
          }
          print(alamat)
          //print(row[1])


          addDocument(alamat: alamat, menuID: row[3], merchantID: row[1], merchantName: row[3], menuName: row[4], price: Int(row[5])!, category: row[6], description: row[7], latitude: (row[8] as NSString).doubleValue, longitude: (row[9] as NSString).doubleValue)
          i += 1
        }
      }
        print("Doneee")
      
    }
  
  func readDataFromCSV(fileName:String, fileType: String)-> String!{
          guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
              else {
                print("a")
                  return nil

          }
          do {
              var contents = try String(contentsOfFile: filepath, encoding: .utf8)
              contents = cleanRows(file: contents)
              return contents
          } catch {
              print("File Read Error for file \(filepath)")
              return nil
          }
      }


  func cleanRows(file:String)->String{
      var cleanFile = file
      cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
      cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
      //        cleanFile = cleanFile.replacingOccurrences(of: ";;", with: "")
      //        cleanFile = cleanFile.replacingOccurrences(of: ";\n", with: "")
      return cleanFile
  }

  func csv(data: String) -> [[String]] {
      var result: [[String]] = []
      let rows = data.components(separatedBy: "\n")
      for row in rows {
          //print(row)
          let columns = row.components(separatedBy: ",")
          result.append(columns)

      }
      return result
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "tesSegue"{
      if let nextVC = segue.destination as? MakananViewController{
        if seqmen.selectedSegmentIndex == 0{
          nextVC.indikator = 1
          nextVC.pesmod = self.cekPesanan[selectedIndex!]
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
        let todo = cekPesanan[indexPath.row]
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
        
      moveToDone = cekPesanan[indexPath.row]
      moveToDoneSegmen(moveToDone: moveToDone)
        let complete = completeAction(at: indexPath)
        
        return UISwipeActionsConfiguration(actions: [complete])
    }
    
    func completeAction(at indexPath:IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Complete") { (action, view, completion) in
            self.cekPesanan.remove(at: indexPath.row)
            self.pesananTableView.deleteRows(at: [indexPath], with: .automatic)
        }
        action.image = #imageLiteral(resourceName: "Check")
        action.backgroundColor = .green
        
        return action
    }
  
  func moveToDoneSegmen(moveToDone: PesananModel){
    let newSelesai = SelesaiModel(name: moveToDone.name, estimation: moveToDone.estimation, items: moveToDone.items, status: "Pesanan Selesai", time: moveToDone.time, logo: moveToDone.logo)
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
            returnValue = cekPesanan.count
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
       
            let ngetes = cekPesanan[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "pesananCell", for: indexPath) as! PesananTableViewCell
            
            cell.lblName.text = ngetes.name
            cell.lblPickupTime.text = ngetes.estimation
            cell.lblItems.text = ngetes.items
            cell.lblTime.text = ngetes.time
            cell.imgLogo.image = UIImage(named: ngetes.logo)
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

extension PesananViewController: doneServe{
  func delFromRow() {
    moveToDoneSegmen(moveToDone: cekPesanan[self.selectedIndex!])
    cekPesanan.remove(at: selectedIndex!)
    self.pesananTableView.reloadData()
    print("deleted!")
  }
  
}

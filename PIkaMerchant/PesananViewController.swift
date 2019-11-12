//
//  PesananViewController.swift
//  PIkaMerchant
//
//  Created by Rezli Arian Perdana on 11/11/19.
//  Copyright © 2019 Apple Developer Academy. All rights reserved.
//

import UIKit

class PesananViewController: UIViewController {
    
    var cekPesanan:[PesananModel]=[]
    var cekSelesai:[SelesaiModel]=[]
    
    @IBOutlet weak var pesananTableView: UITableView!
    @IBOutlet weak var seqmen: UISegmentedControl!
    
    var proses: UITableViewCell!
    var selesai: UITableViewCell!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let pesan = PesananModel(name: "Randy Cagur", estimation: "16:20", items: "3 items", time: "08.20", logo: "Go Pay")
        
        let pesan1 = PesananModel(name: "Randy cingur", estimation: "10:20", items: "10 items", time: "10.20", logo: "Ovo")
        
        let done = SelesaiModel(name: "Randy Noel", items: "3 items", status: "Sudah diambil", time: "09.11", logo: "Go Pay")
        
        cekPesanan.append(pesan)
        cekPesanan.append(pesan1)
        
        cekSelesai.append(done)
        
        let nib2 = UINib(nibName: "PesananTableViewCell", bundle: nil)
        self.pesananTableView.register(nib2, forCellReuseIdentifier: "pesananCell")
        
        pesananTableView.delegate = self
        pesananTableView.dataSource = self
        
        
        var proses = PesananTableViewCell()
        var selesai = SelesaiTableViewCell()
        
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
    
    @IBAction func UISegmentedControl(_ sender: UISegmentedControl) {

    }
    
    
}

extension PesananViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(cekPesanan.count)
        return cekPesanan.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        tableView.rowHeight = 100
        
        if seqmen.selectedSegmentIndex == 0{
            let ngetes = cekPesanan[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "pesananCell", for: indexPath) as! PesananTableViewCell
            
            cell.lblName.text = ngetes.name
            cell.lblPickupTime.text = ngetes.estimation
            cell.lblItems.text = ngetes.items
            cell.lblTime.text = ngetes.time
            cell.imgLogo.image = UIImage(named: ngetes.logo)
            return cell
            
        }else{
            let ngetes1 = cekSelesai[indexPath.row]
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "pesananCell", for: indexPath) as! SelesaiTableViewCell
            
            cell1.lblName.text = ngetes1.name
            cell1.lblItems.text = ngetes1.items
            cell1.lblStatus.text = ngetes1.status
            cell1.lblTime.text = ngetes1.time
            cell1.imgLogo.image = UIImage(named: ngetes1.logo)
            
            return cell1
        }
            
       
        
        
        
       
        
        
        
        
    }
}

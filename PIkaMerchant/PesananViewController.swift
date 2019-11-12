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
    
    @IBOutlet weak var pesananTableView: UITableView!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        cekPesanan = [PesananModel(name: "Randy Cagur", estimation: "16:20", items: "3 items", time: "08.20", logo: "Go Pay")]
        
        let pesan = PesananModel(name: "Randy Cagur", estimation: "16:20", items: "3 items", time: "08.20", logo: "Go Pay")
        
        let pesan1 = PesananModel(name: "Randy cingur", estimation: "10:20", items: "10 items", time: "10.20", logo: "Ovo")
        
        cekPesanan.append(pesan)
        cekPesanan.append(pesan1)
        
        let nib2 = UINib(nibName: "PesananTableViewCell", bundle: nil)
        self.pesananTableView.register(nib2, forCellReuseIdentifier: "pesananCell")
        
        pesananTableView.delegate = self
        pesananTableView.dataSource = self
        

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
    
}

extension PesananViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(cekPesanan.count)
        return cekPesanan.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pesananCell", for: indexPath) as! PesananTableViewCell
        
        let ngetes = cekPesanan[indexPath.row]
        
        cell.lblName.text = ngetes.name
        cell.lblPickupTime.text = ngetes.estimation
        cell.lblItems.text = ngetes.items
        cell.lblTime.text = ngetes.time
        cell.imgLogo.image = UIImage(named: ngetes.logo)
        
        tableView.rowHeight = 100
        return cell
    }
}

//
//  PesananViewController.swift
//  PIkaMerchant
//
//  Created by Rezli Arian Perdana on 11/11/19.
//  Copyright © 2019 Apple Developer Academy. All rights reserved.
//

import UIKit

class PesananViewController: UIViewController {
    
    @IBOutlet weak var pesananTableView: UITableView!
    
    override func viewDidLoad() {
        <#code#>
    }
    
}

extension PesananTableViewCell: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! PesananTableViewCell
        
        
        return cell
    }
}

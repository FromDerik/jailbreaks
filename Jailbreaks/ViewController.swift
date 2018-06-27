//
//  ViewController.swift
//  Jailbreaks
//
//  Created by Derik Malcolm on 6/25/18.
//  Copyright © 2018 Derik Malcolm. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var jailbreakData: JailbreakData?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataManager.loadData(url: "https://raw.githubusercontent.com/ca13ra1/jailbreaks/gh-pages/jailbreak.json") { (data) in
            self.jailbreakData = data
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

}

extension ViewController {
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let data = jailbreakData else { return nil }
        
        return data.jailbreaks[section].name
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let data = jailbreakData else { return 0 }
        
        return data.jailbreaks.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = jailbreakData else { return 0}
        
        return data.jailbreaks[section].versions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        guard let data = jailbreakData else { return cell }
        
        cell.textLabel?.text = data.jailbreaks[indexPath.section].versions[indexPath.row]
        cell.detailTextLabel?.text = data.jailbreaks[indexPath.section].url
        
        return cell
    }
}






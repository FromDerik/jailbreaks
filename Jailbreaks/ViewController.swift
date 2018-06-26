//
//  ViewController.swift
//  Jailbreaks
//
//  Created by Derik Malcolm on 6/25/18.
//  Copyright © 2018 Derik Malcolm. All rights reserved.
//

import UIKit

struct DataManager {
    
    static func loadData(url: String, completionHandler: @escaping ([Version]) -> Void) {
        guard let url = URL(string: url) else { return }
        
        var allVersions: [Version] = []
        
        let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to fetch Jailbreaks: ", error)
                return
            }
            
            guard let data = data else { return }
            
            guard let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return }
            
            guard let v = json["versions"] as? [[String: Any]] else { return }
            
            guard let versions = v.first else { return }
            
            print(versions, "\n")
            
            versions.forEach({ (key, value) in
                guard let value = value as? [String: Any] else { return }
                print(value, "\n")
                
                var version = Version(version: key, jailbreaks: [])
                
                guard let jailbreaks = value["jailbreaks"] as? [[String: Any]] else { return }
                jailbreaks.forEach({ (jb) in
                    guard let name = jb["name"] as? String else { return }
                    guard let url = jb["url"] as? String else { return }
                    guard let developer = jb["developer"] else { return }
                    guard let twitter = jb["twitter"] else { return }
                    
                    let jailbreak = Jailbreak(name: name, developer: developer, twitter: twitter, url: url)
                    
                    version.jailbreaks.append(jailbreak)
                })
                
                allVersions.append(version)
            })
            
            completionHandler(allVersions)
        }
        
        session.resume()
    }
    
}

class ViewController: UITableViewController {
    
    var versions: [Version] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataManager.loadData(url: "https://raw.githubusercontent.com/ca13ra1/jailbreaks/gh-pages/jailbreak.json") { (versions) in
            self.versions = versions
            
            self.tableView.reloadData()
        }
    }

}

extension ViewController {
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return versions[section].version
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return versions.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return versions[section].jailbreaks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        
        cell.textLabel?.text = versions[indexPath.section].jailbreaks[indexPath.row].name
        cell.detailTextLabel?.text = versions[indexPath.section].jailbreaks[indexPath.row].url
        
        return cell
    }
}

struct Version {
    let version: String
    var jailbreaks: [Jailbreak]
}

struct Jailbreak {
    let name: String
    let developer: Any
    let twitter: Any
    let url: String
}


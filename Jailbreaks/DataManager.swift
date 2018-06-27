//
//  DataManager.swift
//  Jailbreaks
//
//  Created by Derik Malcolm on 6/26/18.
//  Copyright © 2018 Derik Malcolm. All rights reserved.
//

import Foundation

struct DataManager {
    
    static func loadData(url: String, completionHandler: @escaping (JailbreakData) -> Void) {
        guard let url = URL(string: url) else { return }
        
        let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to fetch Jailbreaks: ", error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let jailbreakData = try JSONDecoder().decode(JailbreakData.self, from: data)
                
                completionHandler(jailbreakData)
            } catch let error {
                print("Failed to decode data: ", error)
            }
        }
        
        session.resume()
    }
    
}

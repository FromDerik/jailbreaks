//
//  Jailbreak.swift
//  Jailbreaks
//
//  Created by Derik Malcolm on 6/26/18.
//  Copyright © 2018 Derik Malcolm. All rights reserved.
//

import Foundation

struct Jailbreak: Codable {
    let name: String
    let url: String
    let developer: [String]
    let twitter: [String]
    let versions: [String]
}

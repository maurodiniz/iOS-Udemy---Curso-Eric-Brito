//
//  Car.swift
//  Carangas
//
//  Created by Mauro Augusto Diniz on 20/05/19.
//  Copyright © 2019 Eric Brito. All rights reserved.
//

import Foundation

// como essa classe será criada a partir de um json, devemos dizer que ela é Codable
class Car: Codable {
    
    var brand: String = ""
    var name: String = ""
    var price: Double = 0.0
    var gasType: Int = 0
    var _id: String?
    
    var gas: String {
        switch gasType {
        case 0:
            return "Flex"
        case 1:
            return "Álcool"
        default:
            return "Gasolina"
        }
    }
}

struct Brand: Codable {
    let fipe_name: String
}

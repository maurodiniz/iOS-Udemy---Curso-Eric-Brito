//
//  Quote.swift
//  Pensamentos
//
//  Created by Mauro Augusto Diniz on 16/04/19.
//  Copyright © 2019 Mauro Augusto Diniz. All rights reserved.
//

import Foundation

// Protocolo Codable permite 'encodar' nossa classe num arquivo do formato json, e 'decodar' as informações posteriormente
struct Quote: Codable {
    
    let quote: String
    let author: String
    let image: String
    var quoteFormatted: String{
        return "❝"+quote+"❞"
    }
    var authorFormatted: String{
        return "- " + author + " -"
    }
    
}

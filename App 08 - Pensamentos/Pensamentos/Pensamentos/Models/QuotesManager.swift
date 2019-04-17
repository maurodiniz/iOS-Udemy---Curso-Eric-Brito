//
//  QuotesManager.swift
//  Pensamentos
//
//  Created by Mauro Augusto Diniz on 16/04/19.
//  Copyright © 2019 Mauro Augusto Diniz. All rights reserved.
//

import Foundation

class QuotesManager{
    let quotes: [Quote]
    
    init() {
        let fileURL = Bundle.main.url(forResource: "quotes", withExtension: "json")!
        // criando uma classe do tipo Data que contem todo o conteudo do arquivo quotes.json conigurado acima
        let jsonData = try! Data(contentsOf: fileURL)
        let jsonDecoder = JSONDecoder()
        quotes = try! jsonDecoder.decode([Quote].self, from: jsonData)
        
    }
}

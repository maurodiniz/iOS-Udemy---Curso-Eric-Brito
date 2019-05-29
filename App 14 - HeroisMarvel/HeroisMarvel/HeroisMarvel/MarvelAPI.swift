//
//  MarvelAPI.swift
//  HeroisMarvel
//
//  Created by Mauro Augusto Diniz on 27/05/19.
//  Copyright © 2019 Eric Brito. All rights reserved.
//

import Foundation
import SwiftHash
import Alamofire

class MarvelAPI {
    
    static private let basePath = "https://gateway.marvel.com/v1/public/characters?"
    static private let privateKey = "1ae0590af5c9da291ff2156145ac06f2f6eab621"
    static private let publicKey = "0397a162c288e44566e53703f610b14b"
    static private let limit = 50

    // criando o timeStamp e o Hash e concatenando o resultado
    private class func getCredentials() -> String {
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(ts+privateKey+publicKey).lowercased()
        
        return "ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
    }
    
    // criando a url que será mandada para a api da marvel
    class func loadHeroes(name: String?, page: Int = 0, onComplete: @escaping (MarvelInfo?) -> Void){
        let offset = page * limit
        let startsWith: String
        
        if let name = name, !name.isEmpty {
            startsWith = "nameStartsWith=\(name.replacingOccurrences(of: " ", with: ""))&"
        }else {
            startsWith = ""
        }
        
        let url = basePath+"offset=\(offset)&limit=\(limit)&"+startsWith+getCredentials()
        print(url)
        
        Alamofire.request(url).responseJSON { (response) in
            guard let data = response.data else {
                onComplete(nil)
                return}
            do{
                let marvelInfo = try JSONDecoder().decode(MarvelInfo.self, from: data)
                onComplete(marvelInfo)
            } catch {
                print(error.localizedDescription)
                onComplete(nil)
            }
        }
        
    }
    
    
}

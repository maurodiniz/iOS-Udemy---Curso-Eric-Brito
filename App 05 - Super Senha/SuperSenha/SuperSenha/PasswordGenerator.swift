//
//  PasswordGenerator.swift
//  SuperSenha
//
//  Created by Mauro Augusto Diniz on 03/04/19.
//  Copyright © 2019 Mauro Augusto Diniz. All rights reserved.
//

import Foundation

class PasswordGenerator {
    var numberOfCharacters: Int
    var useLetters: Bool
    var useNumbers: Bool
    var useCapitalLetters: Bool
    var useSpecialCharacters: Bool
    
    var passwords: [String] = []
    
    private let letters = "abcdefghijklmnopqrstuvwxyz"
    private let specialCharacters = "!@#$%ˆ&*()_-+=~ |][}{':;?/<>.,"
    private let numbers = "0123456789"
    
    init(numberOfCharacters: Int, useLetters: Bool, useNumbers: Bool, useCapitalLetters: Bool, useSpecialCharacters: Bool) {
        
        var numchars = min(numberOfCharacters, 16)
        numchars = max(numchars, 1)
        
        self.numberOfCharacters = numchars
        self.useLetters = useLetters
        self.useNumbers = useNumbers
        self.useCapitalLetters = useCapitalLetters
        self.useSpecialCharacters = useSpecialCharacters
    }
    
    
    // Função responsável por gerar as senhas aleatoriamente atendendo os requisitos do usuario enviados por parametro
    func generate(total: Int) -> [String]{
        // Limpando o array de senhas a cada nova iteração
        passwords.removeAll()
        
        // Definindo um universo onde verifico quais condições foram requisitadas pelo usuario
        var universe: String = ""
        if useLetters{
            universe += letters
        }
        if useNumbers{
            universe += numbers
        }
        if useSpecialCharacters{
            universe += specialCharacters
        }
        if useCapitalLetters{
            universe += letters.uppercased()
        }
        let universeArray = Array(universe)
        
        // enquanto o numero de senhas geradas for menor que o total pedido, continuar o laço
        while passwords.count < total {
            
            var password = ""
            
            // gerando uma senha de acordo com o tamanho maximo de caracteres
            for _ in 1...numberOfCharacters{
                let index = Int(arc4random_uniform(UInt32(universeArray.count)))
                password += String(universeArray[index])
            }
            passwords.append(password)
        }
        
        return passwords
    }
}

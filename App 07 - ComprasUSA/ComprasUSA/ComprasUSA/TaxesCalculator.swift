//
//  TaxesCalculator.swift
//  ComprasUSA
//
//  Created by Mauro Augusto Diniz on 11/04/19.
//  Copyright © 2019 Mauro Augusto Diniz. All rights reserved.
//

import Foundation

class TaxesCalculator {
    
    // usando static let para que a mesma variavel instancie sempre a mesma referencia ao objeto TaxesCalculator e definindo o contrutor como private para que nenhuma outra classe consiga instanciar um novo objeto do tipo TaxesCalculator.
    static let shared = TaxesCalculator()
    private init(){
        // fazendo o formatter usar separadores padrão para virgula e casas decimais
        formatter.usesGroupingSeparator = true
    }
    
    // variaveis e variaveis computadas
    var dolar: Double = 4.0
    var iof: Double = 6.38
    var stateTax: Double = 7.0
    var shoppingValue: Double = 0
    var shoppingValueInReal: Double {
        return shoppingValue * dolar
    }
    var stateTaxValue: Double {
        return shoppingValue * stateTax/100
    }
    var iofValue: Double {
        return (shoppingValue + stateTaxValue) * iof/100
    }
    var formatter = NumberFormatter()
    
    // funções
    
    // calculando o valor total, em dolar (valor da compra + imposto + iof)
    func calculate(usingCreditCard: Bool) -> Double {
        var finalValue = (shoppingValue + stateTaxValue)
        
        if usingCreditCard {
            finalValue += iofValue
        }
        
        return finalValue * dolar
    }
    
    func getFormattedValue(of value: Double, withCurrency currency: String) -> String {
        formatter.numberStyle = .currency
        formatter.currencySymbol = currency
        formatter.alwaysShowsDecimalSeparator = true
        
        return formatter.string(for: value)!
    }
    
    func convertToDouble(_ str: String) -> Double {
        // usando o formatter para extrair o valor de uma String
        formatter.numberStyle = .none
        let result = formatter.number(from: str)!.doubleValue
        return result
    }
}

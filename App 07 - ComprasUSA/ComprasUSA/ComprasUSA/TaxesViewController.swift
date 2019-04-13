//
//  TaxesViewController.swift
//  ComprasUSA
//
//  Created by Mauro Augusto Diniz on 10/04/19.
//  Copyright © 2019 Mauro Augusto Diniz. All rights reserved.
//

import UIKit

class TaxesViewController: UIViewController {

    @IBOutlet weak var lbDolar: UILabel!
    @IBOutlet weak var lbStateTaxes: UILabel!
    @IBOutlet weak var lbIOFDesciption: UILabel!
    @IBOutlet weak var lbIOF: UILabel!
    @IBOutlet weak var swCreditCard: UISwitch!
    @IBOutlet weak var lbReal: UILabel!
    @IBOutlet weak var lbStateTaxDesciption: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        calculateTaxes()
    }
    
    // MARK: - Funções
    func calculateTaxes() {
        lbStateTaxDesciption.text = "Imposto Estadual (\(tc.getFormattedValue(of: tc.stateTax, withCurrency: ""))%)"
        lbIOFDesciption.text = "I.O.F (\(tc.getFormattedValue(of: tc.iof, withCurrency: ""))%)"
        
        lbDolar.text = tc.getFormattedValue(of: tc.shoppingValue, withCurrency: "US$ ")
        lbStateTaxes.text = tc.getFormattedValue(of: tc.stateTaxValue, withCurrency: "US$ ")
        lbIOF.text = tc.getFormattedValue(of: tc.iofValue, withCurrency: "US$")
        
        let real = tc.calculate(usingCreditCard: swCreditCard.isOn)
        lbReal.text = tc.getFormattedValue(of: real, withCurrency: "R$ ")
    }

    // Toda vex que o usuario alterar o switch referente a compra com cartão, recalcular o valor total
    @IBAction func changeIOF(_ sender: UISwitch) {
        calculateTaxes()
    }
    

}

//
//  ViewController.swift
//  Conversores
//
//  Created by Mauro Augusto Diniz on 16/03/19.
//  Copyright © 2019 Mauro Augusto Diniz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK - Outlets e Variáveis
    @IBOutlet weak var tfValue: UITextField!
    @IBOutlet weak var btUnity1: UIButton!
    @IBOutlet weak var btUnity2: UIButton!
    @IBOutlet weak var lbResult: UILabel!
    @IBOutlet weak var lbResultUnit: UILabel!
    @IBOutlet weak var lbUnit: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK: - FUNÇÕES E ACTIONS
    @IBAction func showNext(_ sender: UIButton) {
        switch lbUnit.text! {
        case "Temperatura":
            lbUnit.text = "Peso"
            btUnity1.setTitle("Kilograma", for: .normal)
            btUnity2.setTitle("Libra", for: .normal)
        case "Peso":
            lbUnit.text = "Moeda"
            btUnity1.setTitle("Real", for: .normal)
            btUnity2.setTitle("Dolar", for: .normal)
        case "Moeda":
            lbUnit.text = "Distancia"
            btUnity1.setTitle("Metro", for: .normal)
            btUnity2.setTitle("Kilometro", for: .normal)
        default:
            lbUnit.text = "Temperatura"
            btUnity1.setTitle("Celsius", for: .normal)
            btUnity2.setTitle("Fahrenheit", for: .normal)
        }
        convert(nil)
    }
    
    @IBAction func convert(_ sender: UIButton?) {
        if let sender = sender {
            if sender == btUnity1{
                btUnity2.alpha = 0.5
            }else {
                btUnity1.alpha = 0.5
            }
            sender.alpha = 1
        }
        
        switch lbUnit.text!{
            case "Temperatura":
                calcTemperature()
            case "Peso":
                calcWeight()
            case "Moeda":
                calcCurrency()
            default:
                calcDistance()
        }
        view.endEditing(true)
        
        // Formatando o resultado para ficar limitado a 2 casas decimais
        let result = Double(lbResult.text!)!
        lbResult.text = String(format: "%.2f", result)
    }
    
    func calcTemperature(){
        guard let temperature = Double(tfValue.text!) else {return}
        
        if btUnity1.alpha == 1{
            lbResultUnit.text = "Fahrenheit"
            lbResult.text = String(temperature * 1.8 + 32.0)
        }else{
            lbResultUnit.text = "Celsius"
            lbResult.text = String((temperature - 32.0) / 1.8)
        }
    }
    
    func calcWeight(){
        guard let weight = Double(tfValue.text!) else {return}
        
        if btUnity1.alpha == 1{
            lbResultUnit.text = "Libra"
            lbResult.text = String(weight / 2.2046)
        }else{
            lbResultUnit.text = "Kilograma"
            lbResult.text = String(weight * 2.2046)
        }
    }
    
    func calcCurrency(){
        guard let currency = Double(tfValue.text!) else {return}
        
        if btUnity1.alpha == 1{
            lbResultUnit.text = "Dolar"
            lbResult.text = String(currency / 3.90)
        }else{
            lbResultUnit.text = "Real"
            lbResult.text = String(currency * 3.90)
        }
    }
    
    func calcDistance(){
        guard let distance = Double(tfValue.text!) else {return}
        
        if btUnity1.alpha == 1{
            lbResultUnit.text = "Kilômetro"
            lbResult.text = String(distance / 1000.0)
        }else{
            lbResultUnit.text = "Metros"
            lbResult.text = String(distance * 1000.0)
        }
    }
    
}


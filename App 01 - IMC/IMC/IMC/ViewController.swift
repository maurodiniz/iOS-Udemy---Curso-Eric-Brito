//
//  ViewController.swift
//  IMC
//
//  Created by Mauro Augusto Diniz on 13/03/19.
//  Copyright © 2019 Mauro Augusto Diniz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Mark - Outlets e variaveis
    @IBOutlet weak var tfWeight: UITextField!
    @IBOutlet weak var tfHeight: UITextField!
    @IBOutlet weak var lbResult: UILabel!
    @IBOutlet weak var ivResult: UIImageView!
    @IBOutlet weak var viResult: UIView!
    
    var imc: Double = 0
    
    // MARK - View Lifecicle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    // MARK - Actions e funções
    @IBAction func calculate(_ sender: Any) {
        if let peso = Double(tfWeight.text!), let altura = Double(tfHeight.text!){
            imc = peso / (altura * altura)
            showResults()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func showResults() {
        var result: String = ""
        var image: String = ""
        
        switch imc {
            case 0..<16:
                result = "Magreza"
                image = "magreza"
            case 16..<18.5:
                result = "Abaixo do Peso"
                image = "abaixo"
            case 18.5..<25:
                result = "Peso Ideal"
                image = "ideal"
            case 25..<30:
                result = "Sobrepeso"
                image = "sobre"
            default:
                result = "Obesidade"
                image = "obesidade"
        }
        
        lbResult.text = "\(Int(imc)): \(result)"
        ivResult.image = UIImage(named: image)
        viResult.isHidden = false
        
        view.endEditing(true)
    }
    
}


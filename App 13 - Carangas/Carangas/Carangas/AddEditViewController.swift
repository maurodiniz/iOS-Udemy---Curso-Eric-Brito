//
//  AddEditViewController.swift
//  Carangas
//
//  Created by Eric Brito.
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tfBrand: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var scGasType: UISegmentedControl!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    // MARK: - Properties
    var car: Car!

    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // se car for diferente de nulo quer dizer que o usuario clicou em um item da lista e veio para essa tela trazendo as informações do carro
        if car != nil {
            tfBrand.text = car.brand
            tfName.text = car.name
            tfPrice.text = "\(car.price)"
            scGasType.selectedSegmentIndex = car.gasType
            btAddEdit.setTitle("Alterar carro", for: .normal)
        }
    }
    
    // MARK: - IBActions
    @IBAction func addEdit(_ sender: UIButton) {
        
        if car == nil {
            car = Car()
        }
        
        car.name = tfName.text ?? ""
        car.brand = tfBrand.text ?? ""
        
        if tfPrice.text!.isEmpty {tfPrice.text = "0"}
        car.price = Double(tfPrice.text!) ?? 0
        
        car.gasType = scGasType.selectedSegmentIndex
        
        // se o id do carro for nul quer dizer que ele foi criado no começo dessa função e o usuário está querendo salvar um novo carro, caso contrario ele quer atualizar um carro existente
        if car._id == nil {
            REST.saveCar(car: car) { (success) in
                self.goBack()
            }
        } else {
            REST.update(car: car) { (success) in
                self.goBack()
            }
        }
        
        
        
    }
    
    // MARK: - Methods
    func goBack() {
        // como esse metodo sera chamado dentro de uma closure, no retorno do metodo saveCar(), devo executar ele na main thread para evitar problemas.
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
        
    }

}

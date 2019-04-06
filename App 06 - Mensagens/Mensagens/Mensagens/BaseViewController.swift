//
//  BaseViewController.swift
//  Mensagens
//
//  Created by Mauro Augusto Diniz on 06/04/19.
//  Copyright © 2019 Eric Brito. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    @IBOutlet weak var lbMessage: UILabel!
    
    var message: Message!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func changeColor(_ sender: UIButton){
        
    }

}

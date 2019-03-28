//
//  ResultViewController.swift
//  SwiftQuiz
//
//  Created by Mauro Augusto Diniz on 28/03/19.
//  Copyright © 2019 Mauro Augusto Diniz. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    // MARK - Outlets e Variaveis
    @IBOutlet weak var lbAnswered: UILabel!
    @IBOutlet weak var lbCorrect: UILabel!
    @IBOutlet weak var lbWrong: UILabel!
    @IBOutlet weak var lbScore: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func Close(_ sender: UIButton) {
    }
    

}

//
//  QuizViewController.swift
//  SwiftQuiz
//
//  Created by Mauro Augusto Diniz on 28/03/19.
//  Copyright © 2019 Mauro Augusto Diniz. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {

    // MARK - Outlets e Variaveis
    @IBOutlet weak var viTimer: UIView!
    @IBOutlet weak var lbQuestion: UILabel!
    @IBOutlet var btAnswers: [UIButton]!
    
    // MARK - View Lifecicle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK - Actions e Funções
    @IBAction func selectAnswer(_ sender: UIButton) {
    }
    

}

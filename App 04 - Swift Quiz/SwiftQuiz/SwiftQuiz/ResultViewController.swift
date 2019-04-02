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
    
    var totalCorrectAnswers: Int = 0
    var totalAnswers: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        lbAnswered.text = "Perguntas respondidas: \(totalAnswers)"
        lbCorrect.text = "Perguntas corretas: \(totalCorrectAnswers)"
        lbWrong.text = "Perguntas erradas: \(totalAnswers - totalCorrectAnswers)"
        
        let score = (totalCorrectAnswers * 100) / totalAnswers
        lbScore.text = "\(score)%"
    }
    

    @IBAction func Close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

}

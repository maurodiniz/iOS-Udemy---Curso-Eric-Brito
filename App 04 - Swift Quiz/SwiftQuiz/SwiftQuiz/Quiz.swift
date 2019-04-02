//
//  Quiz.swift
//  SwiftQuiz
//
//  Created by Mauro Augusto Diniz on 28/03/19.
//  Copyright © 2019 Mauro Augusto Diniz. All rights reserved.
//

import Foundation

class Quiz{
    let question: String
    let options: [String]
    private let correctAnswer: String
    
    init(question: String, options: [String], correctAnswer: String) {
        self.question = question
        self.options = options
        self.correctAnswer = correctAnswer
    }
    
    func validateOption(_ index:Int) -> Bool{
        let answer = options[index]
        
        return answer == correctAnswer
    }
    
    deinit {
        print("Liberou quiz da memória")
    }
}

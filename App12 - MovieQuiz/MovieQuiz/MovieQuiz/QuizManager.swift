//
//  QuizManager.swift
//  MovieQuiz
//
//  Created by Mauro Augusto Diniz on 14/05/19.
//  Copyright © 2019 Mauro Augusto Diniz. All rights reserved.
//

import Foundation

class QuizManager {
    
    let quizes: [Quiz]
    let quizOptions: [QuizOption]
    var score: Int
    var round: Round?
    
    typealias Round = (quiz: Quiz, options: [QuizOption])
    
    init() {
        score = 0
        
        // recuperando os quizes e quizes options dos arquivos json
        let quizesURL = Bundle.main.url(forResource: "quizes", withExtension: "json")!
        do {
            let quizesData = try Data(contentsOf: quizesURL)
            quizes = try JSONDecoder().decode([Quiz].self, from: quizesData)
            let quizOptionsURL = Bundle.main.url(forResource: "options", withExtension: "json")!
            let quizOptionsData = try! Data(contentsOf: quizOptionsURL)
            quizOptions = try! JSONDecoder().decode([QuizOption].self, from: quizOptionsData)
        } catch {
            print(error.localizedDescription)
            quizes = []
            quizOptions = []
        }
    }
    
    // Gerar um quiz e devolver 2 resultados: o quiz, as opções
    func generateRandomQuiz() -> Round {
        //recuperando o indice de um quiz no array de quizes
        let quizIndex = Int(arc4random_uniform(UInt32(quizes.count)))
        
        // recuperando o quiz propriamente dito
        let quiz = quizes[quizIndex]
        
        // indice do quiz correto
        var indexes: Set<Int> = [quizIndex]
        
    // enquanto não tiver 4 indeces, gerar mais um indice para ser adicionado como opção de resposta
        while indexes.count < 4 {
            let index = Int(arc4random_uniform(UInt32(quizes.count)))
            indexes.insert(index)
        }
        
        // gerando array de opções
        let options = indexes.map({quizOptions[$0]})
        
        round = (quiz, options)
        
        return round!
        
    }
    
    // validando a resposta
    func checkAnswer(_ answer: String) {
        guard let round = round else {
            return
        }
        
        if answer == round.quiz.name {
            score += 1
        }
    }
}

struct Quiz: Codable {
    let name: String
    let number: Int
}

// representa as opções que aparecerão nos botoes
struct QuizOption: Codable {
    let name: String
}

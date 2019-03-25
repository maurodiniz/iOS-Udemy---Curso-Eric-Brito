//
//  ViewController.swift
//  Loteria
//
//  Created by Mauro Augusto Diniz on 25/03/19.
//  Copyright © 2019 Mauro Augusto Diniz. All rights reserved.
//

import UIKit

enum GameType: String {
    case megasena = "Mega-Sena"
    case quina = "Quina"
}

class ViewController: UIViewController {

    // MARK - Outlets e Variaveis
    @IBOutlet var lbGameType: UILabel!
    @IBOutlet var scGameType: UISegmentedControl!
    @IBOutlet var balls: [UIButton]!
    
    
    // MARK - View Life-cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showNumbers(for: .megasena)
    }
    
    //Função responsável por gerar um array com numeros aleatórios dentro de um universo passado por parametro. Esse array será usado para preencher as bolas com os numeros
    func GameGenerate(total: Int, universe: Int) -> [Int]{
        var result: [Int] = []
        
        while result.count < total {
            let randomNumber = Int(arc4random_uniform(UInt32(universe))+1)
            if !result.contains(randomNumber){
                result.append(randomNumber)
            }
        }
        
        return result.sorted()
    }
    
    // método que pega o tipo de jogo selecionado no segmented control e chama a função GameGenerate passando os parametros especificos, pois cada tipo de jogo tem um total de numeros e um universo diferente.
    func showNumbers(for type: GameType) {
        lbGameType.text = type.rawValue
        var game: [Int] = []
        
        switch type {
        case .megasena:
            game = GameGenerate(total: 6, universe: 60)
            balls.last!.isHidden = false
        case .quina:
            game = GameGenerate(total: 5, universe: 80)
            balls.last!.isHidden = true
        }
        
        for (index, game) in game.enumerated(){
            balls[index].setTitle("\(game)", for: .normal)
        }
    }

    // Action disparada ao clicar no botão de Gerar jogo ou ao clicar num dos itens do segmented control
    @IBAction func generateGame() {
        switch scGameType.selectedSegmentIndex {
        case 0:
            showNumbers(for: .megasena)
        default:
            showNumbers(for: .quina)
        }
    }
    
}


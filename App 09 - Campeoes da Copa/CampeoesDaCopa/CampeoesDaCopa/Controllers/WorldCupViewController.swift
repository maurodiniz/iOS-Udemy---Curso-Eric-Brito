//
//  WorldCupViewController.swift
//  CampeoesDaCopa
//
//  Created by Mauro Augusto Diniz on 21/04/19.
//  Copyright © 2019 Mauro Augusto Diniz. All rights reserved.
//

import UIKit

class WorldCupViewController: UIViewController {
    
    var worldCup: WorldCup!
    @IBOutlet weak var ivWinner: UIImageView!
    @IBOutlet weak var ivVice: UIImageView!
    @IBOutlet weak var lbScore: UILabel!
    @IBOutlet weak var lbWinner: UILabel!
    @IBOutlet weak var lbVice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setando informações na tela conforme a Copa selecionada na tela anterior
        carregaTela()
        
    }
    
    // MARK: - Navigation
    func carregaTela() {
        ivWinner.image = UIImage(named: "\(worldCup.winner).png")
        ivVice.image = UIImage(named: "\(worldCup.vice).png")
        lbWinner.text = worldCup.winner
        lbVice.text = worldCup.vice
        lbScore.text = "\(worldCup.winnerScore) x \(worldCup.viceScore)"
    }
 

}

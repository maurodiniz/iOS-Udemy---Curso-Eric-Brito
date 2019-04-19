//
//  QuotesViewController.swift
//  Pensamentos
//
//  Created by Mauro Augusto Diniz on 16/04/19.
//  Copyright © 2019 Mauro Augusto Diniz. All rights reserved.
//

import UIKit

class QuotesViewController: UIViewController {

    
    @IBOutlet weak var ivPhoto: UIImageView!
    @IBOutlet weak var ivPhotoBg: UIImageView!
    @IBOutlet weak var lbQuote: UILabel!
    @IBOutlet weak var lbAuthor: UILabel!
    @IBOutlet weak var ctQuote: NSLayoutConstraint!
    var timer: Timer?
    
    let quotesManager = QuotesManager()
    let config = Configuration.shared
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        formatView()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // no momento que essa viewController for carregada ela vai começar a monitorar se existe alguma notificação com o nome Refresh, e caso tenha ele vai usar o formatView para recarregar as configurações do app.
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Refresh"), object: nil, queue: nil) { (notification) in
            self.formatView()
        }
    }
    
    func formatView() {
        view.backgroundColor = config.colorScheme == 0 ? .white : UIColor(displayP3Red: 156.0/255.0, green: 68.0/255.0, blue: 15.0/255.0, alpha: 1.0)
        
        lbQuote.textColor = config.colorScheme == 0 ? .black : .white
        lbAuthor.textColor = config.colorScheme == 0 ? UIColor(displayP3Red: 192.0/255.0, green: 96.0/255.0, blue: 49.0/255.0, alpha: 1.0) : .yellow
        
        prepareQuote()
    }
    
    // sempre que o usuario tocar na tela, uma nova quote será carregada
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        prepareQuote()
    }
    
    // invalidando qualquer execução anterior do timer que possa estar em execução, e agendando um novo scheduleTimer
    func prepareQuote() {
        timer?.invalidate()
        if config.autoRefresh{
            timer = Timer.scheduledTimer(withTimeInterval: config.timeInterval, repeats: true, block: { (timer) in
                self.showRandomQuote()
            })
        }
        showRandomQuote()
    }
    
    // responsável por solicitar uma nova quote e alimentar os componentes da tela
    func showRandomQuote() {
        let quote = quotesManager.getRandomQuote()
        
        lbQuote.text = quote.quote
        lbAuthor.text = quote.author
        ivPhoto.image = UIImage(named: quote.image)
        ivPhotoBg.image = ivPhoto.image
        
        lbQuote.alpha = 0.0
        lbAuthor.alpha = 0.0
        ivPhoto.alpha = 0.0
        ivPhotoBg.alpha = 0.0
        ctQuote.constant = 50
        view.layoutIfNeeded()
        
        // Através desse método consigo definir a animação da tela, ou seja, no final de 2.5 segundos os componentes dentro da closure terão as seguintes propriedades
        UIView.animate(withDuration: 2.5) {
            self.lbQuote.alpha = 1.0
            self.lbAuthor.alpha = 1.0
            self.ivPhoto.alpha = 1.0
            self.ivPhotoBg.alpha = 0.25
            self.ctQuote.constant = 10
            self.view.layoutIfNeeded()
        }
    }
}

//
//  ViewController.swift
//  MovieQuiz
//
//  Created by Mauro Augusto Diniz on 14/05/19.
//  Copyright © 2019 Mauro Augusto Diniz. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var viSoundBar: UIView!
    @IBOutlet weak var slMusic: UISlider!
    @IBOutlet var btOptions: [UIButton]!
    @IBOutlet weak var ivQuiz: UIImageView!
    @IBOutlet weak var viTimer: UIView!
    
    var quizManager: QuizManager!
    
    // para conseguir reproduzir audio de uma fonte local, usamos a classe AVAudioPlayer
    var quizPlayer: AVAudioPlayer!
    
    //playerItem representa qualquer objeto (video ou musica) que será tocado pelo AVPlayer
    var playerItem: AVPlayerItem!
    var backgroundMusicPlayer: AVPlayer!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GameOverViewController {
            vc.score = quizManager.score
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // quando a view for aparecer eu instancio um novo quizManager e gero um novo quiz
        quizManager = QuizManager()
        getNewQuiz()
        startTimer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        viSoundBar.isHidden = true
        playBackgroundMusic()
    }
    
    func playBackgroundMusic() {
        if let musicURL = Bundle.main.url(forResource: "MarchaImperial", withExtension: "mp3") {
            playerItem = AVPlayerItem(url: musicURL)
            backgroundMusicPlayer = AVPlayer(playerItem: playerItem)
            backgroundMusicPlayer.volume = 0.1
            backgroundMusicPlayer.play()
            
            // codigo que será executado a cada x segundos
            backgroundMusicPlayer.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: nil) { (time) in
                let percent = time.seconds / self.playerItem.duration.seconds
                self.slMusic.setValue(Float(percent), animated: true)
            }
        }
        
        
        
        
        
    }
    
    // pedindo a classe QuizManager para gerar um quiz aleatório
    func getNewQuiz() {
        let round = quizManager.generateRandomQuiz()
        
        for i in 0..<round.options.count {
            btOptions[i].setTitle(round.options[i].name, for: .normal)
        }
        playQuiz()
    }
    
    // função responsável pela animação do contador
    func startTimer() {
        viTimer.frame = view.frame
        
        UIView.animateKeyframes(withDuration: 60.0, delay: 0.0, options: .calculationModeLinear, animations: {
            self.viTimer.frame.size.width = 0
            self.viTimer.frame.origin.x = self.view.center.x
        }) { (success) in
            self.gameOver()
        }
    }
    
    // chamada ao final da contagem de tempo e retorna a pontuação final do usuario
    func gameOver() {
        performSegue(withIdentifier: "gameOverSegue", sender: nil)
        
        //interrompendo algum som que possa estar sendo executado pelo AVPlayer
        quizPlayer.stop()
    }
    
    // inicia a reprodução dos audios
    @IBAction func playQuiz() {
        guard let round = quizManager.round else {return}
        
        ivQuiz.image = UIImage(named: "movieSound")
        
        //recuperando o som
        if let url = Bundle.main.url(forResource: "quote\(round.quiz.number)", withExtension: "mp3") {
            
            do {
                quizPlayer = try AVAudioPlayer(contentsOf: url)
                quizPlayer.volume = 1
                quizPlayer.play()
                quizPlayer.delegate = self
            } catch {
                
            }
        }
        
    }

    @IBAction func showHideSoundbar(_ sender: Any) {
        viSoundBar.isHidden = !viSoundBar.isHidden
    }
    
    @IBAction func changeMusicStatus(_ sender: Any) {
        if backgroundMusicPlayer.timeControlStatus == .paused {
            backgroundMusicPlayer.play()
            if let button = sender as? UIButton {
                button.setImage(UIImage(named: "pause"), for: .normal)
            }
        } else {
            backgroundMusicPlayer.pause()
            if let button = sender as? UIButton {
                button.setImage(UIImage(named: "play"), for: .normal)
            }
        }
    }
    
    // toda vez que usuario mover a barra do slider a musica deve ir para o ponto correspondente
    @IBAction func changeMusicTime(_ sender: UISlider) {
        backgroundMusicPlayer.seek(to: CMTime(seconds: Double(sender.value) * playerItem.duration.seconds, preferredTimescale: 1))
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        quizManager.checkAnswer(sender.title(for: .normal)!)
        
        getNewQuiz()
    }
    
    
}

extension ViewController: AVAudioPlayerDelegate {
    // quando o som acabar, chamo esse metodo
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        ivQuiz.image = UIImage(named: "movieSoundPause")
    }
}

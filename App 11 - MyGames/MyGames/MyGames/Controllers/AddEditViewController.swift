//
//  AddEditViewController.swift
//  MyGames
//
//  Created by Mauro Augusto Diniz on 08/05/19.
//  Copyright © 2019 Mauro Augusto Diniz. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController {

    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfConsole: UITextField!
    @IBOutlet weak var dpReleaseDate: UIDatePicker!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var btCover: UIButton!
    @IBOutlet weak var ivCover: UIImageView!
    
    var game: Game!
    
    // criando um ConsolesManager.shared para que eu tenha acesso a qtd de plataformas
    var consolesManager = ConsolesManager.shared
    
    // Criando um objeto do tipo PickerView para que quando o usuario clicar no textFiled de plataforma, seja exibido um pickerView com opções pré-definidas ao invés do teclado padrão
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .white
        
        return pickerView
    }()
    
    // carregando a lista de cosoles quando a view for aparecer
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        consolesManager.loadConsoles(with: context)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // se existir um game, significa que é modo de edição
        if game != nil {
            title = "Editar Jogo"
            btAddEdit.setTitle("Alterar", for: .normal)
            
            tfTitle.text = game.title
            
            // recuperando a plataforma e adicionando a constante console, caso consiga ele procura o indice da plataforma no consolesManager para que quando a tela carregar e tiver uma plataforma associada, o pickerview deverá exibir o mesmo indice
            if let console = game.console, let index = consolesManager.consoles.index(of: console) {
                tfConsole.text = console.name
                pickerView.selectRow(index, inComponent: 0, animated: false)
            }
            ivCover.image = game.cover as? UIImage
            
            if let releaseDate = game.releaseDate {
                dpReleaseDate.date = releaseDate
            }
            
            if game.cover != nil {
                btCover.setTitle(nil, for: .normal)
            }
        }
        
        prepareConsoleTextField()

        // Do any additional setup after loading the view.
    }
    
    func prepareConsoleTextField() {
        // toolbar que sera exibida no pickerView
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        toolbar.tintColor = UIColor(named: "main")
        
        // botão de cancelar da toolbar
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        // botão de concluir da toolbar
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        // colocando o botão Done do lado direito da toolbar
        let btFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        // adicionando os botões à toolbar
        toolbar.items = [btCancel, btFlexibleSpace, btDone]
        
        tfConsole.inputView = pickerView
        tfConsole.inputAccessoryView = toolbar
    }
    
    @objc func cancel() {
        tfConsole.resignFirstResponder()
    }
    @objc func done() {
        
        tfConsole.text = consolesManager.consoles[pickerView.selectedRow(inComponent: 0)].name
        
        
        cancel()
    }
    
    @IBAction func addEditCover(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecionar Capa", message: "De onde deseja selecionar a capa?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }
        
        
        let libraryAction = UIAlertAction(title: "Biblioteca de Fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let phtotosAction = UIAlertAction(title: "Álbum de Fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(phtotosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func selectPicture(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.navigationBar.tintColor = UIColor(named: "main")
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func addEditGame(_ sender: UIButton) {
        // se game for nil, quer dizer que o usuario está adicionando um novo jogo
        if game == nil {
            game = Game(context: context)
        }
        
        game.title = tfTitle.text
        game.releaseDate = dpReleaseDate.date
        
        // validando o campo de plataforma para poder salvar
        if !tfConsole.text!.isEmpty {
            let console = consolesManager.consoles[pickerView.selectedRow(inComponent: 0)]
            game.console = console
        }
        
        // salvando a imagem
        game.cover = ivCover.image
        
        // através dos comandos acima, todas as informações sobre o jogo estão apenas no contexto e não foram persistidas ainda. Para persistir usamos o comando .save , e como ele dispara exceção temos que usar o do/catch
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// Implementando dois protocolos ao mesmo tempo.
extension AddEditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // Componentes são as colunas do pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // quantas linhas terei em cada coluna
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return consolesManager.consoles.count
    }
    
    // o texto que irá aparecer em cada linha
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let console = consolesManager.consoles[row]
        
        return console.name
    }
}

extension AddEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        ivCover.image = image
        btCover.setTitle(nil, for: .normal)
        
        dismiss(animated: true, completion: nil)
        
    }
}

//
//  ConsolesTableViewController.swift
//  MyGames
//
//  Created by Mauro Augusto Diniz on 08/05/19.
//  Copyright © 2019 Mauro Augusto Diniz. All rights reserved.
//

import UIKit

class ConsolesTableViewController: UITableViewController {
    
    var consolesManager = ConsolesManager.shared
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadConsoles()
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func loadConsoles() {
        consolesManager.loadConsoles(with: context)
        
        tableView.reloadData()
    }
    
    // criando uma função de showAlert recebendo um Console opcional pois se eu chamar esse metodo com o parametro quer dizer que estou querendo Editar um item existente, caso eu chame o metodo sem o paramtro quer dizer que eu quero criar um novo item.
    func showAlert(with console: Console?){
        let title = console == nil ? "Adicionar" : "Editar"
        
        let alert = UIAlertController(title: title + " plataforma", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Nome da Plataforma"
            
            // Se eu conseguir recuperar o console?.name quer dizer que estou no modo de edição, então vou carregar o textFiled com o nome da plataforma.
            if let name = console?.name {
                textField.text = name
            }
            
            alert.addAction(UIAlertAction(title: title, style: .default, handler: { (action) in
                let console = console ?? Console(context: self.context)
                
                console.name = alert.textFields?.first?.text
                
                do{
                    try self.context.save()
                    self.loadConsoles()
                }catch {
                    print(error.localizedDescription)
                }
                
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            alert.view.tintColor = UIColor(named: "second   ")
            self.present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func addConsole(_ sender: UIBarButtonItem) {
        showAlert(with: nil)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return consolesManager.consoles.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let console = consolesManager.consoles[indexPath.row]
        showAlert(with: console)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let console = consolesManager.consoles[indexPath.row]
        cell.textLabel?.text = console.name

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            consolesManager.deleteConsole(index: indexPath.row, context: context)
            
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade) 
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


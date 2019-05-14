//
//  GamesTableViewController.swift
//  MyGames
//
//  Created by Mauro Augusto Diniz on 08/05/19.
//  Copyright © 2019 Mauro Augusto Diniz. All rights reserved.
//

import UIKit
import CoreData

class GamesTableViewController: UITableViewController {
    
    // Classe responsavel por fazer a requisição ao core data
    var fetchedResultController: NSFetchedResultsController<Game>!
    
    // criando uma label via codigo para que seja exibida na tabela caso não tenha nenhum jogo cadastrado
    var label = UILabel()
    
    // criando a searchController
    let searchController = UISearchController(searchResultsController: nil)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "Não há jogos cadastrados!"
        label.textAlignment = .center
        
        // formatando a searchController
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = .white
        navigationItem.searchController = searchController
        
        searchController.searchBar.delegate = self
        
        loadGames()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameSegue" {
            let vc = segue.destination as! GameViewController
            
            if let games = fetchedResultController.fetchedObjects {
                vc.game = games[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
    
    // Buscando os jogos salvos no Core Data
    func loadGames(filtering: String = "") {
        
        let fetchRequest: NSFetchRequest<Game> = Game.fetchRequest()
        
        // Escolhendo uma regra para ordenar os dados retornados acima, no caso abaixo escolhi ordenação pelo titulo e em ordem ascendente
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        // o sortDescriptors recebe um array pois posso ter varias regras de ordenação e adiciona-las com virgula. Ex: fetchRequest.sortDescriptors = [sortDescriptor, consoleDescriptor, yearDescriptor ...]
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // validando o filtro digitado pelo usuario na searchbar
        if !filtering.isEmpty {
            // para aplicar filtros numa fetchRequest preciso implementar o NSPredicate
            let predicate = NSPredicate(format: "title contains [c] %@", filtering)
            fetchRequest.predicate = predicate
        }
        
        // fazendo a requisição
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        do {
           try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
        fetchedResultController.delegate = self
        
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // usando operador de coalescencia nula para retornar zero caso o fetchedObjects?.count  seja nulo
        let count = fetchedResultController.fetchedObjects?.count ?? 0
        
        tableView.backgroundView = count == 0 ? label : nil
        
        return count
    }

    // configurando a tableview
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GameTableViewCell

        // recuperando o jogo do fetchedResultController
        guard let game = fetchedResultController.fetchedObjects?[indexPath.row] else {
            return cell
        }
        
        cell.prepare(with: game)

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
            
            guard let game = fetchedResultController.fetchedObjects?[indexPath.row] else {return}
            context.delete(game)
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

extension GamesTableViewController: NSFetchedResultsControllerDelegate {
    // Sempre que algum objeto for modificado esse metodo será chamado
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            case .delete:
                if let indexPath = indexPath {
                    tableView.deleteRows(at: [indexPath], with: .fade)
            }
            default:
                tableView.reloadData()
        }
    }
}

extension GamesTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
    // quando o usuario limpar a pesquisa
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadGames()
        tableView.reloadData()
    }
    
    // quando o usuario clicar para procurar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let filtro = searchBar.text {
            loadGames(filtering: filtro)
        }
        
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

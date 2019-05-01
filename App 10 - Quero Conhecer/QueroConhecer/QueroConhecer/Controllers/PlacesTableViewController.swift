//
//  PlacesTableViewController.swift
//  QueroConhecer
//
//  Created by Mauro Augusto Diniz on 25/04/19.
//  Copyright © 2019 Mauro Augusto Diniz. All rights reserved.
//

import UIKit

class PlacesTableViewController: UITableViewController {
    
    var places: [Place] = []
    var lbNoPlaces: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        loadPlaces()
        
        lbNoPlaces = UILabel()
        lbNoPlaces.text = "Cadastre os locais que deseja conhecer\nclicando no ícone '+' acima."
        lbNoPlaces.textAlignment = .center
        lbNoPlaces.numberOfLines = 0
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // Carregando Places a partir dos dados salvos no device
    func loadPlaces() {
        if let placesData = UserDefaults.standard.data(forKey: "places"){
            do{
                places = try JSONDecoder().decode([Place].self, from: placesData)
                tableView.reloadData()
            }catch {
                print(error.localizedDescription)
            }
            
        }
    }
    
    // salvando um Place no device para que ele seja carregado quando o usuario abrir o app novamente
    func savePlaces() {
        let json = try? JSONEncoder().encode(places)
        UserDefaults.standard.set(json, forKey: "places")
    }
    
    @objc func showAll() {
        performSegue(withIdentifier: "mapSegue", sender: nil)
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if places.count > 0 {
            let btShowAll = UIBarButtonItem(title: "Mostrar todos no mapa", style: .plain, target: self, action: #selector(showAll))
            navigationItem.leftBarButtonItem = btShowAll
            tableView.backgroundView = nil
        } else {
            navigationItem.leftBarButtonItem = nil
            tableView.backgroundView = lbNoPlaces
        }
        
        return places.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let place = places[indexPath.row]
        cell.textLabel?.text = place.name
        
        return cell
    }

    
    // MARK: - Navigation

     // Criando um prepare for segue para que caso a proxima tela a ser exibida seja a Place Finder, o delegate dela será essa classe.
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier! != "mapSegue" {
             let vc = segue.destination as! PlaceFinderViewController
             vc.delegate = self
         } else {
            let vc = segue.destination as! MapViewController
            switch sender {
                case let place as Place:
                    vc.places = [place]
                default:
                    vc.places = places
            }
        }
     }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = places[indexPath.row]
        performSegue(withIdentifier: "mapSegue", sender: place)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            places.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            savePlaces()
        }
    }

}

// extensão criada para salvar um Place. O protocolo placeFinderDelegate está definido no placeFinderViewController
extension PlacesTableViewController: placeFinderDelegate {
    func addPlace(_ place: Place) {
        if !places.contains(place){
            places.append(place)
            savePlaces()
            tableView.reloadData()
        }
    }
}

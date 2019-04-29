//
//  PlaceFinderViewController.swift
//  QueroConhecer
//
//  Created by Mauro Augusto Diniz on 25/04/19.
//  Copyright © 2019 Mauro Augusto Diniz. All rights reserved.
//

import UIKit
import MapKit

class PlaceFinderViewController: UIViewController {

    enum placeFinderMessageType {
        case error(String)
        case confirmation(String)
    }
    
    @IBOutlet weak var tfCity: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var aiLoading: UIActivityIndicatorView!
    @IBOutlet weak var viewLoading: UIView!
    
    var place: Place!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // criando um gesture para que o usuario possa adicionar um local na lista ao pressionar um local do mapa por 2 segundos.
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(getLocation(_:)))
        gesture.minimumPressDuration = 2.0
        mapView.addGestureRecognizer(gesture)
    }
    
    @objc func getLocation(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            load(show: true)
            let point = gesture.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                self.load(show: false)
                if error == nil {
                    if !self.savePlace(with: placemarks?.first) {
                        self.showMessage(type: .error("Local não encontrado"))
                    }
                } else {
                    self.showMessage(type: .error("Erro desconhecido"))
                }
            }
        }
    }

    @IBAction func FindCity(_ sender: UIButton) {
        // Fazendo o teclado desaparecer após o usuario clicar no botão Escolher
        tfCity.resignFirstResponder()
        
        if let address = tfCity.text {
            load(show: true)
            // A classe CLGeocoder é a responsável por transformar um nome em uma localização geográfica com nome, endereço, etc.
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(address) { (placemarks, error) in
                self.load(show: false)
                if error == nil {
                    if !self.savePlace(with: placemarks?.first) {
                        self.showMessage(type: .error("Local não encontrado"))
                    }
                } else {
                    self.showMessage(type: .error("Erro desconhecido"))
                }
            }
        }
        
    }
    
    func savePlace(with placemark: CLPlacemark?) -> Bool {
        // Se eu conseguir desembrulhar o placemark e conseguir gerar uma coordenada a partir desse placemark, o metodo continua sendo executado, se houver algum problema já paro a execução retornando false.
        guard let placemark = placemark , let coordinate = placemark.location?.coordinate else {
            return false
        }
        
        // usando operador de coalescencia nula para checar se existe nome ou país no placemark, se não houver nenhum dos dois, retorno string "Desconhecido"
        let name = placemark.name ?? placemark.country ?? "Desconhecido"
        let address = Place.getFormattedAddress(with: placemark)
        
        // Aqui já vou ter um place com nome, coordenadas e endereço
        place = Place(name: name, latitude: coordinate.latitude, longitude: coordinate.longitude, address: address)
        
        // Com o place definido acima posso mostrar a região onde ele está. Os parametros dessa função são para definir o centro do mapa; quantos metros a partir do centro ele vai mostrar latitunalmente; quantos metros a partir do centro ele vai mostrar longitunalmente
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 3500, longitudinalMeters: 3500)
        
        // Fazendo o mapa exibir na tela a região definida
        mapView.setRegion(region, animated: true)
        
        self.showMessage(type: .confirmation(place.name))
        
        return true
    }
    
    // Metodo para exibir alertas
    func showMessage(type: placeFinderMessageType) {
        let title: String
        let message: String
        var hasConfirmation: Bool = false
        
        // definindo os tipos de mensagens que poderão ser exibidos
        switch type {
        case .confirmation(let name):
            title = "Local Encontrado"
            message = "Deseja adicionar '\(name)' à lista?"
            hasConfirmation = true
        case .error(let errorMessage):
            title = "Erro"
            message = errorMessage
        }
        
        // Para criar um alerta preciso criar o alerta em si (titulo, mensagem e tipo da janela) e as ações que serão exibidas. Após isso devo chamar o present() para que o alerta seja efetivamente exibida junto com as ações.
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        if hasConfirmation {
            let confirmAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                print("OK!!")
            }
            alert.addAction(confirmAction)
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func load(show: Bool) {
        viewLoading.isHidden = !show
        
        // Animando o Activity Indicator caso a viewLoading seja carregada
        if show {
            aiLoading.startAnimating()
        }else {
            aiLoading.stopAnimating()
        }
    }
    
    @IBAction func Close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

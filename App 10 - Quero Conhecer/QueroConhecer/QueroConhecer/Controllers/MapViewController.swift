//
//  MapViewController.swift
//  QueroConhecer
//
//  Created by Mauro Augusto Diniz on 25/04/19.
//  Copyright © 2019 Mauro Augusto Diniz. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    enum mapMessageType {
        case routeError
        case authorizationWarning
    }

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var viInfo: UIView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var aiLoading: UIActivityIndicatorView!
    
    var places: [Place]!
    // array criado para salvar os pontos de interesse pesquisados pelo usuario
    var pointsOfInterest: [MKAnnotation] = []
    // usando o sufixo 'lazy' para que a variavel seja instanciada somente no momento em que for utilizada
    lazy var locationManager = CLLocationManager()
    
    var btUserLocation: MKUserTrackingButton!
    
    var selectedAnnotation: PlaceAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.mapType = .mutedStandard
        
        searchBar.isHidden = true
        viInfo.isHidden = true
        
        locationManager.delegate = self
        
        if places.count == 1 {
            title = places[0].name
        } else{
            title = "Meus lugares"
        }
        
        for place in places {
            addToMap(place)
        }
        
        configureLocationButton()
        
        showPlaces()
        requestUserLocationAuthorization()
        
    }
    
    // instanciando e configurando o botão de localização
    func configureLocationButton() {
        btUserLocation = MKUserTrackingButton(mapView: mapView)
        btUserLocation.backgroundColor = .white
        btUserLocation.frame.origin.x = 10
        btUserLocation.frame.origin.y = 10
        btUserLocation.layer.cornerRadius = 5
        btUserLocation.layer.borderWidth = 1
        btUserLocation.layer.borderColor = UIColor(named: "main")?.cgColor
    }
    
    // solicitar ao usuario a autorização para acessar sua localização
    func requestUserLocationAuthorization() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                // mostrar o botão de localização no mapa
                mapView.addSubview(btUserLocation)
            case .denied:
                showMessage(type: .authorizationWarning)
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                break
            }
        }
    }
    
    func addToMap(_ place: Place) {
        let annotation  = PlaceAnnotation(place.coordinate, type: .place)
        annotation.coordinate = place.coordinate
        annotation.title = place.name
        annotation.address = place.address
        
        mapView.addAnnotation(annotation)
    }
    
    func showPlaces() {
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    // Ao clicar numa Annotation, a label lbInfo é exibida com as informações da annotation selecionada
    func showInfo() {
        lbName.text = selectedAnnotation!.title
        lbAddress.text = selectedAnnotation!.address
        viInfo.isHidden = false
    }

    // Mostrando a rota para o usuario
    @IBAction func showRoute(_ sender: UIButton) {
        //verificação para que só continue a execução do método caso o usuario tenha autorizado o uso da localização
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            showMessage(type: .authorizationWarning)
            return
        }
        
        // fazendo requisição aos servidores da apple, dizendo onde estou e para onde vou
        let request = MKDirections.Request()
        
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: selectedAnnotation!.coordinate))
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: locationManager.location!.coordinate))
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            if error == nil {
                if let response = response {
                    self.mapView.removeOverlays(self.mapView.overlays)
                    
                    if let route = response.routes.first {
                        print("Nome:", route.name)
                        print("Distância:", route.distance)
                        print("Duração:", route.expectedTravelTime)
                        print("=============")
                        
                        self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                        var annotations = self.mapView.annotations.filter({ !($0 is PlaceAnnotation) })
                        annotations.append(self.selectedAnnotation!)
                        self.mapView.showAnnotations(annotations, animated: true)
                    }
                }
            }else { // caso tenha retornado algum erro, mostrar o alerta abaixo
                self.showMessage(type: .routeError)
            }
        }
    }
    
    @IBAction func showSearchBar(_ sender: UIBarButtonItem) {
        // se estiver visivel, será escondida e vice-versa e esconde o teclado
        searchBar.isHidden = !searchBar.isHidden
        searchBar.resignFirstResponder()
    }
    
    func showMessage(type: mapMessageType) {
        let title = type == .authorizationWarning ? "Aviso" : "Erro"
        let message = type == .authorizationWarning ? "Para usar os recursos de localização do app, você precisa permitir o uso na tela de Ajustes." : "Não foi possível encontrar essa rota."

        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        if type == .authorizationWarning {
            let confirmAction = UIAlertAction(title: "Ir para Ajustes", style: .default) { (action) in
                
                // recuperando o caminho para o usuário chegar na tela de ajustes através do UIApplication.openSettingsURLString
                if let appSetings = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSetings, options: [:], completionHandler: nil)
                }
            }
            alert.addAction(confirmAction)
        }
        present(alert, animated: true, completion: nil)
    }
    
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is PlaceAnnotation) {
            return nil
        }
        
        let type = (annotation as! PlaceAnnotation).type
        let identifier = "\(type)"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "") as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        annotationView?.annotation = annotation
        annotationView?.canShowCallout = true
        annotationView?.markerTintColor = type == .place ? UIColor(named: "main") : UIColor(named: "poi")
        annotationView?.glyphImage = type == .place ? UIImage(named: "placeGlyph"): UIImage(named: "poiGlyph")
        annotationView?.displayPriority = type == .place ? .required : .defaultHigh
        
        return annotationView
    }
}

extension MapViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        aiLoading.startAnimating()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBar.text
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if error == nil {
                guard let response = response else {
                    self.aiLoading.stopAnimating()
                    return
                }
                self.mapView.removeAnnotations(self.pointsOfInterest)
                self.pointsOfInterest.removeAll()
                
                // adiciona todos os pontos encontrados com base na pesquisa em um array [pointsOfInterest]
                for item in response.mapItems {
                    let annotation = PlaceAnnotation(item.placemark.coordinate, type: .pointOfInterest)
                    annotation.title = item.name
                    annotation.subtitle = item.phoneNumber
                    annotation.address = Place.getFormattedAddress(with: item.placemark)
                    self.pointsOfInterest.append(annotation)
                }
                // adiciona as anotações retornadas do servidor e adciona no mapa
                self.mapView.addAnnotations(self.pointsOfInterest)
                self.mapView.showAnnotations(self.pointsOfInterest, animated: true)
                
                self.aiLoading.stopAnimating()
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        // Modificar a camera para que ela fique em 3D
        let camera = MKMapCamera()
        camera.centerCoordinate = view.annotation!.coordinate
        camera.pitch = 80
        camera.altitude = 100
        mapView.setCamera(camera, animated: true)
        
        
        selectedAnnotation = (view.annotation as! PlaceAnnotation)
        showInfo()
    }
    
    // método que desenha um overlay no mapa
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor(named: "main")?.withAlphaComponent(0.8)
            renderer.lineWidth = 5.0
            
            return renderer
        }
        // caso o overlay não seja do tipo polyline, retornar um overlay genérico
        return MKOverlayRenderer(overlay: overlay)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            mapView.showsUserLocation = true
            mapView.addSubview(btUserLocation)
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
}

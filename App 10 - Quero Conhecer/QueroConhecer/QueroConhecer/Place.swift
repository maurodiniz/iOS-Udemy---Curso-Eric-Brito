//
//  Place.swift
//  QueroConhecer
//
//  Created by Mauro Augusto Diniz on 27/04/19.
//  Copyright © 2019 Mauro Augusto Diniz. All rights reserved.
//

import Foundation
import MapKit

struct Place: Codable {
    let name: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let address: String
    
    // variavel computada para fazer a junção de latitude com longitude e assim ter uma coordenada completa
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    // Criando essa função Estática para que eu possa acessa-la mesmo sem ter um Place() criado. O objetivo é passar um placemark e ela retornar o endereço formatado.
    static func getFormattedAddress(with placemark: CLPlacemark) -> String {
        var address = ""
        
        // placemark.thoroughfare representa o nome da rua
        if let street = placemark.thoroughfare {
            address += street
        }
        // placemark.subThoroughfare representa o numero do endereço
        if let number = placemark.subThoroughfare {
            address += " \(number)"
        }
        // placemark.subLocality representa o bairro
        if let subLocality = placemark.subLocality {
            address += ", \(subLocality)"
        }
        // placemark.locality representa a cidade. Usei '\n' para quebrar a linha na string
        if let city = placemark.locality {
            address += "\n\(city)"
        }
        // placemark.administrativeArea representa o estado
        if let state = placemark.administrativeArea {
            address += " - \(state)"
        }
        // placemark.postalCode representa o CEP
        if let postalCode = placemark.postalCode {
            address += "\nCEP: \(postalCode)"
        }
        //
        if let country = placemark.country {
            address += "\n\(country)"
        }
        
        return address
    }
}

// Extensão criada para dizer como comparar dois Places, utilizando o protoclo Equatable
extension Place: Equatable {
    static func ==(lhs: Place, rhs: Place) -> Bool{
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

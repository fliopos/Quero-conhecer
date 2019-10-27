//
//  Place.swift
//  QueroConhecer
//
//  Created by Leonardo Almeida on 14/10/19.
//  Copyright © 2019 Leonardo Almeida. All rights reserved.
//

import Foundation
import MapKit

struct Place: Codable {
    let name:  String
    let latitude: CLLocationDegrees
    let longitudade: CLLocationDegrees
    var address: String
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitudade)
    }
    
    static func getFormattedAdrress (with placemark: CLPlacemark) -> String {
        var address = ""
        if let street = placemark.thoroughfare {
            address += street //Rua
        }
        if let number = placemark.subThoroughfare {
            address += " \(number)" //Número
        }
        if let subLocality = placemark.subLocality {
            address += ",\(placemark.locality)" //Cidade
        }
        if let city = placemark.locality {
            address += "\n\(city)" //Estado
        }
        if let postalCode = placemark.postalCode {
            address += "\nCEP: \(postalCode)" //CEP
        }
        
        if let country = placemark.country {
                 address += "\n\(country)" //Pais

        }
        return address
    }
}

extension Place: Equatable {
    static func ==(lhs: Place, rhs: Place) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitudade == rhs.longitudade
    }
}

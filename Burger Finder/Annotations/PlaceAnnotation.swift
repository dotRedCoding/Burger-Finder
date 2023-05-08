//
//  PlaceAnnotation.swift
//  Burger Finder
//
//  Created by Jared Infantino on 2023-05-08.
//

import Foundation
import MapKit

class PlaceAnnotation: MKPointAnnotation {
    
    let mapItem: MKMapItem
    let id = UUID()
    var isSelected: Bool = false
    
    init(mapItem: MKMapItem) {
        self.mapItem = mapItem
        super.init()
        self.coordinate = mapItem.placemark.coordinate
    }
    
    var name: String {
        mapItem.name ?? ""
    }
    
    var phone: String {
        mapItem.phoneNumber ?? ""
    }
    
    var address: String { // when all of these are put together it will form an address
        "\(mapItem.placemark.subThoroughfare ?? "") \(mapItem.placemark.thoroughfare ?? "") \(mapItem.placemark.locality ?? "") \(mapItem.placemark.countryCode ?? "")"
    }
    
    var location: CLLocation {
        mapItem.placemark.location ?? CLLocation.default // defulat propert set in CLLocation+Etensions file
    }
    
   
}

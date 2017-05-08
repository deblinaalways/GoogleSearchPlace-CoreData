//
//  MapRegionHelper.swift
//  SearchPlace
//
//  Created by Deblina Das on 18/04/17.
//  Copyright © 2017 Deblina Das. All rights reserved.
//

import Foundation
import MapKit

class MapRegionHelper {
    
    static func mapRegionForCoordinates(coordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion? {
        guard coordinates.count > 0 else {
            return MKCoordinateRegion(center: CLLocationCoordinate2DMake(0, 0), span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 360))
        }
        let maxLatitude  = coordinates.reduce(Double(Int.min), { max($0, $1.latitude)  })
        let minLatitude  = coordinates.reduce(Double(Int.max), { min($0, $1.latitude)  })
        let maxLongitude = coordinates.reduce(Double(Int.min), { max($0, $1.longitude) })
        let minLongitude = coordinates.reduce(Double(Int.max), { min($0, $1.longitude) })
        
        var latitudinalMetres  = CLLocation(latitude: maxLatitude, longitude: 0).distance(from: CLLocation(latitude: minLatitude, longitude: 0)) * 1.3            // North to south distance with a 15% inset on each side.
        var longitudinalMetres = CLLocation(latitude: 0, longitude: maxLongitude).distance(from: CLLocation(latitude: 0, longitude: minLongitude)) * 1.3            // East to west distance with a 15% inset on each side.
        
        latitudinalMetres  = max(1000, latitudinalMetres)       // Show at least 1km.
        longitudinalMetres = max(1000, longitudinalMetres)
        
        let centerLatitude  = (minLatitude  + maxLatitude)  / 2
        let centerLongitude = (minLongitude + maxLongitude) / 2
        let center = CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude)
        
        return MKCoordinateRegionMakeWithDistance(center, latitudinalMetres, longitudinalMetres)
    }
}

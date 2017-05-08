//
//  MapViewManager.swift
//  SearchPlace
//
//  Created by Deblina Das on 18/04/17.
//  Copyright © 2017 Deblina Das. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewManager: NSObject, MKMapViewDelegate {
    fileprivate var mapView: MKMapView!
    fileprivate var places: [CLLocationCoordinate2D]?
    
    init(mapView: MKMapView, places: [CLLocationCoordinate2D]) {
        self.mapView = mapView
        self.places = places
        super.init()
        reloadPlaces()
    }
    
    fileprivate func reloadPlaces() {
        guard let places = places else {return}
        removeAnnotation(From: places)
        addAnnotationToPlace(To: places)
        let region = MapRegionHelper.mapRegionForCoordinates(coordinates: places)
        mapView.setRegion(region!, animated: true)
    }
    
    fileprivate func addAnnotationToPlace(To places: [CLLocationCoordinate2D]) {
        places.forEach { mapView.addAnnotation(MapAnnotation(coordinate: $0)) }
    }
    
    fileprivate func removeAnnotation(From places: [CLLocationCoordinate2D]) {
        places.forEach { mapView.removeAnnotation(MapAnnotation(coordinate: $0)) }
    }
    
}

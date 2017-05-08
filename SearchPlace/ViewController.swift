//
//  ViewController.swift
//  SearchPlace
//
//  Created by Deblina Das on 18/04/17.
//  Copyright © 2017 Deblina Das. All rights reserved.
//

import UIKit
import GooglePlaces
import MapKit

//AIzaSyBxs66k-161duc0IkuCDBSEKi_hDMMCM4I

class ViewController: UIViewController, GMSAutocompleteResultsViewControllerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    fileprivate var mapViewManager: MapViewManager!
    fileprivate var resultsViewController: GMSAutocompleteResultsViewController?
    fileprivate var searchController: UISearchController?
    private(set) var places: [Place]?
    private(set) var placeLocations = [CLLocationCoordinate2D]()
    fileprivate lazy var activityIndicator: ActivityIndicator = ActivityIndicator(viewController: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        definesPresentationContext = true
        searchController?.hidesNavigationBarDuringPresentation = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPlaces()
        self.mapViewManager = MapViewManager(mapView: self.mapView, places: self.placeLocations)
        resetRegion()
    }
    
    func fetchPlaces() {
        let managedObejctContext = ManagedObjectContext.managedObjectContext()
        places = Place.getManagedObjects(managedObejctContext) as? [Place]
        if (places?.count)! > 0 {
            places?.forEach {
                let location = CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
                placeLocations.append(location)
            }
        }
    }
    
    func resetRegion() {
        let region = MapRegionHelper.mapRegionForCoordinates(coordinates: placeLocations)
        mapView.setRegion(region!, animated: true)
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        guard let placeAddress = place.formattedAddress else { return }
        activityIndicator.start()
        forwardGeocoding(address: placeAddress) { (placeLocation) in
            DispatchQueue.main.async {
                self.activityIndicator.stop()
                if placeLocation.latitude != 0.0 && placeLocation.longitude != 0.0 {
                    self.fetchPlaces()
                    self.mapViewManager = MapViewManager(mapView: self.mapView, places: self.placeLocations)
                }
            }
        }
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func forwardGeocoding(address: String, completion: ((_ location: CLLocationCoordinate2D) -> Void)?) {
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            var placeLocation = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
            if error != nil {
                print(error!)
                completion?(placeLocation)
                return
            }
            if (placemarks?.count)! > 0 {
                let placemark = placemarks?[0]
                placeLocation = (placemark?.location?.coordinate)!
                self.saveLocationToCoreData(with: address, location: placeLocation)
            }
            completion?(placeLocation)
        })
    }
    
    func saveLocationToCoreData(with address: String, location: CLLocationCoordinate2D) {
        
        let managedObjectContext = ManagedObjectContext.managedObjectContext()
        let place: Place         = Place.managedObject(managedObjectContext)
        place.placeID            = NSUUID().uuidString
        place.latitude           = location.latitude
        place.longitude          = location.longitude
        place.placeName          = address
        try! managedObjectContext.save()
    }
}


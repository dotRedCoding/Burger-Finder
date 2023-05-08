//
//  ViewController.swift
//  Burger Finder
//
//  Created by Jared Infantino on 2023-05-05.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    // MARK: - PROPERTY
    var locationManager: CLLocationManager?
    private var places: [PlaceAnnotation] = []
    
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.delegate = self
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    lazy var searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.delegate = self
        searchTextField.layer.cornerRadius = 10
        searchTextField.clipsToBounds = true
        searchTextField.backgroundColor = UIColor.white
        searchTextField.placeholder = "Search"
        searchTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0)) // adds padding
        searchTextField.leftViewMode = .always
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        return searchTextField
    }()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // locationManager init
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.requestLocation()
        
        setupUI()
        
    }
    // MARK: - FUNCTION
    private func setupUI() {
        
        view.addSubview(searchTextField) // order matters here think VStack
        view.addSubview(mapView)
        view.bringSubviewToFront(searchTextField) // this has to be last I guess
        
        // add constraints to searchTextField
        searchTextField.widthAnchor.constraint(equalToConstant: view.bounds.size.width / 1.2).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        searchTextField.returnKeyType = .search
        
        // add constraints to mapView
        mapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true // map width = view width
        mapView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true // map height = view height
        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func checkLocationAuth() {
        guard let locationManager = locationManager,
              let location = locationManager.location else { return }
        
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 750, longitudinalMeters: 750)
            mapView.setRegion(region, animated: true)
        case .denied:
            print("Location services have been denied")
        case.notDetermined, .restricted:
            print("Location can not be determined or it has been restricted")
        @unknown default:
            print("Unknown issue, unable to get location")
        }
    }
    
    private func findNearbyPlaces(by query: String) {
        // clear all pins
        mapView.removeAnnotations(mapView.annotations)
        let request = MKLocalSearch.Request() // perfroms local searches using Apples framework
        request.naturalLanguageQuery = query
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let response = response, error == nil else { return }
            
            self?.places = response.mapItems.map(PlaceAnnotation.init) // pass individual mapItems into PlaceAnnotation init (will be an array of Place Annotations)
            self?.places.forEach { place in // go through places and add the annotation to the mapView for each place
                self?.mapView.addAnnotation(place)
            }
            if let places = self?.places {
                self?.presentPlaces(places: places)
            }
        }
    }
        
    func presentPlaces(places: [PlaceAnnotation]) {
            
            guard let locationManager = locationManager,
                  let userLocation = locationManager.location
            else { return }
            
            let placesVC = PlacesTableViewController(userLocation: userLocation, places: places)
            placesVC.modalPresentationStyle = .pageSheet
            
            if let sheet = placesVC.sheetPresentationController {
                sheet.prefersGrabberVisible = true
                sheet.detents = [.medium(), .large()] // an array of heights
                present(placesVC, animated: true)
            }
            
        }
    
    private func clearAllSelections() {
        self.places = self.places.map { place in
            place.isSelected = false
            return place
        }
    }
        
    
    // MARK: - BODY
    
    
    
}

// MARK: - EXTENSIONS

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        // clear all selections
        clearAllSelections()
        
        guard let selectedAnnotation =  annotation as? PlaceAnnotation else { return }
        let placeAnnotation = self.places.first(where: {$0.id == selectedAnnotation.id})
        placeAnnotation?.isSelected = true
        presentPlaces(places: self.places)
        
    }
    
    
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let text = textField.text ?? ""
        if !text.isEmpty { // if textField is NOT empty
            textField.resignFirstResponder()
            // find nearby places
            findNearbyPlaces(by: text)
        }
        
        return true
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuth()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


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
    
    lazy var mapView: MKMapView = {
       let map = MKMapView()
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    lazy var searchTextField: UITextField = {
       let searchTextField = UITextField()
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
    // MARK: - BODY
    
    

}

// MARK: - EXTENSIONS

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


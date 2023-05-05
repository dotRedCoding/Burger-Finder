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
        
        setupUI()
        
    }
    // MARK: - FUNCTION
    private func setupUI() {
        
        view.addSubview(searchTextField) // order matters here think VStack
        view.addSubview(mapView)
        view.bringSubviewToFront(searchTextField) // this has to be last I guess
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
    // MARK: - BODY
    
    

}


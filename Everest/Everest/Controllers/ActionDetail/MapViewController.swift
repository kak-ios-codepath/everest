//
//  MapViewController.swift
//  Everest
//
//  Created by Kavita Gaitonde on 10/25/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    fileprivate var locationManager: CLLocationManager!
    fileprivate let annotation = MKPointAnnotation()
    var momentCoordinate: CLLocationCoordinate2D!
    var selectedMap : (MKMapView, CLLocationCoordinate2D, String?) -> Void = { (mapView: MKMapView, momentCoordinate: CLLocationCoordinate2D, location: String?) in }
    var location: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if momentCoordinate != nil { //update
            self.setupPin()
        } else { //new
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mapViewTapped))
        mapView.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapViewTapped(gestureRecognizer: UIGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        self.momentCoordinate = coordinate
        let clCoordinate = CLLocation(latitude: momentCoordinate.latitude, longitude: momentCoordinate.longitude)
        self.fetchCountryAndCity(location: clCoordinate) { (country, city) in
            self.location = "\(city), \(country)"
            self.addAnnotationAtCoordinate(coordinates: ["lat": self.momentCoordinate.latitude, "lon": self.momentCoordinate.longitude], title: self.location)
        }
    }
    
    @IBAction func cancelAction(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectAction(_ sender: AnyObject) {
        selectedMap(self.mapView, self.momentCoordinate, self.location)
        dismiss(animated: true, completion: nil)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        momentCoordinate = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        self.setupPin()
        locationManager.stopUpdatingLocation()
    }
    
    func setupPin () {
        let region = MKCoordinateRegion(center: momentCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
        let coordinate = CLLocation(latitude: momentCoordinate.latitude, longitude: momentCoordinate.longitude)
        self.fetchCountryAndCity(location: coordinate) { (country, city) in
            self.location = "\(city), \(country)"
            self.addAnnotationAtCoordinate(coordinates: ["lat": self.momentCoordinate.latitude, "lon": self.momentCoordinate.longitude], title: self.location)
        }
    }
    
    func fetchCountryAndCity(location: CLLocation, completion: @escaping (String, String) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print(error)
            } else if let country = placemarks?.first?.country,
                let city = placemarks?.first?.locality {
                completion(country, city)
            }
        }
    }
    
    func addAnnotationAtCoordinate(coordinates:[String:Double], title: String) {
        annotation.coordinate = CLLocationCoordinate2D(latitude: coordinates["lat"]!, longitude: coordinates["lon"]!)
        self.mapView.addAnnotation(annotation)
        annotation.title = "\(title)"
        self.mapView.addAnnotation(annotation)
    }
}

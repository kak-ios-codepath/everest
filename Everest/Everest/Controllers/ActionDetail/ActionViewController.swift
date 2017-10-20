//
//  ActionViewController.swift
//  Everest
//
//  Created by Kavita Gaitonde on 10/13/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit
import MapKit

class ActionViewController: UIViewController {

    @IBOutlet weak var momentTitle: UITextField!
    @IBOutlet weak var momentDetails: UITextView!
    @IBOutlet weak var addPhotoLabel: UILabel!
    @IBOutlet weak var photoBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapBtn: UIButton!
    
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check for Location Services
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }

    }

    @IBAction func onPhotoBtn(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onMapBtn(_ sender: UIButton) {
    
    }
    
    @IBAction func onFacebookBtn(_ sender: UIButton) {
    
    }
    
    @IBAction func onTwitterBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func onMomentFinished(_ sender: UIButton) {
    
    }
    
}

//MARK:- Image Picker delegate
extension ActionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //TODO: do something with the picked image
        
        dismiss(animated: true, completion: nil)
    }
}

//MARK:- Map delegate
extension ActionViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
    }
}

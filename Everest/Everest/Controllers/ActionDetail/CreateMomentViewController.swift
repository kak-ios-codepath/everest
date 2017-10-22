//
//  CreateMomentViewController.swift
//  Everest
//
//  Created by Kavita Gaitonde on 10/13/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit
import MapKit

class CreateMomentViewController: UIViewController {

    @IBOutlet weak var momentTitle: UITextField!
    @IBOutlet weak var momentDetails: UITextView!
    @IBOutlet weak var addPhotoLabel: UILabel!
    @IBOutlet weak var photoBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapBtn: UIButton!
    
    fileprivate var locationManager: CLLocationManager!
    
    var moment: Moment!
    var actId: String!
    var momentCoordinate: CLLocationCoordinate2D!
    var geoLocation: [String : String]?
    var location: String?
    
    var picsUrl: [String]? = ["https://www.lipstiq.com/wp-content/uploads/2014/06/62.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

    }

    @IBAction func onPhotoBtn(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onMapBtn(_ sender: UIButton) {
        
        let coordinate = CLLocation(latitude: momentCoordinate.latitude, longitude: momentCoordinate.longitude)
        geoLocation = ["lat": String(momentCoordinate.latitude), "lon": String(momentCoordinate.longitude)]
        
        addAnnotationAtCoordinate(coordinates: ["lat": momentCoordinate.latitude, "lon": momentCoordinate.longitude], title: "")
         fetchCountryAndCity(location: coordinate) { (country, city) in
            self.location = "\(city), \(country)"
        }
    }
    
    @IBAction func onFacebookBtn(_ sender: UIButton) {
    
    }
    
    @IBAction func onTwitterBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func onMomentFinished(_ sender: UIButton) {
        
        guard let title = momentTitle.text else { return
            //TODO: message to fill title
        }
        guard let details = momentDetails.text else { return
            //TODO: message to fill details
        }

        moment = Moment(title: title, details: details, actId: actId, userId: FireBaseManager.UID, timestamp: "\(Date())", picUrls: picsUrl!, geoLocation: geoLocation, location: location)
        
        FireBaseManager.shared.updateMoment(moment: moment, newMoment: true)
        
        navigationController?.popViewController(animated: true)
    }
    
}


//MARK:- Image Picker delegate
extension CreateMomentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        if let imageData = UIImagePNGRepresentation(originalImage) as Data? {
            FireBaseManager.shared.uploadImage(data: imageData) { (imageURL, downloadURL, error) in
                print (imageURL)
                print (downloadURL ?? "test")
//                moment.picUrls = [""]
            }
        }
        
        
        dismiss(animated: true, completion: nil)
    }
}


//MARK:- Map delegate
extension CreateMomentViewController: CLLocationManagerDelegate, MKMapViewDelegate {
   
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        momentCoordinate = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        let region = MKCoordinateRegion(center: momentCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
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
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: coordinates["lat"]!, longitude: coordinates["lon"]!)
        mapView.addAnnotation(annotation)
        annotation.title = "\(title)"
        self.mapView.addAnnotation(annotation)
    }
}

//
//  CreateMomentViewController.swift
//  Everest
//
//  Created by Kavita Gaitonde on 10/13/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit
import MapKit
import FacebookShare
import MBProgressHUD

class CreateMomentViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate
{
    @IBOutlet weak var momentTitle: UITextField!
    @IBOutlet weak var momentDetails: UITextView!
    @IBOutlet weak var addPhotoLabel: UILabel!
    @IBOutlet weak var photoBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapBtn: UIButton!
    @IBOutlet weak var publishButton: UIButton!
    
    @IBOutlet weak var momentImageView: UIImageView!
    fileprivate var locationManager: CLLocationManager!
    
    var moment: Moment!
    var action: Action!
    var momentCoordinate: CLLocationCoordinate2D!
    var geoLocation: [String : String]?
    var location: String?
    var isTakingPic = false
    var shareOnFB = false
    var shareOnTwitter = false
    var picsUrl: [String]?
    var addedDetails = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        momentTitle.text = MainManager.shared.availableActs[action.id]?.title
        self.momentImageView.isHidden = true
        self.momentDetails.delegate = self
        self.momentTitle.delegate = self
        
        
    }
    
    @IBAction func onPhotoBtn(_ sender: UIButton) {
        self.momentImageView.isHidden = false
        
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onMapBtn(_ sender: UIButton) {
        self.momentImageView.isHidden = true
        
        let coordinate = CLLocation(latitude: momentCoordinate.latitude, longitude: momentCoordinate.longitude)
        geoLocation = ["lat": String(momentCoordinate.latitude), "lon": String(momentCoordinate.longitude)]
        
        addAnnotationAtCoordinate(coordinates: ["lat": momentCoordinate.latitude, "lon": momentCoordinate.longitude], title: "")
        fetchCountryAndCity(location: coordinate) { (country, city) in
            self.location = "\(city), \(country)"
        }
    }
    
    @IBAction func onFacebookBtn(_ sender: UIButton) {
        self.shareOnFB = true
        
    }
    
    @IBAction func onTwitterBtn(_ sender: UIButton) {
        self.shareOnTwitter = true
    }
    
    @IBAction func handleTapGesture(_ sender: AnyObject) {
        self.momentDetails.resignFirstResponder()
        self.momentTitle.resignFirstResponder()
    }
    
    @IBAction func handleCancel(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onMomentFinished(_ sender: UIButton) {
        let title: String!
        let details: String!
        
        if !addedDetails || momentTitle.text == nil || (momentTitle.text?.characters.count)! == 0 || momentDetails.text == nil || (momentDetails.text?.characters.count)! == 0  {
            let alertController = UIAlertController(title: "Error", message: "Please add title and details for your moment",  preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: { (action:UIAlertAction!) in
            })
            alertController.addAction(okAction)
            // Present Alert
            self.present(alertController, animated: true, completion:nil)
            return
        }
        
        title = momentTitle.text!
        details = momentDetails.text!
        
        
        self.moment = Moment(title: title, details: details, actId: self.action.id, userId: (User.currentUser?.id)!, profilePhotoUrl: User.currentUser?.profilePhotoUrl, userName: (User.currentUser?.name)!, timestamp: "\(Date())", picUrls: self.picsUrl, geoLocation: self.geoLocation, location: self.location)
        
        FireBaseManager.shared.updateMoment(actId: self.action.id, moment: self.moment, newMoment: true)
        //            FireBaseManager.shared.updateAction(action: self.action)
        FireBaseManager.shared.updateActionStatus(id: self.action.id, status: Constants.ActionStatus.completed.rawValue)
        let act = MainManager.shared.availableActs[self.action.id]
        FireBaseManager.shared.updateScore(incrementBy: (act?.score)!)
        
        DispatchQueue.main.async {
            if self.shareOnFB {
                //if moment != nil {
                var url:URL!
                if self.picsUrl != nil {
                    url = URL(string: (self.picsUrl?[0])!)
                } else {
                    url = URL(string: "https://firebasestorage.googleapis.com/v0/b/everest-f98ba.appspot.com/o/5IuIsoIeRhexy8BKHzzpfMyCy2K2%2F530229533534.jpg?alt=media&token=755f391f-3489-42b0-87a3-c93e061af76c")
                }
                var content = LinkShareContent(url: url!)
                content.quote = "I did it!"
                let shareDialog = ShareDialog(content: content)
                shareDialog.mode = .native
                shareDialog.failsOnInvalidData = true
                shareDialog.completion = { result in
                    // Handle share results
                    print (result)
                }
                try! shareDialog.show()
                //}*
            }
        }
        self.dismiss(animated: true, completion: nil)
        
        
        //navigationController?.popViewController(animated: true)
    }
    
    // MARK: - TextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.isFirstResponder == true {
            textField.placeholder = nil
        }
    }
    
    // MARK: - TextView Delegate
    
    func textViewDidBeginEditing(_: UITextView) {
        self.addedDetails = true
        self.momentDetails.text = ""
        self.momentDetails.textColor = UIColor.darkGray
    }
    
    func textViewDidEndEditing(_: UITextView) {
    }
    
}



//MARK:- Image Picker delegate
extension CreateMomentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        isTakingPic = true
        self.publishButton.isUserInteractionEnabled = false
        let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        guard let reducedSizeImage = originalImage?.resized(withPercentage: 0.3) else {return}
        
        if let imageData = UIImagePNGRepresentation(reducedSizeImage) as Data? {
            FireBaseManager.shared.uploadImage(data: imageData) { (folderAndFileName, imageUrl, error) in
                self.picsUrl = [imageUrl!]
                self.momentImageView.setImageWith(URL(string: imageUrl!)!)
                self.publishButton.isUserInteractionEnabled = true
                MBProgressHUD.hide(for: self.view, animated: true)
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

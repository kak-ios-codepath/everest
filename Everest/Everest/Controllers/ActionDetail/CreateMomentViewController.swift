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
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var shareToFBLabel: UILabel!
    @IBOutlet weak var shareFBSwitch: UISwitch!
    @IBOutlet weak var actionTitle: UILabel!
    @IBOutlet weak var momentTitle: UITextField!
    @IBOutlet weak var momentDetails: UITextView!
    @IBOutlet weak var addPhotoLabel: UILabel!
    @IBOutlet weak var photoBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var mapBtn: UIButton!
    @IBOutlet weak var publishButton: UIButton!
    @IBOutlet weak var momentImageView: UIImageView!
    fileprivate var selectedImage: UIImage!
    fileprivate var isEditMode: Bool = false
    
    var moment: Moment!
    var actionId: String!
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
        self.momentDetails.delegate = self
        self.momentTitle.delegate = self
        
        
        if moment != nil { //edit mode
            //ERROR should never happen
            if moment.userId == User.currentUser?.id {
                dismiss(animated: true, completion: nil)
            }
            
            isEditMode = true
            addedDetails = true
            self.actionId = moment.actId
            self.momentTitle.text = moment.title
            self.momentDetails.text = moment.details
            self.location = moment.location
            if let geoLoc = moment.geoLocation {
                self.geoLocation = geoLoc
                if let lat = self.geoLocation?["lat"], let doubleLat = Double(lat) {
                    if let lon = self.geoLocation?["lon"], let doubleLon = Double(lon) {
                        self.momentCoordinate = CLLocationCoordinate2D(latitude: doubleLat, longitude: doubleLon)
                        let region = MKCoordinateRegion(center: momentCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                        self.mapView.setRegion(region, animated: true)
//                        self.mapImageView.isHidden = true
                        self.addAnnotationAtCoordinate(coordinates: ["lat": momentCoordinate.latitude, "lon": momentCoordinate.longitude], title: "")
                    }
                }
            }
            self.location = moment.location
            if let pics = moment.picUrls {
                self.momentImageView.setImageWith(URL(string: pics[0])!)
                self.momentImageView.clipsToBounds = true
                self.momentImageView.contentMode = .scaleAspectFill
                self.picsUrl = pics
            }
            self.publishButton.titleLabel?.text = "Save"
            self.cancelButton.isHidden = true
            self.navigationItem.title = "Edit a moment"
        } else { //create mode
            isEditMode = false
            self.publishButton.titleLabel?.text = "Publish"
            self.navigationItem.title = "Add a moment"
        }
        
        self.actionTitle.text = MainManager.shared.availableActs[actionId]?.title
        if let loc = self.location {
            self.locationLabel.text = loc
        } else {
            self.locationLabel.text = ""
        }
        self.mapView.isUserInteractionEnabled = true
        self.momentImageView.isUserInteractionEnabled = true
        var tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(mapViewTapped))
        self.mapView.addGestureRecognizer(tapGesture1)
        tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(mapViewTapped))
        //self.mapImageView.addGestureRecognizer(tapGesture1)
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(momentImageViewTapped))
        self.momentImageView.addGestureRecognizer(tapGesture2)
        
        if User.currentUser?.isFacebookUser() == false {
            shareFBSwitch.isHidden = true
            shareToFBLabel.isHidden = true
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func mapViewTapped(gestureRecognizer: UIGestureRecognizer) {
        if momentCoordinate == nil {
            self.goToMapViewController()
        } else {
            let alertController = UIAlertController(title: "", message: "Change the location?",  preferredStyle: UIAlertControllerStyle.actionSheet)
            let yesAction = UIAlertAction(title: "Yes", style: .default , handler: { (action:UIAlertAction!) in
                self.goToMapViewController()
            })
            alertController.addAction(yesAction)
            let noAction = UIAlertAction(title: "Cancel", style: .cancel , handler: { (action:UIAlertAction!) in
            })
            alertController.addAction(noAction)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive , handler: { (action:UIAlertAction!) in
                self.momentCoordinate = nil
                self.location = nil
                self.locationLabel.text = ""
                self.geoLocation = nil
//                self.mapImageView.isHidden = false
            })
            alertController.addAction(deleteAction)
            self.present(alertController, animated: true, completion:nil)
        }
    }
    
    func addAnnotationAtCoordinate(coordinates:[String:Double], title: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: coordinates["lat"]!, longitude: coordinates["lon"]!)
        mapView.addAnnotation(annotation)
        annotation.title = "\(title)"
        self.mapView.addAnnotation(annotation)
    }

    func goToMapViewController() {
        let storyboard = UIStoryboard.init(name: "UserProfile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        if self.momentCoordinate != nil {
            vc.momentCoordinate = self.momentCoordinate
        }
        vc.selectedMap = { (mapView: MKMapView, momentCoordinate: CLLocationCoordinate2D, location: String?) in
            self.momentCoordinate = momentCoordinate
            let region = MKCoordinateRegion(center: momentCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
//            self.mapImageView.isHidden = true
            self.location = location
            if let loc = self.location {
                self.locationLabel.text = loc
            } else {
                self.locationLabel.text = ""
            }
            self.geoLocation = ["lat": String(momentCoordinate.latitude), "lon": String(momentCoordinate.longitude)]
            self.addAnnotationAtCoordinate(coordinates: ["lat": momentCoordinate.latitude, "lon": momentCoordinate.longitude], title: "")
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func momentImageViewTapped(gestureRecognizer: UIGestureRecognizer) {
        if selectedImage == nil {
            
            let alertController = UIAlertController(title: "Select Image", message: "How would you like to select an image to upload?",  preferredStyle: UIAlertControllerStyle.actionSheet)
            let cameraAction = UIAlertAction(title: "Camera", style: .default , handler: { (action:UIAlertAction!) in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let vc = UIImagePickerController()
                    vc.delegate = self
                    vc.allowsEditing = false
                    vc.modalPresentationStyle = .fullScreen
                    vc.sourceType = .camera
                    vc.cameraCaptureMode = .photo
                    self.present(vc, animated: true, completion: nil)
                }
            })
            alertController.addAction(cameraAction)
            let photoLibraryAction = UIAlertAction(title: "PhotoLibrary", style: .default, handler: { (action:UIAlertAction!) in
                let vc = UIImagePickerController()
                vc.delegate = self
                vc.allowsEditing = false
                vc.modalPresentationStyle = .fullScreen
                vc.sourceType = .photoLibrary
                self.present(vc, animated: true, completion: nil)
            })
            alertController.addAction(photoLibraryAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action:UIAlertAction!) in
            })
            alertController.addAction(cancelAction)
            // Present Alert
            self.present(alertController, animated: true, completion:nil)
        } else {
            let alertController = UIAlertController(title: "", message: "Change photo?",  preferredStyle: UIAlertControllerStyle.actionSheet)
            let yesAction = UIAlertAction(title: "Yes", style: .default , handler: { (action:UIAlertAction!) in
                self.selectedImage = nil
                self.momentImageViewTapped(gestureRecognizer: gestureRecognizer)
            })
            alertController.addAction(yesAction)
            let noAction = UIAlertAction(title: "Cancel", style: .cancel , handler: { (action:UIAlertAction!) in
            })
            alertController.addAction(noAction)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive , handler: { (action:UIAlertAction!) in
                self.momentImageView.image = UIImage(named: "addImage")
                self.selectedImage = nil
            })
            alertController.addAction(deleteAction)
            self.present(alertController, animated: true, completion:nil)
        }
    }
    
    @IBAction func shareFBAction(_ sender: UISwitch) {
        self.shareOnFB = sender.isOn
    }
    
    @IBAction func handleTapGesture(_ sender: AnyObject) {
        self.momentDetails.resignFirstResponder()
        self.momentTitle.resignFirstResponder()
    }
    
    @IBAction func handleCancel(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onMomentFinished(_ sender: UIButton) {
        if !addedDetails || momentTitle.text == nil || (momentTitle.text?.characters.count)! == 0 || momentDetails.text == nil || (momentDetails.text?.characters.count)! == 0  {
            let alertController = UIAlertController(title: "Error", message: "Please add title and details for your moment",  preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: { (action:UIAlertAction!) in
            })
            alertController.addAction(okAction)
            // Present Alert
            self.present(alertController, animated: true, completion:nil)
            return
        }

        //update image to storage
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.publishButton.isUserInteractionEnabled = false
        if selectedImage != nil {
            if let imageData = UIImagePNGRepresentation(selectedImage) as Data? {
                FireBaseManager.shared.uploadImage(data: imageData) { (folderAndFileName, imageUrl, error) in
                    if imageUrl != nil {
                        self.picsUrl = [imageUrl!]
                        self.momentImageView.setImageWith(URL(string: imageUrl!)!)
                        self.momentImageView.clipsToBounds = true
                        self.momentImageView.contentMode = .scaleAspectFill
                    }
                    self.submitData()
                }
            } else {
                self.submitData()
            }
        } else {
            self.submitData()
        }
    }
    
    func submitData() {
        let title = momentTitle.text!
        let details = momentDetails.text!
        self.moment = Moment(title: title, details: details, actId: self.actionId, userId: (User.currentUser?.id)!, profilePhotoUrl: User.currentUser?.profilePhotoUrl, userName: (User.currentUser?.name)!, timestamp: "\(Date())", picUrls: self.picsUrl, geoLocation: self.geoLocation, location: self.location)
    
        
        MainManager.shared.createMoment(actId: self.actionId, moment: self.moment, newMoment: isEditMode ? false : true){_ in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.publishButton.isUserInteractionEnabled = true
            if self.shareOnFB {
                var url:URL!
                if self.picsUrl != nil {
                    url = URL(string: (self.picsUrl?[0])!)
                } else {
                    let category = MainManager.shared.availableActs[self.actionId]?.category
                    let categoryObj = MainManager.shared.availableCategories.filter( { return $0.title == category } ).first
                    if let imageUrl = categoryObj?.imageUrl {
                        url = URL(string: imageUrl)
                    }
                }
                var content = LinkShareContent.init(url: url, title: title, description: details)
                content.quote = "I did it!"
                let shareDialog = ShareDialog(content: content)
                shareDialog.mode = .native
                shareDialog.failsOnInvalidData = true
                shareDialog.completion = { result in
                    // Handle share results
                    print (result)
                    if self.isEditMode {
                        _ = self.navigationController?.popViewController(animated: true)
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                try! shareDialog.show()
            } else {
                if self.isEditMode {
                    _ = self.navigationController?.popViewController(animated: true)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        }
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
    
    func keyboardWillShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset
    }
    
    
    func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }
}



//MARK:- Image Picker delegate
extension CreateMomentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        isTakingPic = true
        let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        guard let reducedSizeImage = originalImage?.resized(withPercentage: 0.3) else {return}
        selectedImage = reducedSizeImage
        self.momentImageView.alpha = 0
        self.momentImageView.clipsToBounds = true
        self.momentImageView.image = selectedImage
        self.momentImageView.contentMode = .scaleAspectFill
        self.momentImageView.setRoundedCorner(radius: 5)
        UIView.animate(withDuration: 0.3, animations: {
            self.momentImageView.alpha = 1
        })
        dismiss(animated: true, completion: nil)
    }
}


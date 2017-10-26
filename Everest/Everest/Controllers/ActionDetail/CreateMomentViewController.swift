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
        
        //mapView.delegate = self
        
        self.actionTitle.text = MainManager.shared.availableActs[action.id]?.title
        self.momentDetails.delegate = self
        self.momentTitle.delegate = self
        
        self.mapView.isUserInteractionEnabled = true
        self.momentImageView.isUserInteractionEnabled = true
        var tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(mapViewTapped))
        self.mapView.addGestureRecognizer(tapGesture1)
        tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(mapViewTapped))
        self.mapImageView.addGestureRecognizer(tapGesture1)
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
                self.geoLocation = nil
                self.mapImageView.isHidden = false
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
        vc.selectedMap = { (mapView: MKMapView, momentCoordinate: CLLocationCoordinate2D, location: String?) in
            self.momentCoordinate = momentCoordinate
            let region = MKCoordinateRegion(center: momentCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
            self.mapImageView.isHidden = true
            self.location = location
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
                self.momentImageView.image = UIImage(named: "addimage")
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
        self.moment = Moment(title: title, details: details, actId: self.action.id, userId: (User.currentUser?.id)!, profilePhotoUrl: User.currentUser?.profilePhotoUrl, userName: (User.currentUser?.name)!, timestamp: "\(Date())", picUrls: self.picsUrl, geoLocation: self.geoLocation, location: self.location)
    
        
        MainManager.shared.createMoment(actId: self.action.id, moment: self.moment, newMoment: true){_ in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.publishButton.isUserInteractionEnabled = true
            if self.shareOnFB {
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
            }
            self.dismiss(animated: true, completion: nil)
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
        self.momentImageView.image = selectedImage
        UIView.animate(withDuration: 0.3, animations: {
            self.momentImageView.alpha = 1
        })
        dismiss(animated: true, completion: nil)
    }
}


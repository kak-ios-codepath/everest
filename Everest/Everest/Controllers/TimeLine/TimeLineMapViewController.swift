//
//  TimeLineMapViewController.swift
//  Everest
//
//  Created by Kaushik on 10/25/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class TimeLineMapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var timelineMapView: MKMapView!
    
    var moments : [Moment]?
    var annotations : [MomentAnnotation] = []
    var navController : UINavigationController?
    let locationManager  = UserLocationManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.timelineMapView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(onUserLocation), name: NSNotification.Name(rawValue: "didReceiveUserLocation"), object: nil)
        locationManager.requestForUserLocation()

        let location = CLLocation(latitude: 37.5, longitude: -122	)
        let spanView = MKCoordinateSpanMake(3, 3)
        let region = MKCoordinateRegionMake(location.coordinate, spanView)
        timelineMapView.setRegion(region, animated: true)
    }
    
    func onUserLocation() -> Void {
        let locValue:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: locationManager.userLatitude!, longitude: locationManager.userLongitude!)
        let region = MKCoordinateRegionMakeWithDistance(locValue, 2000, 2000)
        self.timelineMapView.setRegion(region, animated: true)
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "didReceiveUserLocation"), object: nil)
        self.loadMapFor(moments: self.moments)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadMapFor(moments: [Moment]?) -> Void {
        self.timelineMapView.removeAnnotations(self.annotations)
        self.annotations = []
        self.moments = moments
        for moment in moments! {
            
            let annotation = MomentAnnotation()
             if (((moment.geoLocation?["lat"]) != nil) && ((moment.geoLocation?["lon"]) != nil)) {
                let lat = Double((moment.geoLocation?["lat"])!)
                let lon = Double((moment.geoLocation?["lon"])!)
                
                let coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
                annotation.coordinate = coordinate
                annotation.title = moment.title
                annotation.momentId = moment.id
                self.annotations.append(annotation)
            }
        }
        
        self.timelineMapView.addAnnotations(self.annotations)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if !(annotation is MKPointAnnotation) {
//            return nil
//        }
        
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: "myAnnotationView")
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myAnnotationView")
            view!.canShowCallout = true
            view!.rightCalloutAccessoryView = UIButton.init(type: .detailDisclosure) as UIView
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let index = (self.annotations as NSArray).index(of: view.annotation ?? 0)
        if index >= 0 {
            let momentAnnnotation = view.annotation as! MomentAnnotation
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let momentsDetailVC = storyboard.instantiateViewController(withIdentifier: "MomentsViewController") as! MomentsViewController
            momentsDetailVC.momentId = momentAnnnotation.momentId
            momentsDetailVC.isUserMomentDetail = false
            self.navController?.pushViewController(momentsDetailVC, animated: true)
        }
    }
    


}


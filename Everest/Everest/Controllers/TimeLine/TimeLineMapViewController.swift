//
//  TimeLineMapViewController.swift
//  Everest
//
//  Created by Kaushik on 10/25/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit
import MapKit
class TimeLineMapViewController: UIViewController, MKMapViewDelegate {
    var moments : [Moment]?
    var annotations : [MKPointAnnotation] = []
    var navController : UINavigationController?

    @IBOutlet weak var timelineMapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.timelineMapView.delegate = self

        // Do any additional setup after loading the view.
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
            let annotation = MKPointAnnotation()
            if (((moment.geoLocation?["lat"]) != nil) && ((moment.geoLocation?["lon"]) != nil)) {
                let lat = Double((moment.geoLocation?["lat"])!)
                let lon = Double((moment.geoLocation?["lon"])!)
                
                let coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
                annotation.coordinate = coordinate
                annotation.title = moment.title
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
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? MKPinAnnotationView
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            view!.canShowCallout = true
            view!.rightCalloutAccessoryView = UIButton.init(type: .detailDisclosure) as UIView
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let index = (self.annotations as NSArray).index(of: view.annotation ?? 0)
        if index >= 0 {
            //self.showDetailsForResult(self.results[index])
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let momentsDetailVC = storyboard.instantiateViewController(withIdentifier: "MomentsViewController") as! MomentsViewController
            momentsDetailVC.momentId = self.moments?[index].id
            momentsDetailVC.isUserMomentDetail = false
            self.navController?.pushViewController(momentsDetailVC, animated: true)
            
            
            
        }
    }
    


}

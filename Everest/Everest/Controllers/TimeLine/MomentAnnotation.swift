//
//  MomentAnnotation.swift
//  Everest
//
//  Created by Kaushik on 10/26/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit
import MapKit

class MomentAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var photo: UIImage!
    var momentId : String?
    var title: String?
}

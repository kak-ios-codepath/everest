//
//  SettingsViewController.swift
//  Everest
//
//  Created by Kavita Gaitonde on 10/13/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit
import SwiftyJSON


class SettingsViewController: UIViewController {
    var moment: Moment!
    var user: User!
    var action: Action!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        FireBaseManager.shared.fetchAvailableActs(category: "Empathy")
    
        
//// TEST CODE
        //login using email + creating a user in our data base
        //self.user = User(id: FireBaseManager.UID, providerId: "password", name: "Akrm Almsaodi", email: "r@b.com", phone: "22332112", profilePhotoUrl: "", isAnonymous: false, createdDate: "\(Date())", actions: nil, momentIds: nil, score: 10)
            
            //User(id: FireBaseManager.UID, name: "Akrm Almsaodi", email: "r@b.com", phone: "22332112", anonymous: false, createdDate: "\(Date())")
        //FireBaseManager.shared.updateUser(user: self.user)
        
        //self.action = Action();
        //creating an action property within the User data model
//        self.action = Action(id: "someIdAct", createdAt: "\(Date())", status: ActionStatus.inProgress.rawValue, likes: "someIdCategory")
//        FireBaseManager.shared.updateAction(action: self.action)
        
        //creating a new moment
        let picUrls = ["www.test.com\\pic1", "www.test.com\\pic2"]
        let geoLocation = ["lat": "12.33333", "lon": "233.333332"]
        self.moment = Moment(title: "what a great feeling", details: "When I started the act ...", actId: "123456", userId: FireBaseManager.UID, timestamp: "\(Date())", picUrls: picUrls, geoLocation: geoLocation, location: "some address")
        FireBaseManager.shared.updateMoment(moment: self.moment, newMoment: true)
 
//// END OF TEST CODE
        
        //get the moment timeline
        FireBaseManager.shared.getMomentsTimeLine(startAtMomentId: nil) { (moments, error) in
            if error == nil {
                //var timelineMoments = moments
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

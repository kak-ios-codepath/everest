//
//  SettingsViewController.swift
//  Everest
//
//  Created by Kavita Gaitonde on 10/13/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit
import SwiftyJSON
enum ActionStatus: String {
    case inProgress = "in progress"
    case completed = "completed"
}
class SettingsViewController: UIViewController {
    var moment: Moment!
    var user: User!
    var action: Action!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        FireBaseManager.shared.fetchAvailableActs(category: "Empathy")
      
        //register new user by email
        FireBaseManager.shared.registerNewUserWithEmail(name: "akrm", email: "r@b.com", password: "22332112") { (user, error) in
            let newUser = user
        }
        
        //login using email + creating a user in our data base
        FireBaseManager.shared.loginUserWithEmail(email: "r@b.com", password: "22332112") { (user, error) in
            if error == nil {
                self.user = User(id: FireBaseManager.UID, name: "Akrm Almsaodi", email: "r@b.com", phone: "22332112", anonymous: false, createdDate: "\(Date())")
                FireBaseManager.shared.updateUser(user: self.user)
                
                
                //creating an action property within the User data model
                self.action = Action(id: "someIdAct", createdAt: "\(Date())", status: ActionStatus.inProgress.rawValue)
                FireBaseManager.shared.updateAction(action: self.action)
                
                //creating a new moment
                let picUrls = ["www.test.com\\pic1", "www.test.com\\pic2"]
                let geoLocation = ["lat": "12.33333", "lon": "233.333332"]
                self.moment = Moment(title: "what a great feeling", details: "When I started the act ...", actId: self.action.id, userId: FireBaseManager.UID, timestamp: "\(Date())", picUrls: picUrls, geoLocation: geoLocation, location: "some address")
                FireBaseManager.shared.updateMoment(moment: self.moment, newMoment: true)
                
                
                //get the moment timeline
                FireBaseManager.shared.getMomentsTimeLine(startAtMomentId: nil) { (moments, error) in
                    if error == nil {
                        var timelineMoments = moments
                    }
                }
            }
        }
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

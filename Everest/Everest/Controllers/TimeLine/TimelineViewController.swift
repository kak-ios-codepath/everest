//
//  TimelineViewController.swift
//  Everest
//
//  Created by Kavita Gaitonde on 10/13/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MomentCellDelegate {

    //  MARK: -- outlets and properties
    @IBOutlet weak var timelineTableView: UITableView!
    
    private var timelineManager: TimeLineManager?
    private var moments : [Moment]?
    
    
    //  MARK: -- Initialization codes
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
        
    }

    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initialize()
    }
    
    
    func initialize() -> Void {
        
        timelineManager     = TimeLineManager.init()
        moments             = [Moment]()
    }
    
    
    
    //  MARK: -- View controller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "MomentCell", bundle: nil)
        self.timelineTableView.register(nib, forCellReuseIdentifier: "MomentCell")
        self.timelineTableView.estimatedRowHeight = self.timelineTableView.rowHeight
        self.timelineTableView.rowHeight = UITableViewAutomaticDimension

        self.timelineManager?.fetchUserDetails(completion: { (user:User?, error: Error?) in
            
        })
        
        self.timelineManager?.fetchPublicMomments(completion: { (moments:[Moment]?, error: Error?) in
            if((error) != nil) {
                
                // show the alert
                return
            }
            self.moments = moments
            // Reload the timelineView
            self.reloadView()
        })
        
//// -- TODO: Remove code after TESTING image uploads
//        guard let image = UIImage(named: "password") else { return }
//        //guard let imageData = UIImageJPEGRepresentation(image, 0.8) else { return }
//
//        FireBaseManager.shared.uploadImage(image: image) { (path, url, error) in
//            if url != nil {
//                print("Image path: \(path)")
//                print("Uploaded image to: \(url!)")
//                FireBaseManager.shared.downloadImage(path: path, completion: { (url, error) in
//                    if url != nil {
//                        print("Downloaded image to: \(url!)")
//                    } else {
//                        print("Error Uploading image ")
//                    }
//                })
//            } else {
//                print("Error Uploadding image ")
//            }
//        }
        
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: --  Update view
    private func reloadView() -> Void {
        self.timelineTableView.reloadData()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: -- Tableview data source and delegate methods
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MomentCell", for: indexPath) as! MomentCell
        if (self.moments?.count)!>0  {
            cell.momentCellDelegate = self
            cell.moment = self.moments?[indexPath.row]
        }
        return cell
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.moments?.count ?? 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let momentsDetailVC = storyboard.instantiateViewController(withIdentifier: "MomentsViewController") as! MomentsViewController
        momentsDetailVC.momentId = self.moments?[indexPath.row].id
        momentsDetailVC.isUserMomentDetail = false
        self.navigationController?.pushViewController(momentsDetailVC, animated: true)
        
    }
    
    // MARK: -- MomentCell delegate methods
    
    func momentCell(cell: MomentCell, didTapOnUserIconForMoment moment: Moment) {
        let userProfileStoryboard = UIStoryboard(name: "UserProfile", bundle: nil)
        let userProfileVC = userProfileStoryboard.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        //TODO: Add the user object property to the userprofile viewcontroller
        userProfileVC.userId = moment.userId
        self.navigationController?.pushViewController(userProfileVC, animated: true)
        
    }

}

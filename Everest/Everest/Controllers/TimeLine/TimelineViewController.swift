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
<<<<<<< HEAD
        
        //show login view
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let loginController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(loginController, animated: true) { 
            
        }
      
=======
                
>>>>>>> master
        let nib = UINib(nibName: "MomentCell", bundle: nil)
        self.timelineTableView.register(nib, forCellReuseIdentifier: "MomentCell")
        self.timelineTableView.estimatedRowHeight = self.timelineTableView.rowHeight
        self.timelineTableView.rowHeight = UITableViewAutomaticDimension

        
        
        self.timelineManager?.fetchPublicMomments(completion: { (moments:[Moment]?, error: Error?) in
            if((error) != nil) {
                
                // show the alert
                return
            }
            self.moments = moments
            // Reload the timelineView
            self.reloadView()
        })
        // Do any additional setup after loading the view.
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
        return 10
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let momentsDetailVC = storyboard.instantiateViewController(withIdentifier: "MomentsViewController")
        self.navigationController?.pushViewController(momentsDetailVC, animated: true)
        
    }
    
    // MARK: -- MomentCell delegate methods
    
    func momentCell(cell: MomentCell, didTapOnUserIconForMoment: Moment) {
        let userProfileStoryboard = UIStoryboard(name: "UserProfile", bundle: nil)
        let userProfileVC = userProfileStoryboard.instantiateViewController(withIdentifier: "UserProfileViewController")
        //TODO: Add the user object property to the userprofile viewcontroller
        self.navigationController?.pushViewController(userProfileVC, animated: true)
        
    }

}

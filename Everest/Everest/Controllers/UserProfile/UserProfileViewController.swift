//
//  UserProfileViewController.swift
//  Everest
//
//  Created by Kavita Gaitonde on 10/13/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit

enum ListType {
    case listTypeAccount
    case listTypeMoment
}

class UserProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var user: User?
    var userId : String?
    var currentListType : ListType = .listTypeAccount

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var actionsTableView: UITableView!
    @IBOutlet weak var momentsTableView: UITableView!
    @IBOutlet weak var noActionAndMomentsLabel: UILabel!
    
    private var userProfileManager: UserProfileManager?
    var actions : [Action]?
    var moments : [Moment]?

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
        userProfileManager     = UserProfileManager.init()
        actions = [Action]()
        moments = [Moment]()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if user == nil {
            user = User.currentUser
        }
        userId = user?.id
        
//        self.userProfileManager?.fetchAllActs()
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "ActionCreated"), object: nil, queue: OperationQueue.main, using: {(Notification) -> () in
            //TODO: go to user profile screen to show newly added actions.
            self.loadViewForSelectedMode()
        })
        
        let nib = UINib(nibName: "ActionCell", bundle: nil)
        self.actionsTableView.register(nib, forCellReuseIdentifier: "ActionCell")
        self.actionsTableView.estimatedRowHeight = self.actionsTableView.rowHeight
        self.actionsTableView.rowHeight = UITableViewAutomaticDimension
        
        let momentsNib = UINib(nibName: "MomentCell", bundle: nil)
        self.momentsTableView.register(momentsNib, forCellReuseIdentifier: "MomentCell")
        self.momentsTableView.estimatedRowHeight = self.momentsTableView.rowHeight
        self.momentsTableView.rowHeight = UITableViewAutomaticDimension


        nameLabel.text = user?.name
        dateLabel.text = "Joined on "+(user?.createdDate)!
        scoreLabel.text = "\(user?.score ?? 0)"
        if (user?.profilePhotoUrl != nil) {
            profileImageView.setImageWith(URL(string: (user?.profilePhotoUrl!)!)!)
        } else {
            profileImageView.image = nil
        }
        
        if userId != User.currentUser?.id {
            self.userProfileManager?.fetUserDetails(userId: self.userId!, completion: { (user: User?, error : Error?) in
                self.user = user
                self.loadViewForSelectedMode()

            })
        }else {
            self.user = User.currentUser
            self.loadViewForSelectedMode()
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func segmentControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.currentListType = ListType.listTypeAccount
        }
        else{
            self.currentListType = ListType.listTypeMoment
        }
        loadViewForSelectedMode()
    }
    
    func loadViewForSelectedMode(){
        
        
        self.nameLabel.text     = self.user?.name
        self.dateLabel.text     = "Joined on "+(self.user?.createdDate)!
        self.scoreLabel.text    = "\(self.user?.score ?? 0)"
        self.profileImageView.setImageWith(URL(string: (self.user?.profilePhotoUrl)!)!)
        
        if ((self.user?.actions == nil || self.user?.actions?.count == 0) && (self.user?.momentIds == nil || self.user?.momentIds?.count == 0)) {
            print("No Actions or Moments yet ");
            self.segmentedControl.isEnabled = false
            self.actionsTableView.isHidden = true
            self.momentsTableView.isHidden = true
            self.noActionAndMomentsLabel.isHidden = false
            return
        }else{
            self.segmentedControl.isEnabled = true
            self.noActionAndMomentsLabel.isHidden = true
        }
        
 
        if self.currentListType == .listTypeAccount {
            

            self.momentsTableView.isHidden = true
            self.actionsTableView.isHidden = false
            
            if (self.user?.actions?.count)! > 0  {
                self.actions = user?.actions
                self.actionsTableView.reloadData()
            }
            else {
                
            }
//            self.userProfileManager?.fetchUserActions(userId: (self.user?.id)!, completion: { (actions: [Action]?, error:Error?) in
//                if error != nil {
//                    // show alert
//                    return
//                }
//                
//                self.actions = actions
//                DispatchQueue.main.async {
//                }
//            })
            
        }else {
            
            self.momentsTableView.isHidden = false
            self.actionsTableView.isHidden = true
//            let nib = UINib(nibName: "MomentCell", bundle: nil)
//            self.actionsTableView.register(nib, forCellReuseIdentifier: "MomentCell")
//            self.actionsTableView.estimatedRowHeight = self.actionsTableView.rowHeight
//            self.actionsTableView.rowHeight = UITableViewAutomaticDimension
            self.userProfileManager?.fetchUserMomments(userId: (self.user?.id)!, completion: { (moments: [Moment]?, error: Error?) in
                
                if error != nil {
                    // show alert
                    return
                }
                self.moments = moments
                DispatchQueue.main.async {
                    self.momentsTableView.reloadData()
                }
            })
        }
    
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "createMomentViewController") {
            let cell = sender as! ActionCell
            if let indexPath = self.actionsTableView.indexPath(for: cell) {
                let vc = segue.destination as! CreateMomentViewController
                vc.action = self.actions?[indexPath.row]
                self.actionsTableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    
    // MARK: - Actions tableview delegate and datasource methods
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.currentListType == ListType.listTypeAccount {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActionCell", for: indexPath) as! ActionCell
            let id = self.actions?[indexPath.row].id
            cell.title.text = MainManager.shared.availableActs[id!]?.title
            cell.actionStatus.text = self.actions?[indexPath.row].status
            return cell
        }
        
        let momentCell = tableView.dequeueReusableCell(withIdentifier: "MomentCell", for: indexPath) as! MomentCell
        momentCell.moment = self.moments?[indexPath.row]
        
        return momentCell
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.currentListType == ListType.listTypeAccount {
            return (self.actions?.count)!
        }
        return (self.moments?.count)!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.currentListType == ListType.listTypeAccount {
            /*let storyBoard = UIStoryboard.init(name: "UserProfile", bundle: nil)
            let actionDetailVC = storyBoard.instantiateViewController(withIdentifier: "ActionViewController") as! CreateMomentViewController
            actionDetailVC.actId = self.actions?[indexPath.row].id
            self.navigationController?.pushViewController(actionDetailVC, animated: true)*/
            let cell = tableView.cellForRow(at: indexPath)
            self.performSegue(withIdentifier: "createMomentViewController", sender: cell)
        }
        
        if self.currentListType == ListType.listTypeMoment {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let momentsDetailVC = storyboard.instantiateViewController(withIdentifier: "MomentsViewController") as! MomentsViewController
            momentsDetailVC.momentId = self.moments?[indexPath.row].id
            momentsDetailVC.isUserMomentDetail = true
            self.navigationController?.pushViewController(momentsDetailVC, animated: true)
        }
        
        
    }

    @IBAction func logoutClicked(_ sender: Any) {
        LoginManager.shared.logoutUser { (error) in
            //TODO: Handle error
            self.dismiss(animated: true, completion: nil)
        }
    }
}

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


        //setup User related properties
        if userId == "" || userId == nil {
            userId = User.currentUser?.id
        }
        
        self.userProfileManager?.fetUserDetails(userId: self.userId!, completion: { (user: User?, error : Error?) in
            self.user = user
            self.nameLabel.text = self.user?.name
            self.dateLabel.text = "Joined on "+(self.user?.createdDate)!
            self.scoreLabel.text = "\(self.user?.score ?? 0)"

            self.loadViewForSelectedMode()
        })

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
        
        if self.currentListType == .listTypeAccount {
            

            self.momentsTableView.isHidden = true
            self.actionsTableView.isHidden = false
            
            self.userProfileManager?.fetchUserActions(userId: (self.user?.id)!, completion: { (actions: [Action]?, error:Error?) in
                if error != nil {
                    // show alert
                    return
                }
                self.actions = actions
                DispatchQueue.main.async {
                    self.actionsTableView.reloadData()
                }
            })
            
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Actions tableview delegate and datasource methods
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.currentListType == ListType.listTypeAccount {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActionCell", for: indexPath) as! ActionCell
            cell.title.text = self.actions?[indexPath.row].actTitle
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
            let storyBoard = UIStoryboard.init(name: "UserProfile", bundle: nil)
            let actionDetailVC = storyBoard.instantiateViewController(withIdentifier: "ActionViewController") as! CreateMomentViewController
            actionDetailVC.actId = self.actions?[indexPath.row].id
            self.navigationController?.pushViewController(actionDetailVC, animated: true)
        }
        
    }

    @IBAction func logoutClicked(_ sender: Any) {
        LoginManager.shared.logoutUser { (error) in
            //TODO: Handle error
            self.dismiss(animated: true, completion: nil)
        }
    }
}

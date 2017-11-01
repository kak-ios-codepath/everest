//
//  UserProfileViewController.swift
//  Everest
//
//  Created by Kavita Gaitonde on 10/13/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController{

    var user: User?
    var userId : String?
    var currentListType : Constants.ListType = .listTypeAccount

    @IBOutlet weak var nameLabel        : UILabel!
    @IBOutlet weak var dateLabel        : UILabel!
    @IBOutlet weak var scoreLabel       : UILabel!
    @IBOutlet weak var profileImageView : UIImageView!
    @IBOutlet weak var userActionTableView: UITableView!
    fileprivate var userProfileManager      : UserProfileManager?
    var actions : [Action]?

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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.userActionTableView.estimatedRowHeight = self.userActionTableView.rowHeight
        self.userActionTableView.rowHeight = UITableViewAutomaticDimension
        self.profileImageView.setRounded()

        if userId == nil || userId == "" {
            userId = User.currentUser?.id
        }
        
        
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "ActionCreated"), object: nil, queue: OperationQueue.main, using: {(Notification) -> () in
            //TODO: go to user profile screen to show newly added actions.
            
            self.user = User.currentUser
            self.loadViewForSelectedMode()
            
        })
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "MomentCreated"), object: nil, queue: OperationQueue.main, using: {(Notification) -> () in
            //TODO: go to user profile screen to show newly added actions.
            
            self.user = User.currentUser
            self.loadViewForSelectedMode()
            
        })

//        if userId != nil {
//            FireBaseManager.shared.fetchMomentsForUser (startAtMomentId: nil, userId: userId!, completion: { (moments: [Moment]?, error: Error?) in
//                if error != nil {
//                    print ("Error fetch moments for user")
//                } else {
//                    print ("Success moments for user")
//                }
//            })
//            
//            self.userProfileManager?.fetchUserDetails(userId: self.userId!, completion: { (user: User?, error : Error?) in
//                self.user = user
//                self.loadViewForSelectedMode()
//                
//            })
//        }else {
//            self.user = User.currentUser
//            self.loadViewForSelectedMode()
//        }
        
        if userId != User.currentUser?.id {
            self.userProfileManager?.fetchUserDetails(userId: self.userId!, completion: { (user: User?, error : Error?) in
                
                if user != nil {
                    self.user = user
                    self.loadViewForSelectedMode()
                }
            })
        }else {
            self.user = User.currentUser
            self.loadViewForSelectedMode()
        }
        

    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.94, green:0.71, blue:0.25, alpha:1.0)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   

    
    func loadViewForSelectedMode(){
        
        self.userProfileManager?.fetchAllMomentsForTheUser(user: self.user, completion: { (completed : Bool, error: Error?) in
            print("\(completed)")
            DispatchQueue.main.async {
                self.userActionTableView.reloadData()
            }

        })
        

        nameLabel.text = user?.name
        let date = UserProfileViewController.dateFromString(dateString: (user?.createdDate)!)
        let dateInString = UserProfileViewController.dateToString(createdDate: date as NSDate)
        dateLabel.text = "Joined on: "+dateInString

        scoreLabel.text = "Aura score: \(user?.score ?? 0)"
        if (user?.profilePhotoUrl != nil) {
            profileImageView.setImageWith(URL(string: (user?.profilePhotoUrl!)!)!)
            profileImageView.setNeedsDisplay()
        } else {
            profileImageView.image = UIImage(named: "Profile")
            profileImageView.setNeedsDisplay()
        }
    }

    
    
    // MARK: - Actions tableview delegate and datasource methods

    @IBAction func logoutClicked(_ sender: Any) {
        LoginManager.shared.logoutUser { (error) in
            //TODO: Handle error
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension UserProfileViewController: UITableViewDataSource, UITableViewDelegate, MomentCellDelegate, AddMomentCellDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserMomentCell", for: indexPath) as! UserMomentCell
        
        if self.userProfileManager?.actionsAndMomentsDataSource != nil && (self.userProfileManager?.actionsAndMomentsDataSource?.count)! > 0 {
            
            if let dictionary = self.userProfileManager?.actionsAndMomentsDataSource?[indexPath.section] {
                let key = Array(dictionary.keys)
                if let momentsArray = dictionary[key[0]] {
                    if indexPath.row == momentsArray.count {
                        let addMomentCell = tableView.dequeueReusableCell(withIdentifier: "AddMomentCell", for: indexPath) as! AddMomentCell
                        addMomentCell.addMomentCellDelegate = self
                        addMomentCell.selectedActId = key[0]
                        addMomentCell.addNewDescriptionLabel.text = "Write about new moment for this act."
                        addMomentCell.addMomentButton.setTitle("Add", for: .normal)
                        return addMomentCell
                    }
                    
                    let moment = momentsArray[indexPath.row]
                    cell.moment = moment
                    return cell
                }
            }
        }
        let addMomentCell = tableView.dequeueReusableCell(withIdentifier: "AddMomentCell", for: indexPath) as! AddMomentCell
        addMomentCell.addMomentCellDelegate = self
        addMomentCell.selectedActId = ""
        addMomentCell.addNewDescriptionLabel.text = "Subscribe to a new act."
        addMomentCell.addMomentButton.titleLabel?.text = "Add"
        return addMomentCell
    }
    
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.userProfileManager?.actionsAndMomentsDataSource != nil && (self.userProfileManager?.actionsAndMomentsDataSource?.count)! > 0 {
            if let dict = self.userProfileManager?.actionsAndMomentsDataSource?[section] {
                let  key = dict.keys.first
                if let momentsArray = dict[key!] {
                    if self.user?.id == User.currentUser?.id {
                        return momentsArray.count+1
                    } else {
                        return momentsArray.count
                    }
                }
            }
        } else if self.user?.id == User.currentUser?.id { //allow adding moments for logged user
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.userProfileManager?.actionsAndMomentsDataSource != nil && (self.userProfileManager?.actionsAndMomentsDataSource?.count)! > 0 {
            if let dictionary = self.userProfileManager?.actionsAndMomentsDataSource?[indexPath.section] {
                let key = Array(dictionary.keys)
                if let momentsArray = dictionary[key[0]] {
                    if momentsArray.count > 0  {
                        if indexPath.row == momentsArray.count {
                            return
                        }
                        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                        let momentsDetailVC = storyboard.instantiateViewController(withIdentifier: "MomentsViewController") as! MomentsViewController
                        momentsDetailVC.momentId = momentsArray[indexPath.row].id
                        self.navigationController?.pushViewController(momentsDetailVC, animated: true)
                    }
                }
            }
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let useractions = self.user?.actions {
            return useractions.count
        } else if self.user?.id == User.currentUser?.id { //allow adding actions for logged user
            return 1
        }
        return 0
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        
//
//        if let action = self.user?.actions?[section] {
//            let id = action.id
//            return MainManager.shared.availableActs[id]?.title
//        }
//        return "Add new action and start creating moments!!"
//    }
    

    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return 60
    }
    
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UITableViewHeaderFooterView()
//        let label = createHeaderLabel(section)
//        label.autoresizingMask = [.flexibleHeight]
//        headerView.addSubview(label)
//        return headerView
        
        let headerView = Bundle.main.loadNibNamed("ActionHeaderView", owner: self, options: nil)?.first as! ActionHeaderView
        
        if let action = self.user?.actions?[section] {
            headerView.action = action
        }
        else{
            headerView.action = nil
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16
    }
    
    func createHeaderLabel(_ section: Int)->UILabel {
        let widthPadding: CGFloat = 20.0
        let label: UILabel = UILabel(frame: CGRect(x: widthPadding, y: 0, width: self.userActionTableView.frame.width - widthPadding, height: 0))
        
        if let action = self.user?.actions?[section] {
        let id = action.id
        label.text = MainManager.shared.availableActs[id]?.title
        }
        else{
            label.text = "No subscribed actions."
        }
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignment.left
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline) //use your own font here - this font is for accessibility
        return label
    }

    
    func addMomentCell(cell: AddMomentCell, addNewMomentToAction action: String?) {
        
        if action == "" {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let addActionVC = storyboard.instantiateViewController(withIdentifier: "AddActionViewController") as! AddActionViewController
            
            self.present(addActionVC, animated: true, completion: { 
                
            })
            
        }else {
            let action = self.user?.actions?.filter( { return $0.id == action } ).first
            let storyboard = UIStoryboard.init(name: "UserProfile", bundle: nil)
            let addMomentVC = storyboard.instantiateViewController(withIdentifier: "CreateMomentViewController") as! CreateMomentViewController
            addMomentVC.actionId = action?.id
            self.present(addMomentVC, animated: true, completion: { 
                
            })
        }
        
    }
    
    class func dateToString(createdDate: NSDate) -> String {
        
        let formatter           = DateFormatter()
        formatter.dateFormat    = "M/d/yy"
        let dateInStr           = formatter.string(from: createdDate as Date)
        return dateInStr
        
        
    }
    
    class func dateFromString(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        // this is imporant - we set our input date format to match our input string
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        // voila!
        let dateFromString = dateFormatter.date(from: dateString)
        
        return dateFromString!
    }
    

}

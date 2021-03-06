//
//  MomentsViewController.swift
//  Everest
//
//  Created by Kavita Gaitonde on 10/13/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit

class MomentsViewController: UIViewController {
    
    
    var isUserMomentDetail : Bool = true
    //  MARK: -- outlets and properties
    @IBOutlet weak var momentDetailTableView: UITableView!
    
    fileprivate var momentDetailManager: MomentDetailManager?
    fileprivate var suggestedMomentList : [Moment]?
    var momentId : String?
    
    fileprivate var currentSelectedMoment : Moment?
        
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
        
        momentDetailManager = MomentDetailManager.init()
        suggestedMomentList = [Moment]()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Details"
        // Do any additional setup after loading the view.
        self.momentDetailTableView.estimatedRowHeight = 100
        self.momentDetailTableView.rowHeight = UITableViewAutomaticDimension
        
        self.momentDetailManager?.fetchDetailsOfTheMoment(momentId: self.momentId!, completion: { (moment: Moment?, error: Error?) in
            
            if (error != nil) {
                //show alert 
                return
            }
            self.currentSelectedMoment = moment
            
            DispatchQueue.main.async {
                self.momentDetailTableView.reloadSections(IndexSet(integer: 0), with: UITableViewRowAnimation.automatic)
            }
            
            if self.isUserMomentDetail == false {
                if let actId = moment?.actId {
                    self.momentDetailManager?.fetchSuggestedMoments(actId: actId, completion: { (moments:[Moment]?, error: Error?) in
                        if (error != nil) {
                            //show alert
                            return
                        }
                        
                        self.suggestedMomentList = moments
                        if let selectedMoment = self.suggestedMomentList?.filter( { return $0.id == self.currentSelectedMoment?.id } ).first {
                            let index = self.suggestedMomentList?.index(of: selectedMoment)
                            self.suggestedMomentList?.remove(at: index!)
                        }
                        DispatchQueue.main.async {
                            self.momentDetailTableView.reloadSections(IndexSet(integer: 1), with: UITableViewRowAnimation.automatic)
                        }
                    })
                }
            }

        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.83, green:0.14, blue:0.14, alpha:1.0)
//        self.navigationController?.navigationBar.isTranslucent = false
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MomentsViewController: UITableViewDelegate, UITableViewDataSource {
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MomentDetailCell", for: indexPath) as! MomentDetailCell
        
        
        if (indexPath.section == 0) {
            cell.moment = self.currentSelectedMoment
            if isUserMomentDetail {
                cell.cloneButton.isHidden = true
            } else {
                cell.cloneButton.isHidden = false
            }
        }
        else
        {
            if (self.suggestedMomentList?.count)!>0 {
                cell.moment = self.suggestedMomentList?[indexPath.row]
                cell.cloneButton.isHidden = true
            }
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            if self.currentSelectedMoment?.userId == User.currentUser?.id {
                //allow edit of moment
                let storyboard = UIStoryboard.init(name: "UserProfile", bundle: nil)
                let momentsDetailVC = storyboard.instantiateViewController(withIdentifier: "CreateMomentViewController") as! CreateMomentViewController
                momentsDetailVC.moment = self.currentSelectedMoment
                self.navigationController?.pushViewController(momentsDetailVC, animated: true)
            }
        }
        else
        {
            //DO nothing for suggesting moments?
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return (self.suggestedMomentList?.count)!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Similar Moments"
        }
        return ""
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.isUserMomentDetail == false {
            return 2
        }
        return 1
    }
    
}

//
//  TimelineViewController.swift
//  Everest
//
//  Created by Kavita Gaitonde on 10/13/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //  MARK: -- outlets and properties
    @IBOutlet weak var timelineTableView: UITableView!
    
    private var timelineManager: TimeLineManager?
    private var moments : [Moment]?
    
    
    //  MARK: -- Initialization codes
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
        initialize()
        
    }

    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super .init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initialize()
    }
    
    
    func initialize() -> Void {
        
        timelineManager     = TimeLineManager.init()
        moments             = [Moment]()
    }
    
    
    
    //  MARK: -- View controller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //show login view
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let loginController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(loginController, animated: true) { 
            
        }
        
        let nib = UINib(nibName: "MomentsCell", bundle: nil)
        self.timelineTableView.register(nib, forCellReuseIdentifier: "MomentsCell")
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MomentsCell", for: indexPath) as! MomentsCell
        if (self.moments?.count)!>0  {
            cell.moment = self.moments?[indexPath.row]
        }
        return cell
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    

}

//
//  MomentsViewController.swift
//  Everest
//
//  Created by Kavita Gaitonde on 10/13/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit

class MomentsViewController: UIViewController {
    
    //  MARK: -- outlets and properties
    @IBOutlet weak var momentDetailTableView: UITableView!
    
    fileprivate var momentDetailManager: MomentDetailManager?
    private var similarMomentsList : [Moment]?
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
        
        momentDetailManager             = MomentDetailManager.init()
        similarMomentsList              = [Moment]()
    }

    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.momentDetailManager?.fetchDetailsOfTheMoment(momentId: self.momentId!, completion: { (moment: Moment?, error: Error?) in
            
            if (error != nil) {
                //show alert 
                return
            }
            self.currentSelectedMoment = moment
            self.momentDetailTableView.reloadData()
        })
        
        
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

extension MomentsViewController: UITableViewDelegate, UITableViewDataSource {
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MomentDetailCell", for: indexPath) as! MomentDetailCell
        
        
        if (indexPath.section == 0) {
            cell.moment = self.currentSelectedMoment
        }
        
        return cell
    }

    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
}

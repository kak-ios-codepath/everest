//
//  UserProfileViewController.swift
//  Everest
//
//  Created by Kavita Gaitonde on 10/13/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {



    @IBOutlet weak var actionsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "ActionCell", bundle: nil)
        self.actionsTableView.register(nib, forCellReuseIdentifier: "ActionCell")
        self.actionsTableView.estimatedRowHeight = self.actionsTableView.rowHeight
        self.actionsTableView.rowHeight = UITableViewAutomaticDimension

        
        // Do any additional setup after loading the view.
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
    
    // MARK: - Actions tableview delegate and datasource methods
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActionCell", for: indexPath) as! ActionCell
        
        return cell
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard.init(name: "UserProfile", bundle: nil)
        let actionDetailVC = storyBoard.instantiateViewController(withIdentifier: "ActionViewController") as! CreateMomentViewController
        
        let cell = actionsTableView.cellForRow(at: indexPath) as! ActionCell
        actionDetailVC.actId = "AA7" //cell.action.id
        
        self.navigationController?.pushViewController(actionDetailVC, animated: true)
        
    }

    @IBAction func logoutClicked(_ sender: Any) {
        LoginManager.shared.logoutUser { (error) in
            //TODO: Handle error
            self.dismiss(animated: true, completion: nil)
        }
    }
}

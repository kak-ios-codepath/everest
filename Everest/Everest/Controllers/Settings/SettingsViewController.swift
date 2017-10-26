//
//  SettingsViewController.swift
//  Everest
//
//  Created by Kavita Gaitonde on 10/13/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit
import SwiftyJSON
import UserNotifications

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var notificationsTableView: UITableView!
    
    let notificationCenter = UNUserNotificationCenter.current()
    static var actionNotifications: [Act] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleingMessageNotification(_:)), name: NSNotification.Name(rawValue: "RemoteNotificationHandler"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationsTableView.delegate = self
        notificationsTableView.dataSource = self
        notificationsTableView.estimatedRowHeight = 100
        notificationsTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        notificationCenter.getDeliveredNotifications() { notifications in
            for notifcation in notifications {
                
            }
            
            //            self.notificationCenter.removeDeliveredNotifications(withIdentifiers: [])
        }
        notificationsTableView.reloadData()
    }
    
    @IBAction func onAddBtn(_ sender: UIButton) {
        MainManager.shared.createNewAction(id: SettingsViewController.actionNotifications[sender.tag].id, completion:{(error) in
            let alertController = UIAlertController(title: "Added", message: "You can view this newly added action in your Profile view.",  preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: { (action:UIAlertAction!) in
            })
            alertController.addAction(okAction)
            // Present Alert
            self.present(alertController, animated: true, completion:nil)
        })
        SettingsViewController.actionNotifications.remove(at: sender.tag)
        notificationsTableView.reloadData()
    }
    
    func handleingMessageNotification (_ notification: NSNotification) {
        if let actDect = notification.userInfo {
            SettingsViewController.actionNotifications.append(Act(id: actDect["id"] as! String, category: actDect["category"] as! String, title: actDect["title"] as! String, score: Int(actDect["score"] as! String)!) )
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as? NotificationCell else { return UITableViewCell() }
        
        cell.act = SettingsViewController.actionNotifications[indexPath.row]
        cell.addBtn.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsViewController.actionNotifications.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView()
        headerView.contentView.backgroundColor = UIColor.lightGray
        
        let switchView = UISwitch(frame: CGRect(x: notificationsTableView.frame.width-60, y: headerView.frame.midY, width: 0, height: 0))
//        switchView.addTarget(self, action: #selector(), for: UIControlEvents.valueChanged)
        
        headerView.addSubview(switchView)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Notify Me About New Actions"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

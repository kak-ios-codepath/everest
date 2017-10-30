//
//  SettingsViewController.swift
//  Everest
//
//  Created by Kavita Gaitonde on 10/13/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit
import SwiftyJSON

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var notificationsTableView: UITableView!
    
    static var actionNotifications: [Act] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationsTableView.delegate = self
        notificationsTableView.dataSource = self
        notificationsTableView.estimatedRowHeight = 100
        notificationsTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

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
        saveActionNotifications()
        notificationsTableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            SettingsViewController.actionNotifications.remove(at: indexPath.row)
            saveActionNotifications()
            notificationsTableView.reloadData()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: notificationsTableView.frame.width, height: notificationsTableView.frame.height/5))
        headerView.contentView.backgroundColor = UIColor.lightGray
        
        let switchView = UISwitch(frame: CGRect(x: notificationsTableView.frame.width-60, y: 10, width: 0, height: 0))
        switchView.isOn = true
        switchView.addTarget(self, action: #selector(togglePushNotifications(_:)), for: UIControlEvents.valueChanged)
        
        headerView.addSubview(switchView)
        return headerView
    }
    
    func togglePushNotifications(_ switchItem: UISwitch) {
        if switchItem.isOn {
            UIApplication.shared.registerForRemoteNotifications()
        } else {
            UIApplication.shared.unregisterForRemoteNotifications()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Notify Me About New Actions"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func saveActionNotifications() {
        let actionNotifications = NSKeyedArchiver.archivedData(withRootObject: SettingsViewController.actionNotifications)
        UserDefaults.standard.set(actionNotifications, forKey: "actionNotifications")
    }
}

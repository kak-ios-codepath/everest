//
//  WelcomeContentViewController.swift
//  Everest
//
//  Created by Kavita Gaitonde on 10/23/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit

class WelcomeContentViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var pageIndex: Int?
    var titleText : String!
    var imageName : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = UIImage(named: imageName)
        self.titleLabel.text = self.titleText
        self.titleLabel.alpha = 0.1
        UIView.animate(withDuration: 1.0, animations: { () -> Void in
            self.titleLabel.alpha = 1.0
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

//
//  ActionHeaderView.swift
//  Everest
//
//  Created by Kaushik on 10/29/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit

class ActionHeaderView: UIView {
    @IBOutlet weak var actionTitleLabel: UILabel!
    @IBOutlet weak var actionImageView: UIImageView!
    
    var action : Action? {
        didSet {
       if action == nil  {
      
           self.actionTitleLabel.text = "Add new action and start creating moments!!"
           return
       }
       if let id = action?.id {
           self.actionTitleLabel.text = MainManager.shared.availableActs[id]?.title
            let categoryTitle =  MainManager.shared.availableActs[id]?.category
            let categoryObj = MainManager.shared.availableCategories.filter( { return $0.title == categoryTitle } ).first
        if let imageUrl = categoryObj?.imageUrl {
            self.actionImageView.setImageWith(URL.init(string: imageUrl)!)
        }
       }
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    

//    func customInit(action: Action?) {
//        self.action = action
//        if let id = self.action?.id {
//            print("\(MainManager.shared.availableActs[id]?.title)")
//            self.textLabel?.text = MainManager.shared.availableActs[id]?.title
//        }
//    }
    
    
    override func awakeFromNib() {
        self.actionImageView.setRoundedCorner(radius: 5)
//        if action == nil  {
//            
//            self.actionTitleLabel.text = "Add new action and start creating moments!!"
//            return
//        }
//        if let id = action?.id {
//            print("\(MainManager.shared.availableActs[id]?.title)")
//            self.actionTitleLabel.text = MainManager.shared.availableActs[id]?.title
//        }
    }
}

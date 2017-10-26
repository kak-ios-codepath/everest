//
//  NotificationCell.swift
//  Everest
//
//  Created by user on 10/25/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var actLabel: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    
    var act:Act! {
        didSet {
            actLabel.text = act.title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  ActionCell.swift
//  Everest
//
//  Created by Kaushik on 10/15/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit

class ActionCell: UITableViewCell {

    @IBOutlet weak var actionStatus: UILabel!
    var action: Action!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

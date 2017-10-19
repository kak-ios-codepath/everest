//
//  actsCell.swift
//  Everest
//
//  Created by user on 10/18/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit

class ActsCell: UITableViewCell {

    @IBOutlet private weak var actLabel: UILabel!
    
    var actText: String! {
        didSet {
            actLabel.text = actText
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

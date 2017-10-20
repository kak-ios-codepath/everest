//
//  MomentDetailCell.swift
//  Everest
//
//  Created by Kaushik on 10/20/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit

class MomentDetailCell: UITableViewCell {

    var moment : Moment? {
        didSet {
            self.momentTitleLabel.text = moment?.title
            self.momentDescriptionLabel.text = moment?.details
            self.momentCreatedDateLabel.text = moment?.timestamp
        }
    }
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userProfileImaeView: UIImageView!
    @IBOutlet weak var momentCreatedDateLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var momentDescriptionLabel: UILabel!
    @IBOutlet weak var momentImageView: UIImageView!
    @IBOutlet weak var momentTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  UserMomentCell.swift
//  Everest
//
//  Created by Kaushik on 10/28/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit

class UserMomentCell: UITableViewCell {
    @IBOutlet weak var momentTitleLabel: UILabel!
    @IBOutlet weak var momentDescriptionLabel: UILabel!
    @IBOutlet weak var momentImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.momentImageView.setRoundedCorner(radius: 5)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var moment: Moment? {
        didSet {
            
            self.momentTitleLabel.text = moment?.title
            self.momentDescriptionLabel.text = moment?.details
            if let picUrls = moment?.picUrls {
                if let url = URL(string: picUrls[0]) {
                    self.momentImageView.setImageWith(url)
                } else {
                    self.momentImageView.image = UIImage(named: "Moment")
                }
            } else {
                self.momentImageView.image = UIImage(named: "Moment")
            }
        }
    }

    
    override func prepareForReuse() {
        self.momentImageView.image = nil
    }

}

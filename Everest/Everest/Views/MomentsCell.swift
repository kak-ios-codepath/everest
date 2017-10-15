//
//  MomentsCell.swift
//  Everest
//
//  Created by Kaushik on 10/14/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit

class MomentsCell: UITableViewCell {

    @IBOutlet weak var momentDescription: UILabel!
    @IBOutlet weak var momentTitleLabel: UILabel!
    @IBOutlet weak var momentImageVIew: UIImageView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    
    var moment: Moment? {
        didSet {
            self.momentDescription.text = moment?.description
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.userProfileImageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userIconTapped))
        self.userProfileImageView.addGestureRecognizer(tapGestureRecognizer)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @objc private func userIconTapped(_ sender: UITapGestureRecognizer) -> Void {
        
        // add moment cell delegate
        
    }
}

//
//  MomentsCell.swift
//  Everest
//
//  Created by Kaushik on 10/14/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit
@objc protocol MomentCellDelegate {
    @objc optional func momentCell(cell: MomentCell, didTapOnUserIconForMoment: Moment)
}

class MomentCell: UITableViewCell {

    @IBOutlet weak var momentDescription: UILabel!
    @IBOutlet weak var momentTitleLabel: UILabel!
    @IBOutlet weak var momentImageVIew: UIImageView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    
    weak var momentCellDelegate : MomentCellDelegate?

    
    var moment: Moment? {
        didSet {
            self.momentTitleLabel.text = moment?.title
            self.momentDescription.text = moment?.details
            if let picUrls = moment?.picUrls {
                if let url = URL(string: picUrls[0]) {
                    self.momentImageVIew.setImageWith(url)
                } else {
                    self.momentImageVIew.image = UIImage(named: "Moment")
                }
            } else {
                self.momentImageVIew.image = UIImage(named: "Moment")
            }
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
        
        if self.momentCellDelegate != nil {
            self.momentCellDelegate?.momentCell!(cell: self, didTapOnUserIconForMoment: self.moment!)
        }
        
    }
}

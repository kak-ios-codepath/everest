//
//  MomentsCell.swift
//  Everest
//
//  Created by Kaushik on 10/14/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit
import AFNetworking
@objc protocol MomentCellDelegate {
    @objc optional func momentCell(cell: MomentCell, didTapOnUserIconForMoment: Moment)
}

class MomentCell: UITableViewCell {

    @IBOutlet weak var momentDescription: UILabel!
    @IBOutlet weak var momentTitleLabel: UILabel!
    @IBOutlet weak var momentImageVIew: UIImageView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var locationPinImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    weak var momentCellDelegate : MomentCellDelegate?

    
    var moment: Moment? {
        didSet {
            
            self.momentTitleLabel.text = moment?.title
            self.momentDescription.text = moment?.details
//            if (moment?.location) != nil {
                self.locationLabel.text = moment?.location
//            }else {
//               self.locationLabel.isHidden = true
//                self.locationPinImageView.isHidden = true
//            }
            if let picUrls = moment?.picUrls {
                if let url = URL(string: picUrls[0]) {
                    self.momentImageVIew.setImageWith(url)
                } else {
                    self.momentImageVIew.image = UIImage(named: "Moment")
                }
            } else {
                self.momentImageVIew.image = UIImage(named: "Moment")
            }
            //TODO: Images r not being set
            if let profilePic = moment?.profilePhotoUrl {
                self.userProfileImageView.setImageWith(URL(string: profilePic)!)
            } else {
                self.userProfileImageView.image = UIImage(named: "Profile")
            }
            self.categoryLabel.text = (MainManager.shared.availableActs[(moment?.actId)!]?.category)?.capitalized
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.userProfileImageView.setRounded()
        self.userProfileImageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userIconTapped))
        self.userProfileImageView.addGestureRecognizer(tapGestureRecognizer)
        self.momentImageVIew.setRoundedCorner(radius: 5)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    override func prepareForReuse() {
        self.momentImageVIew.image = nil
        self.userProfileImageView.image = nil
    }
    
    
    @objc private func userIconTapped(_ sender: UITapGestureRecognizer) -> Void {
        
        // add moment cell delegate
        
        if self.momentCellDelegate != nil {
            self.momentCellDelegate?.momentCell!(cell: self, didTapOnUserIconForMoment: self.moment!)
        }
        
    }
}

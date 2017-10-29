//
//  MomentDetailCell.swift
//  Everest
//
//  Created by Kaushik on 10/20/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit

class MomentDetailCell: UITableViewCell {
    static let formatter = DateFormatter()
    static let friendlyDateformatter = DateFormatter()
    static let dateFormat = "yyyy-MM-dd HH:mm:ssZ"
    static let friendlyDateFormat = "d MMM YY h:mm a"
    
    @IBOutlet weak var momentLikeLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userProfileImaeView: UIImageView!
    @IBOutlet weak var momentCreatedDateLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var momentDescriptionLabel: UILabel!
    @IBOutlet weak var momentImageView: UIImageView!
    @IBOutlet weak var momentTitleLabel: UILabel!
    @IBOutlet weak var cloneButton: UIButton!
    @IBOutlet weak var actTitle: UILabel!
    @IBOutlet weak var momentLikeButton: UIButton!
    private var isLiked : Bool?
    
    
    var moment : Moment? {
        didSet {
            if moment == nil {
                return
            }
            self.momentTitleLabel.text = moment?.title
            self.momentDescriptionLabel.text = moment?.details
            if moment?.actId != nil {
                self.actTitle.text = MainManager.shared.availableActs[(moment?.actId)!]?.title
            }
            if moment?.timestamp != nil {
                let date = MomentDetailCell.formatter.date(from: (moment?.timestamp)!)
                self.momentCreatedDateLabel.text = MomentDetailCell.friendlyDateformatter.string(from: date!)
            } else {
                self.momentCreatedDateLabel.text = moment?.timestamp
            }
            if let picUrls = moment?.picUrls {
                if let url = URL(string: picUrls[0]) {
                    self.momentImageView.setImageWith(url)
                } else {
                    self.momentImageView.image = UIImage(named: "Moment")
                }
            } else {
                self.momentImageView.image = UIImage(named: "Moment")
            }
            
            if moment?.userId != nil {
                FireBaseManager.shared.getUser(userID: (moment?.userId)!) { (user:User?, error:Error?) in
                    if user != nil {
                        self.userNameLabel.text = user?.name
                        if (user?.profilePhotoUrl != nil) {
                            self.userProfileImaeView.setImageWith(URL(string: (user?.profilePhotoUrl!)!)!)
                        } else {
                            self.userProfileImaeView.image = UIImage(named: "Profile")
                        }
                    }
                }
            }
            self.cloneButton.isHidden = true
            self.categoryLabel.text = ((MainManager.shared.availableActs[(moment?.actId)!]?.category)?.capitalized)! + " action"
        }
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        MomentDetailCell.formatter.dateFormat = MomentDetailCell.dateFormat
        MomentDetailCell.friendlyDateformatter.dateFormat = MomentDetailCell.friendlyDateFormat
        self.isLiked = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func momentLikeAction(_ sender: Any) {
        var likeImage = UIImage.init(named: "Like")
        if isLiked == false {
            isLiked = true
            FireBaseManager.shared.updateMomentLikes(momentId: (self.moment?.id)!, incrementBy: 1)
            if let likesCount = Int(self.momentLikeLabel.text!) {
                self.momentLikeLabel.text = "\((likesCount)+1)"
                
            }
            
        }else{
            isLiked = false
            likeImage = UIImage.init(named: "like_bw")
            FireBaseManager.shared.updateMomentLikes(momentId: (self.moment?.id)!, incrementBy: -1)
            if let likesCount = Int(self.momentLikeLabel.text!) {
                self.momentLikeLabel.text = "\((likesCount)-1)"
            }
        }
        UIView.animate(withDuration: 0.6, animations: {
            self.momentLikeButton.transform = CGAffineTransform.identity.scaledBy(x: 0.6, y: 0.6)
        }, completion: { (finish) in
            UIView.animate(withDuration: 0.6, animations: {
                self.momentLikeButton.transform = CGAffineTransform.identity
                self.momentLikeButton.setImage(likeImage, for: .normal)
                
            })
        })
        
    }
    @IBAction func cloneAction(_ sender: AnyObject) {
        MainManager.shared.createNewAction(id: (moment?.actId)!, completion:{(error) in
            let alertController = UIAlertController(title: "Added", message: "You can view this newly added action in your Profile view.",  preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: { (action:UIAlertAction!) in
            })
            alertController.addAction(okAction)
            // Present Alert
            UIApplication.shared.delegate?.window??.rootViewController?.present(alertController, animated: true, completion: nil)
        })
    }


}

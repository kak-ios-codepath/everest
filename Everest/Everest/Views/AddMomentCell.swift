//
//  AddMomentCell.swift
//  Everest
//
//  Created by Kaushik on 10/25/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit
@objc protocol AddMomentCellDelegate {
    @objc optional func addMomentCell(cell: AddMomentCell, addNewMomentToAction: String?)
}
class AddMomentCell: UITableViewCell {

    weak var addMomentCellDelegate : AddMomentCellDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    var selectedActId: String?{
        didSet{
            
        }
    }
    @IBAction func addNewMomentToAct(_ sender: Any) {

            if self.addMomentCellDelegate != nil {
                self.addMomentCellDelegate?.addMomentCell!(cell: self, addNewMomentToAction: self.selectedActId)
            }
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

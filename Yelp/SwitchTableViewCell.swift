//
//  SwitchTableViewCell.swift
//  Yelp
//
//  Created by Lam Do on 11/21/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SwitchTableViewCellDelegate {
    optional func switchTableViewCell(SwitchTableViewCell: SwitchTableViewCell, didchangeValue value: Bool)
}

class SwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryFilterLabel: UILabel!
    @IBOutlet weak var categorySwitch: UISwitch!
    
    weak var delegate: SwitchTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        categorySwitch.addTarget(self, action: "onSwitchChange", forControlEvents: UIControlEvents.ValueChanged)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func onSwitchChange() {
        print("Switch value changed")
        delegate?.switchTableViewCell?(self, didchangeValue: categorySwitch.on)
    }

}

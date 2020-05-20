//
//  UserNotifyTableViewCell.swift
//  DriverRequest
//
//  Created by Apple on 8/14/18.
//  Copyright © 2018 Technosaab. All rights reserved.
//

import UIKit

class UserNotifyTableViewCell: UITableViewCell {
    @IBOutlet weak var titlename: UILabel!
    @IBOutlet weak var msgname: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

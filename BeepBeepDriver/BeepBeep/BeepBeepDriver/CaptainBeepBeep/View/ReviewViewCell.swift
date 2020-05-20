//
//  ReviewViewCell.swift
//  DriverRequest
//
//  Created by MacBook on 5/1/18.
//  Copyright © 2018 Technosaab. All rights reserved.
//

import UIKit
import Cosmos
class ReviewViewCell: UITableViewCell {

    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var rateCosmos: CosmosView!
    @IBOutlet weak var rateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

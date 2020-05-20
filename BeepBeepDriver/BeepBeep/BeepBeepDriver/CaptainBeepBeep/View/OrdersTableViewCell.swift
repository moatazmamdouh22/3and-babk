//
//  OrdersTableViewCell.swift
//  DriverRequest
//
//  Created by Apple on 8/13/18.
//  Copyright © 2018 Technosaab. All rights reserved.
//

import UIKit

class OrdersTableViewCell: UITableViewCell {

    @IBOutlet weak var couponnumber: UILabel!
    @IBOutlet weak var deliverad: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var ordertime: UILabel!
    @IBOutlet weak var delivarycost: UILabel!
    @IBOutlet weak var travelleddistance: UILabel!
    @IBOutlet weak var delivaryplace: UILabel!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var marketname: UILabel!
    @IBOutlet weak var ordernumber: UILabel!
    
    
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var marketName: UILabel!
    @IBOutlet weak var costOut: UILabel!
    @IBOutlet weak var deliveryPlace: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var deliveryCost: UILabel!
    @IBOutlet weak var orderTime: UILabel!
    @IBOutlet weak var dateOut: UILabel!
    @IBOutlet weak var delivery: UILabel!
    @IBOutlet weak var couponNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  FinancialrecordVC.swift
//  DriverRequest
//
//  Created by MacBook on 5/3/18.
//  Copyright © 2018 Technosaab. All rights reserved.
//

import UIKit

class FinancialrecordVC: UIViewController {

    @IBOutlet weak var totalcommission: UILabel!
    @IBOutlet weak var totaldelivery: UILabel!
    @IBOutlet weak var requestsnum: UILabel!
    @IBOutlet weak var remainingcredit: UILabel!
    @IBOutlet weak var currentcredit: UILabel!
    
    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet weak var currentCreditLabel: UILabel!
    @IBOutlet weak var remainingCreditLabel: UILabel!
    @IBOutlet weak var requestsNumber: UILabel!
    @IBOutlet weak var totalDeliveryAmounts: UILabel!
    @IBOutlet weak var totalCommission: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        creditLabel.text = "credit".localized
        currentCreditLabel.text = "currentcredit".localized
        remainingCreditLabel.text = "remainingcredit".localized
        requestsNumber.text = "requestsnumber".localized
        totalDeliveryAmounts.text = "deliveryAmounts".localized
        totalCommission.text = "totalcommision".localized
        
        WebServices.instance.DriverAmount { (data) in
            self.totaldelivery.text = "\(data)"

        }
        WebServices.instance.currentCredit { (fees) in
            self.currentcredit.text = "\(fees)"
            WebServices.instance.DriverFees { (Driverfees) in
                self.remainingcredit.text = "\(Driverfees - fees)"
            }
        }
        WebServices.instance.requestnumber { (number) in
            self.requestsnum.text = "\(number) Requests".localized
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

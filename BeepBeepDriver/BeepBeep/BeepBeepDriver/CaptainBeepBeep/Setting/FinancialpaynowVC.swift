//
//  FinancialpaynowVC.swift
//  DriverRequest
//
//  Created by Apple on 8/13/18.
//  Copyright © 2018 Technosaab. All rights reserved.
//

import UIKit
import PKHUD
class FinancialpaynowVC: UIViewController {

    @IBOutlet weak var creidtnumber: UITextField!
    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    let DriverID = UserDefaults.standard.value(forKey: "id") as! String

    override func viewDidLoad() {
        super.viewDidLoad()
        creditLabel.text = "crNo".localized
        sendBtn.setTitle("Send".localized, for: .normal)
        cancelBtn.setTitle("Cancel".localized, for: .normal)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func send(_ sender: Any) {
        if creidtnumber.text! == "" {
            HUD.flash(.labeledError(title: "Wrong".localized, subtitle: "Entercreditnumber".localized), delay: 2.0)
        }else{
        WebServices.instance.paynow(cardNum: creidtnumber.text!, id: DriverID) { (status, error) in
            if status {
                HUD.flash(.success, delay: 2.0)
                self.creidtnumber.text = ""
            }
        }
    }
}
    
    @IBAction func exit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

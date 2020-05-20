//
//  ChangenoVC.swift
//  DriverRequest
//
//  Created by MacBook on 4/18/18.
//  Copyright © 2018 Technosaab. All rights reserved.
//

import UIKit
import PKHUD
class ChangenoVC: UIViewController {
    
    
    @IBOutlet weak var changeNumberLabel: UILabel!
    @IBOutlet weak var oldnumber: UITextField!
    @IBOutlet weak var newmobile: UITextField!
    
    
    @IBOutlet weak var editOut: UIButton!
    @IBOutlet weak var exitOut: UIButton!
    
    let oldnum = UserDefaults.standard.value(forKey: "mobile") as! String
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeNumberLabel.text = "changeno".localized
        
        oldnumber.placeholder = "oldNumber".localized
        newmobile.attributedPlaceholder = NSAttributedString(string: "newNumber".localized,
                                                             attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        editOut.setTitle("edit".localized, for: .normal)
        exitOut.setTitle("exit".localized, for: .normal)
        
        self.oldnumber.text = oldnum
        oldnumber.isUserInteractionEnabled = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func changeMobile(_ sender: Any) {
        if (self.newmobile.text?.isEmpty)!{
            HUD.flash(.labeledError(title: "Wrong".localized, subtitle: "Enternewnumber".localized), delay: 2.0)
        }
        else{
            WebServices.instance.updateMobile(mobile: self.newmobile.text!, completion: { (status,error) in
                if status {
                    HUD.flash(.success, delay: 2.0)
                    self.navigationController?.popViewController(animated: true)
                }else if error == ""{
                    HUD.flash(.labeledError(title: "Wrong".localized, subtitle: "sorryismobileexsist".localized), delay: 2.0)
                }
            })
        }
    }
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelbtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

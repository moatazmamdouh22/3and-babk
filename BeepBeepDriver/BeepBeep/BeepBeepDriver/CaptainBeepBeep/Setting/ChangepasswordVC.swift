//
//  ChangepasswordVC.swift
//  DriverRequest
//
//  Created by MacBook on 4/25/18.
//  Copyright © 2018 Technosaab. All rights reserved.
//

import UIKit
import PKHUD
class ChangepasswordVC: UIViewController {

    @IBOutlet weak var changepassword: UILabel!
    @IBOutlet weak var oldpassword: UITextField!
    @IBOutlet weak var newpassword: UITextField!
    var oldpass = UserDefaults.standard.value(forKey: "password") as! String
    override func viewDidLoad() {
        super.viewDidLoad()
        changepassword.text = "changepassword".localized
        oldpassword.placeholder = "oldpass".localized
        newpassword.placeholder = "newpass".localized
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editpassword(_ sender: Any) {
        if (self.oldpassword.text?.isEmpty)!{
            HUD.flash(.labeledError(title: "Wrong".localized, subtitle: "Enteroldpassword".localized), delay: 2.0)
        }else if (self.newpassword.text?.isEmpty)!{
            HUD.flash(.labeledError(title: "Wrong".localized, subtitle: "Enternewpassword".localized), delay: 2.0)
            
        }else if self.oldpassword.text != oldpass {
            HUD.flash(.labeledError(title: "Wrong".localized, subtitle: "Besurethatoldpasswordberight".localized), delay: 2.0)
        }else{
            HUD.flash(.progress)
            WebServices.instance.updatePassword(password: newpassword.text!, completion: { (status) in
                if status{
                    HUD.flash(.success, delay: 2.0)
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

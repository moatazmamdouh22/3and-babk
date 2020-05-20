//
//  ChangemailVC.swift
//  DriverRequest
//
//  Created by MacBook on 4/25/18.
//  Copyright © 2018 Technosaab. All rights reserved.
//

import UIKit
import PKHUD
class ChangemailVC: UIViewController {
    
    @IBOutlet weak var emailadress: UILabel!
    let email = UserDefaults.standard.value(forKey: "email") as! String
    @IBOutlet weak var newemailaddress: UITextField!
    @IBOutlet weak var changeEmailLabel: UILabel!
    @IBOutlet weak var editOut: UIButton!
    @IBOutlet weak var exitOut: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailadress.text = email
        
        changeEmailLabel.text = "changemail".localized
        editOut.setTitle("edit".localized, for: .normal)
        exitOut.setTitle("exit".localized, for: .normal)
        
        newemailaddress.attributedPlaceholder = NSAttributedString(string: "newEmail".localized,
                                                             attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editbtn(_ sender: Any) {
        if (self.newemailaddress.text?.isEmpty)!{
            HUD.flash(.labeledError(title: "Wrong".localized, subtitle: "Enteremailaddress".localized), delay: 2.0)
        }else{
            WebServices.instance.updateEmail(email: self.newemailaddress.text!, completion: { (status,error) in
                if status {
                    HUD.flash(.success, delay: 2.0)
                    self.navigationController?.popViewController(animated: true)
                }else if error == ""{
                    HUD.flash(.labeledError(title: "Wrong".localized, subtitle: "sorryisemailexsist".localized), delay: 2.0)
                }
            })
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelbtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}

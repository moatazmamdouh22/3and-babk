//
//  LoginVC.swift
//  DriverRequest
//
//  Created by MacBook on 4/1/18.
//  Copyright © 2018 Technosaab. All rights reserved.
//

import UIKit
import PKHUD
class LoginVC: UIViewController {
    @IBOutlet weak var emailaddress: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func login(_ sender: Any) {
        if (self.emailaddress.text?.isEmpty)! {
			HUD.flash(.labeledError(title: "Wrong", subtitle: "Enter email"), delay: 2.0)
        }else if (self.password.text?.isEmpty)! {
			HUD.flash(.labeledError(title: "Wrong", subtitle: "Enter password"), delay: 2.0)
        }else {
			HUD.show(.progress)
            WebServices.instance.login(email: emailaddress.text!, password: password.text!, completion: { (status,error ) in
                if status {
                    HUD.flash(.success, delay: 2.0)
                    self.performSegue(withIdentifier: "home", sender: nil)
                }else if error == "" {
                    print("ERROR BACKEND")
                    HUD.flash(.labeledError(title: "Wrong", subtitle: "Authentication failed. User not found"), delay: 1.0)
                }
            })
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.setNavigationBarHidden(false, animated:true)
        self.navigationController?.navigationBar.tintColor = .gray
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

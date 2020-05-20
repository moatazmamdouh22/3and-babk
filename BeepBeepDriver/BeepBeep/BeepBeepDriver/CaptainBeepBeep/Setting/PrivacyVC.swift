//
//  PrivacyVC.swift
//  DriverRequest
//
//  Created by MacBook on 5/1/18.
//  Copyright © 2018 Technosaab. All rights reserved.
//

import UIKit

class PrivacyVC: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var mobile: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var privacyLabel: UILabel!
    
    @IBOutlet weak var emailOut: UILabel!
    @IBOutlet weak var hotlineOut: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mobile.text = APPPHONE
        email.text = APPEMAIL
        
        privacyLabel.text = "privacy".localized
        
        emailOut.text = "email".localized
        hotlineOut.text = "hotline".localized

        var text = ""
        for title in APPPRIVACY{
                text.append("\(String(describing: title.titleEN!))\n")
        }
        self.textView.text = text

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelbtn(_ sender: Any) {
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

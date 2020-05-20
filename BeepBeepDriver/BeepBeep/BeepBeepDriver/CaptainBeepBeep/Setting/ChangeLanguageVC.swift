//
//  ChangeLanguageVC.swift
//  DriverRequest
//
//  Created by MacBook on 5/23/18.
//  Copyright © 2018 Technosaab. All rights reserved.
//

import UIKit

class ChangeLanguageVC: UIViewController {

    @IBOutlet weak var changeLanguageLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeLanguageLabel.text = "changelang".localized

        // Do any additional setup after loading the view.
    }
    @IBAction func Change(_ sender: Any) {
        if (sender as AnyObject).tag == 1 {
            LanguageManger().changeToLanguage("ar", self)
        }else{
            LanguageManger().changeToLanguage("en", self)
        }
        
    }
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelbtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

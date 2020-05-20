//
//  SplachVC.swift
//  DriverRequest
//
//  Created by MacBook on 4/16/18.
//  Copyright © 2018 Technosaab. All rights reserved.
//

import UIKit
var SAVEDORDER = Order()
class SplachVC: UIViewController {
    let UserID = UserDefaults.standard.value(forKey: "id")
    override func viewDidLoad() {
        super.viewDidLoad()
        perform(#selector(SplachVC.startup), with: nil, afterDelay: 5)
        WebServices.instance.getCountry()
        WebServices.instance.getModels()
        WebServices.instance.getAbout()
        WebServices.instance.getPrivacy()
        WebServices.instance.getTerms()
        WebServices.instance.getAppEmail()
        WebServices.instance.getAppPhone()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func startup(){
        // check if user first time
        //check if user is login
        // segue to home
        
        if UserID == nil {
            self.performSegue(withIdentifier: "login", sender: nil)
        }else{
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "HomeNC")
            self .present(controller!, animated: true, completion: nil)
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

}

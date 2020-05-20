//
//  SettingVC.swift
//  DriverRequest
//
//  Created by MacBook on 4/19/18.
//  Copyright © 2018 Technosaab. All rights reserved.
//

import UIKit

class SettingVC: BaseViewController {

    @IBOutlet weak var changeno: UIButton!
    @IBOutlet weak var drivername: UILabel!
    
    @IBOutlet weak var changemail: UIButton!
    @IBOutlet weak var changecountry: UIButton!
    
    @IBOutlet weak var changepass: UIButton!
    
    @IBOutlet weak var clickhere: UIButton!
    @IBOutlet weak var discountcoup: UIButton!
    
    @IBOutlet weak var changelang: UIButton!
    @IBOutlet weak var aboutrequest: UIButton!
    
    @IBOutlet weak var customerservice: UIButton!
    
    @IBOutlet weak var logout: UIButton!
    @IBOutlet weak var share: UIButton!
    @IBOutlet weak var termsandconditions: UIButton!
    @IBOutlet weak var privacy: UIButton!
    @IBOutlet weak var howtowork: UIButton!
    @IBOutlet weak var reviews: UIButton!
    @IBOutlet weak var financialrecords: UIButton!
    @IBOutlet weak var myrequests: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeno.setTitle("changeno".localized, for: .normal)
        changemail.setTitle("changemail".localized, for: .normal)
        changecountry.setTitle("changecountry".localized, for: .normal)
        changepass.setTitle("changepass".localized, for: .normal)
        discountcoup.setTitle("discountcoup".localized, for: .normal)
        changelang.setTitle("changelang".localized, for: .normal)
        aboutrequest.setTitle("aboutrequest".localized, for: .normal)
        
        clickhere.setTitle("clickhere".localized, for: .normal)
        customerservice.setTitle("customerservice".localized, for: .normal)
        logout.setTitle("logout".localized, for: .normal)
        share.setTitle("share".localized, for: .normal)
        termsandconditions.setTitle("termsandconditions".localized, for: .normal)
        privacy.setTitle("privacy".localized, for: .normal)
        howtowork.setTitle("howtowork".localized, for: .normal)
          reviews.setTitle("reviews".localized, for: .normal)
        financialrecords.setTitle("financialrecords".localized, for: .normal)
        myrequests.setTitle("myrequests".localized, for: .normal)

        drivername.text = UserDefaults.standard.value(forKey: "fullname") as? String
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func signOut(_ sender: Any) {
		let actionsheet = UIAlertController(title: "logout".localized, message: "logoutmessage".localized, preferredStyle: .actionSheet)
		actionsheet.addAction(UIAlertAction(title: "logout".localized, style: .default, handler: { (action:UIAlertAction) in
			UserDefaults.standard.removeObject(forKey: "id")
			let controller = self.storyboard?.instantiateViewController(withIdentifier: "login")
			self .present(controller!, animated: true, completion: nil)
		}))
		actionsheet.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
		self.present(actionsheet, animated: true, completion: nil)

    }
    @IBAction func share(_ sender: Any) {
         shareApp(link: "www.google.com", controller: self )
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

//
//  AlertVC.swift
//  DriverRequest
//
//  Created by Apple on 6/20/18.
//  Copyright © 2018 Technosaab. All rights reserved.
//

import UIKit

class AlertVC: UIViewController {
    
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var alertMessage: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertMessage.text = "orderask".localized
        okBtn.setTitle("done".localized, for: .normal)
        cancelBtn.setTitle("Cancel".localized, for: .normal)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func okbtn(_ sender: Any) {
        MySocket.instance.socket.emit("itemReady")
        var x = true
        UserDefaults.standard.set(x, forKey: "x")
        self.performSegue(withIdentifier: "show", sender: nil)
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

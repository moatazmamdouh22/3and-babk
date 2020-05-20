//
//  FiniancialsecondViewController.swift
//  DriverRequest
//
//  Created by Apple on 8/13/18.
//  Copyright © 2018 Technosaab. All rights reserved.
//

import UIKit

class FiniancialsecondViewController: UIViewController {

    @IBOutlet weak var contentLabel: UITextView!
    @IBOutlet weak var payNowBtn: UIButton!
    @IBOutlet weak var bankBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        payNowBtn.setTitle("pay".localized, for: .normal)
        bankBtn.setTitle("bank".localized, for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func exit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}

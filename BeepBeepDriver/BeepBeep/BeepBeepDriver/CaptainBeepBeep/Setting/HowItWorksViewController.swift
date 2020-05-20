//
//  HowItWorksViewController.swift
//  CaptainBeepBeep
//
//  Created by Apple on 11/1/18.
//  Copyright © 2018 Technosaab. All rights reserved.
//

import UIKit
import PKHUD
class HowItWorksViewController: UIViewController, UIWebViewDelegate{
    @IBOutlet weak var WebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        WebView.delegate = self
        HUD.show(.progress)
        WebServices.instance.HowItWorks { (video, error) in
            HUD.hide()
            if let url = URL(string: video) {
                let request = URLRequest(url: url)
                self.WebView.loadRequest(request)
            }
        }
        // Do any additional setup after loading the view.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

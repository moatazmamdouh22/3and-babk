//
//  BaseViewController.swift
//  DriverRequest
//
//  Created by MacBook on 4/22/18.
//  Copyright © 2018 Technosaab. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func addNavBarImage() {
        let navController = UINavigationController()
        let image = #imageLiteral(resourceName: "logo 2-40")
        let imageView = UIImageView(image: image)
        let bannerWidth = navController.navigationBar.frame.size.width - 6
        let bannerHeight = navController.navigationBar.frame.size.height - 6
        imageView.center = navController.navigationBar.center
        imageView.frame.size = CGSize(width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
    func setRightTitle(title: String)  {
        let longTitleLabel = UILabel()
        longTitleLabel.text = title
        longTitleLabel.sizeToFit()
        longTitleLabel.textColor = .white
        let rightItem = UIBarButtonItem(customView: longTitleLabel)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


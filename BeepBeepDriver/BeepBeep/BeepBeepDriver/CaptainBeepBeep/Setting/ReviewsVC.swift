//
//  ReviewsVC.swift
//  DriverRequest
//
//  Created by MacBook on 5/1/18.
//  Copyright © 2018 Technosaab. All rights reserved.
//

import UIKit
import Cosmos
import PKHUD
class ReviewsVC: BaseViewController,UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var reviewArray :[Reviews] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        HUD.show(.progress)
        WebServices.instance.saidAboutDriver(completion: { (array) in
            
            HUD.hide()
            self.reviewArray = array
            self.tableView.reloadData()
            
            if self.reviewArray.count == 0 {
				AlertHandler().displayMyAlertMessage(message: "ThierisnoReviews".localized, title: "Attention".localized, okTitle: "ok".localized, view: self)
            }
        })
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ReviewViewCell
        cell.rateCosmos.rating = self.reviewArray[indexPath.row].rate!
        cell.rateLabel.text = "\(self.reviewArray[indexPath.row].rate!)"
        cell.comment.text = self.reviewArray[indexPath.row].userComment
        return cell
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

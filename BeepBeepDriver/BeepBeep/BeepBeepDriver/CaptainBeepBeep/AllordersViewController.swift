//
//  AllordersViewController.swift
//  DriverRequest
//
//  Created by Apple on 8/13/18.
//  Copyright © 2018 Technosaab. All rights reserved.
//

import UIKit
import PKHUD
class AllordersViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    var allorders : [Orders] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.separatorStyle = .none

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allorders.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrdersTableViewCell
        let Notify = self.allorders[indexPath.row]
        cell.marketname.text = Notify.marketName
        cell.delivarycost.text = Notify.fees
        cell.cost.text = Notify.cost
        cell.ordernumber.text = Notify._id
        cell.travelleddistance.text = Notify.distance
        
        cell.orderNumber.text = "ordernumber".localized
        cell.marketName.text = "marketlabel".localized
        cell.costOut.text = "cost".localized
        cell.deliveryPlace.text = "delivaryplace".localized
        cell.deliveryPlace.text = "travelleddistance".localized
        cell.deliveryCost.text = "delivarycost"
        cell.orderTime.text = "ordertime".localized
        cell.dateOut.text = "orderdate".localized
        cell.couponNumber.text = "Couponnumber".localized
        cell.distance.text = "travelleddistance".localized
        
        
        
        if let myDate = Notify.createdAt {
           
            let c = myDate.characters
            let space = c.index(of:"T")
            let newlink1 = myDate[c.index(after: space!)..<myDate.endIndex]
            let timelink = (newlink1 as? NSString)?.substring(to: 5)
            cell.ordertime.text = "\(timelink!)"
        }
        if let myDate = Notify.createdAt {
            let newString = (myDate as? NSString)?.substring(to: 10)
            cell.date.text = newString
        }
                return cell
    }
    override func viewWillAppear(_ animated: Bool) {
       HUD.show(.progress)
        WebServices.instance.allfuckinOrders( completion: { (data) in
            HUD.hide()
            self.allorders = data
            self.tableview.reloadData()
            if self.allorders.count == 0{
                AlertHandler().displayMyAlertMessage(message: "Theirisnoorders".localized, title: "Attention".localized, okTitle: "ok".localized, view: self)
                
            }
            else if self.allorders.count != 0{
                self.tableview.reloadData()
            }
            print(self.allorders.count)
        })
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

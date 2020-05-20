
//
//  GenerateBillVC.swift
//  DriverRequest
//
//  Created by MacBook on 5/13/18.
//  Copyright © 2018 Technosaab. All rights reserved.
//

import UIKit
import PKHUD
import Alamofire
class GenerateBillVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    @IBOutlet weak var clientBillLabel: UILabel!
    @IBOutlet weak var orderCostLabel: UILabel!
    @IBOutlet weak var deliveryCostLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var uploadImage: UIButton!
    
    let cost = UserDefaults.standard.value(forKey: "Cost") as! String
    let orderCost = UserDefaults.standard.value(forKey: "orderCost") as! String
    
    @IBOutlet weak var ordercost: UITextField!
    @IBOutlet weak var delivarycost: UILabel!
    @IBOutlet weak var totalcost: UILabel!
    
    var billcheck = false
    var imgpath = ""
    var check = 0
    var totalfinal = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clientBillLabel.text = "clientbill".localized
        orderCostLabel.text = "ordercost".localized
        deliveryCostLabel.text = "delivarycost".localized
        totalCostLabel.text = "total".localized
        sendBtn.setTitle("Send".localized, for: .normal)
        
        uploadImage.setTitle("up".localized, for: .normal)
        
        delivarycost.text = cost
        
        ordercost.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        MySocket.instance.connect()
        // Do any additional setup after loading the view.
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
        if(ordercost.text == "" && delivarycost.text == "" ){
            ordercost.text = "0"
            delivarycost.text = "0"
            totalcost.text = "0"
        }
        else {
            if(ordercost.text == ""){
                ordercost.text = "0"
            }
            else {
                let order = Int(ordercost.text!)
                let delivery = Int(cost)
                let final = order! + delivery!
                self.totalcost.text = String(final)
                self.totalfinal = final
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.delivarycost.text = cost
//        self.ordercost.text = orderCost
//        self.totalcost.text = "\(ordercost.text! + delivarycost.text!)"
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func send(_ sender: Any) {
    MySocket.instance.socket.emit("sentReceipt",imgpath,ordercost.text!,delivarycost.text!,totalfinal,"")
        HUD.flash(.success ,delay:2.0)
        self.check = 2
        UserDefaults.standard.set(2, forKey: "2")
        
        self.billcheck = true
        UserDefaults.standard.set(self.billcheck, forKey: "true")
        
        print("generate bill",check)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func selestPhoto(_ sender: Any) {
        let imagepickercontroller = UIImagePickerController()
        imagepickercontroller.delegate = self
        let actionsheet = UIAlertController(title: "Photolibrary".localized, message: "", preferredStyle: .actionSheet)
        actionsheet.addAction(UIAlertAction(title: "Photolibrary".localized, style: .default, handler: { (action:UIAlertAction) in
            imagepickercontroller.sourceType = .photoLibrary
            self.present(imagepickercontroller, animated: true, completion: nil)
        }))
        actionsheet.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        self.present(actionsheet, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        WebServices.instance.uploadImage(image: image) { (path) in
            if let urlPath = path{
                HUD.flash(.success, delay: 2.0)
                let messeagePhoto = URL(string:"\(urlPath)")!
                self.imgpath = path!
                print("Message",messeagePhoto)
            }
        }
        self.dismiss(animated: true, completion: nil)
        HUD.show(.progress)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        self.dismiss(animated: true, completion: nil)
    }
}

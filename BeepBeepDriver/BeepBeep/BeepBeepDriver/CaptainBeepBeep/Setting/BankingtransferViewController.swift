//
//  BankingtransferViewController.swift
//  DriverRequest
//
//  Created by Apple on 8/13/18.
//  Copyright © 2018 Technosaab. All rights reserved.
//

import UIKit
import PKHUD

class BankingtransferViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var notes: UITextField!
    @IBOutlet weak var value: UITextField!
    @IBOutlet weak var accountnumber: UITextField!
    @IBOutlet weak var bankname: UITextField!
    
    @IBOutlet weak var uploadBtn: UIButton!
    
    @IBOutlet weak var bankLabel: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    
    let SenderID = UserDefaults.standard.value(forKey: "id") as! String
    var logopath = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bankLabel.text = "bank".localized
        bankname.placeholder = "nameBank".localized
        accountnumber.placeholder = "acc".localized
        value.placeholder = "val".localized
        uploadBtn.setTitle("Uploadimage".localized, for: .normal)
        notes.placeholder = "Enternotes".localized
        submitBtn.setTitle("submit".localized, for: .normal)

        // Do any additional setup after loading the view.
    }

    @IBAction func uploadimage(_ sender: Any) {
        let imagepickercontroller = UIImagePickerController()
        imagepickercontroller.delegate = self
        let actionsheet = UIAlertController(title: "PhotoOrCamera".localized, message: "ChooseASource".localized, preferredStyle: .actionSheet)
        actionsheet.addAction(UIAlertAction(title: "Camera".localized, style: .default, handler: { (action:UIAlertAction) in
            imagepickercontroller.sourceType = .camera
            self.present(imagepickercontroller, animated: true, completion: nil)
            
        }))
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
                let messeagePhoto = URL(string:"\(urlPath)")!
                self.logopath = path!
                print("Message",messeagePhoto)
                HUD.flash(.success, delay: 2.0)
            }
        }
        self.dismiss(animated: true, completion: nil)
        HUD.show(.progress)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func send(_ sender: Any) {
        if bankname.text! == "" {
            HUD.flash(.labeledError(title: "Wrong".localized, subtitle: "Enterbankname".localized), delay: 2.0)
        }else if accountnumber.text! == "" {
            HUD.flash(.labeledError(title: "Wrong".localized, subtitle: "Enteraccountnumber".localized), delay: 2.0)
        }else if value.text! == "" {
            HUD.flash(.labeledError(title: "Wrong".localized, subtitle: "Entervalue".localized), delay: 2.0)
        }else if value.text! == "" {
            HUD.flash(.labeledError(title: "Wrong".localized, subtitle: "Enternotes".localized), delay: 2.0)
        }else if logopath == "" {
            HUD.flash(.labeledError(title: "Wrong".localized, subtitle: "Uploadimage".localized), delay: 2.0)
        }else{
            WebServices.instance.bankingtransfer(imgPath: logopath, bankName: bankname.text!, value: value.text!, accountNumber: accountnumber.text!, description: notes.text!, userID: SenderID) { (status,error ) in
                if status{
                    HUD.flash(.success, delay: 2.0)
                    self.bankname.text = ""
                    self.value.text = ""
                    self.accountnumber.text = ""
                    self.notes.text = ""
                    self.logopath = ""
                }
            }
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

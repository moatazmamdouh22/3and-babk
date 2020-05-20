//
//  ImageUploadVC.swift
//  DriverRequest
//l
//  Created by MacBook on 4/17/18.
//  Copyright © 2018 Technosaab. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD
import SwiftyJSON
class ImageUploadVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var creditOutlet: UIButton!
    
    
    var params2:[String : Any] = [:]
    var Image_Links = [String](arrayLiteral: "","","","","","")
    var Selector : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        print(params2)
        
        creditOutlet.setTitle("credit".localized, for: .normal)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func imageone(_ sender: Any) {
        Selector = 0
        let imagepickercontroller = UIImagePickerController()
        imagepickercontroller.delegate = self
        let actionsheet = UIAlertController(title: "PhotoOrCamera", message: "ChooseASource", preferredStyle: .actionSheet)
        actionsheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            imagepickercontroller.sourceType = .camera
            self.present(imagepickercontroller, animated: true, completion: nil)
            
        }))
        actionsheet.addAction(UIAlertAction(title: "Photolibrary", style: .default, handler: { (action:UIAlertAction) in
            imagepickercontroller.sourceType = .photoLibrary
            self.present(imagepickercontroller, animated: true, completion: nil)
        }))
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionsheet, animated: true, completion: nil)
    }
    @IBAction func imagetwo(_ sender: Any) {
        Selector = 1
        let imagepickercontroller = UIImagePickerController()
        imagepickercontroller.delegate = self
        let actionsheet = UIAlertController(title: "MaxiumumPicturestoupload", message: "ChooseASource", preferredStyle: .actionSheet)
        actionsheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            imagepickercontroller.sourceType = .camera
            self.present(imagepickercontroller, animated: true, completion: nil)
        }))
        actionsheet.addAction(UIAlertAction(title: "Photolibrary", style: .default, handler: { (action:UIAlertAction) in
            imagepickercontroller.sourceType = .photoLibrary
            self.present(imagepickercontroller, animated: true, completion: nil)
            
        }))
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionsheet, animated: true, completion: nil)
        

    }
    @IBAction func imagethree(_ sender: Any) {
        Selector = 2

        let imagepickercontroller = UIImagePickerController()
        imagepickercontroller.delegate = self
        let actionsheet = UIAlertController(title: "MaxiumumPicturestoupload", message: "ChooseASource", preferredStyle: .actionSheet)
        actionsheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            imagepickercontroller.sourceType = .camera
            self.present(imagepickercontroller, animated: true, completion: nil)
        }))
        actionsheet.addAction(UIAlertAction(title: "Photolibrary", style: .default, handler: { (action:UIAlertAction) in
            imagepickercontroller.sourceType = .photoLibrary
            self.present(imagepickercontroller, animated: true, completion: nil)
            
        }))
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionsheet, animated: true, completion: nil)
        

    }
    
    @IBAction func imagefour(_ sender: Any) {
        Selector = 3

        let imagepickercontroller = UIImagePickerController()
        imagepickercontroller.delegate = self
        let actionsheet = UIAlertController(title: "MaxiumumPicturestoupload", message: "ChooseASource", preferredStyle: .actionSheet)
        actionsheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            imagepickercontroller.sourceType = .camera
            self.present(imagepickercontroller, animated: true, completion: nil)
        }))
        actionsheet.addAction(UIAlertAction(title: "Photolibrary", style: .default, handler: { (action:UIAlertAction) in
            imagepickercontroller.sourceType = .photoLibrary
            self.present(imagepickercontroller, animated: true, completion: nil)
            
        }))
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionsheet, animated: true, completion: nil)
        
    }
    @IBAction func imagefive(_ sender: Any) {
        Selector = 4

        let imagepickercontroller = UIImagePickerController()
        imagepickercontroller.delegate = self
        let actionsheet = UIAlertController(title: "MaxiumumPicturestoupload", message: "ChooseASource", preferredStyle: .actionSheet)
        actionsheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            imagepickercontroller.sourceType = .camera
            self.present(imagepickercontroller, animated: true, completion: nil)
        }))
        actionsheet.addAction(UIAlertAction(title: "Photolibrary", style: .default, handler: { (action:UIAlertAction) in
            imagepickercontroller.sourceType = .photoLibrary
            self.present(imagepickercontroller, animated: true, completion: nil)
            
        }))
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionsheet, animated: true, completion: nil)

    }
    @IBAction func imageSix(_ sender: Any) {
        Selector = 5
        
        let imagepickercontroller = UIImagePickerController()
        imagepickercontroller.delegate = self
        let actionsheet = UIAlertController(title: "MaxiumumPicturestoupload", message: "ChooseASource", preferredStyle: .actionSheet)
        actionsheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            imagepickercontroller.sourceType = .camera
            self.present(imagepickercontroller, animated: true, completion: nil)
        }))
        actionsheet.addAction(UIAlertAction(title: "Photolibrary", style: .default, handler: { (action:UIAlertAction) in
            imagepickercontroller.sourceType = .photoLibrary
            self.present(imagepickercontroller, animated: true, completion: nil)
            
        }))
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionsheet, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        HUD.show(.progress)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        WebServices.uploadThumbnail(thumbnail: image, completionHandler: { (sucess, response, error) in
            if sucess {
                HUD.flash(.success, delay: 2.0)
                if self.Selector != -1 {
                    self.Image_Links[self.Selector] = response as! String
                }
                print(self.Image_Links)
            } else {
                print("error")
            }
        })

    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func register(_ sender: Any) {
        if Image_Links[0] == "" {
            HUD.flash(.labeledError(title: "Wrong", subtitle: "Select identity image"), delay: 1.0)
        }else if Image_Links[1] == "" {
            HUD.flash(.labeledError(title: "Wrong", subtitle: "Select driving license image"), delay: 1.0)
        }else if Image_Links[2] == "" {
            HUD.flash(.labeledError(title: "Wrong", subtitle: "Select car license image"), delay: 1.0)
        }else if Image_Links[3] == "" {
            HUD.flash(.labeledError(title: "Wrong", subtitle: "Select Car image"), delay: 1.0)
        }else if Image_Links[4] == "" {
            HUD.flash(.labeledError(title: "Wrong", subtitle: "Select personal image"), delay: 1.0)
        }
        else{
            WebServices.instance.register(fullname: params2["fullname"] as! String, countryID: params2["countryID"] as! String, cityID: params2["cityID"] as! String, mobile: params2["mobile"] as! String, email: params2["email"] as! String, password: params2["password"] as! String, nationality: params2["Nationality"] as! String, caryear: params2["carYear"] as! String, carmodel: params2["carModel"] as! String, carnumber: params2["carNumber"] as! String, carcolor: params2["carColor"] as! String, personalimg: Image_Links[4], identityimage: Image_Links[0], drivinglicenseimg: Image_Links[1], carlicenceimg: Image_Links[2], carimage: Image_Links[3], completion: { (status , error) in
                if status {
                    HUD.flash(.success, delay: 2.0)
                    self.performSegue(withIdentifier: "login", sender: nil)
                }else if error == ""{
                    HUD.hide()
                    HUD.flash(.labeledError(title: "Wrong", subtitle: "Email or mobile exists"), delay: 1.0)
                }
            })

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

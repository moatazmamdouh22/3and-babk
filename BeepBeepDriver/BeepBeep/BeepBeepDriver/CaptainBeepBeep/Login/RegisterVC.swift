//
//  RegisterVC.swift
//  DriverRequest
//
//  Created by MacBook on 4/16/18.
//  Copyright © 2018 Technosaab. All rights reserved.
//

import UIKit
import PKHUD
class RegisterVC: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var nationality: UITextField!
    @IBOutlet weak var carmodel: UITextField!
    @IBOutlet weak var caryear: UITextField!
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var mobile: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var carcolor: UITextField!
    @IBOutlet weak var carnumber: UITextField!
    @IBOutlet weak var bankName: UITextField!
    @IBOutlet weak var accountNumber: UITextField!
    
    
    var selectYear = ""
    let year = Calendar.current.component(.year, from: Date()) + 1
    var Caryears = Array<Int>()
    

    var carmodelID = ""
    var nationalityID = ""
    var cityID = ""
    var countryID = ""
    var SelectedCountry = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setPickerToField(textField: country, title: "Countries")
        setPickerToField(textField: city, title: "Cities")
        setPickerToField(textField: nationality, title: "Nationality")
        setPickerToField(textField: carmodel, title: "Car Models")
        setPickerToField(textField: caryear, title: "Car Years")

        print(SelectedCountry)
        for var i in 2000...self.year {
            self.Caryears.append(i)
        }
        print(Caryears)

        // Do any additional setup after loading the view.
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return APPCOUNTRY.count
        }else if pickerView.tag == 2 {
            return APPCOUNTRY.count
        }else if pickerView.tag == 3 {
            return APPMODELS.count
        }else if pickerView.tag == 4{
            return Caryears.count
        }else{
            return APPCITY.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
                return APPCOUNTRY[row].titleEN
        }else if pickerView.tag == 2 {
                return APPCOUNTRY[row].titleEN
        }else if pickerView.tag == 3 {
            return APPMODELS[row].titleEN
        }else  if pickerView.tag == 4{
            return "\(self.Caryears[row])"
        }else{
            return APPCITY[row].titleEN
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            self.country.text = APPCOUNTRY[row].titleEN
            self.countryID = APPCOUNTRY[row].id!
            self.SelectedCountry = APPCOUNTRY[row].id!
            WebServices.instance.getCities(id: self.SelectedCountry) { (status, error) in
                if status {
                    print("status",status)
                }else if error == ""{
                    print("error",error)
                }
            }
        }else if pickerView.tag == 2 {
            self.nationality.text = APPCOUNTRY[row].titleEN
            self.nationalityID = APPCOUNTRY[row].id!
        }else if pickerView.tag == 3 {
            self.carmodel.text = APPMODELS[row].titleEN
            self.carmodelID = APPMODELS[row].id!
        }else  if pickerView.tag == 4{
            self.selectYear = "\(self.Caryears[row])"
            self.caryear.text = "\(self.Caryears[row])"
        }else{
            self.city.text = APPCITY[row].titleEN
            self.cityID = APPCITY[row].id!

        }
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if firstname.text! == "" {
            HUD.flash(.labeledError(title: "Wrong", subtitle: "Enter name"), delay: 2.0)
            return false

        }else if email.text! == "" {
            HUD.flash(.labeledError(title: "Wrong", subtitle: "Enter email"), delay: 2.0)
            return false

        }else if countryID == "" {
            HUD.flash(.labeledError(title: "Wrong", subtitle: "Select country"), delay: 2.0)
            return false

        }else if cityID == "" {
            HUD.flash(.labeledError(title: "Wrong", subtitle: "Select city"), delay: 2.0)
            return false

        }else if nationalityID == "" {
            HUD.flash(.labeledError(title: "Wrong", subtitle: "Select nationality"), delay: 2.0)
            return false

        }else if password.text! == "" {
            HUD.flash(.labeledError(title: "Wrong", subtitle: "Enter password"), delay: 2.0)
            return false

        }else if mobile.text! == "" {
            HUD.flash(.labeledError(title: "Wrong", subtitle: "Enter mobile"), delay: 2.0)
            return false
            
        }
        else{
            return true
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let viewControllerB = segue.destination as? ImageUploadVC {
                let params2 = [
                    "fullname":firstname.text!,
                    "countryID":countryID,
                    "cityID":cityID,
                    "mobile":mobile.text!,
                    "email":email.text!,
                    "password":password.text!,
                    "Nationality":nationalityID,
                    "carYear":selectYear,
                    "carModel":carmodelID,
                    "carNumber":carnumber.text!,
                    "carColor":carcolor.text!
                    ] as [String : Any]
                viewControllerB.params2 = params2
            }
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

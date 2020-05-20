//
//  ChangeCountryVC.swift
//  DriverRequest
//
//  Created by MacBook on 4/25/18.
//  Copyright © 2018 Technosaab. All rights reserved.
//

import UIKit
import PKHUD

class ChangeCountryVC: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var city: UITextField!
    
    @IBOutlet weak var changeCountryLabel: UILabel!
    
    @IBOutlet weak var editOut: UIButton!
    @IBOutlet weak var exitOut: UIButton!
    
    let Country = UserDefaults.standard.value(forKey: "Country") as! String
    let City = UserDefaults.standard.value(forKey: "City") as! String

    var cityID = ""
    var countryID = ""
    var SelectedCountry = ""
	
	

    override func viewDidLoad() {
        super.viewDidLoad()
        self.country.text = Country
        self.city.text = City
        
        editOut.setTitle("edit".localized, for: .normal)
        exitOut.setTitle("exit".localized, for: .normal)
        changeCountryLabel.text = "changecountry".localized

        
        setPickerToField(textField: country, title: "Countries")
        setPickerToField(textField: city, title: "Cities")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editBtn(_ sender: Any) {
        if (self.country.text?.isEmpty)! {
            HUD.flash(.labeledError(title: "Wrong".localized, subtitle: "SelectCountry".localized), delay: 2.0)
        }else  if (self.city.text?.isEmpty)! {
            HUD.flash(.labeledError(title: "Wrong".localized, subtitle: "SelectCity".localized), delay: 2.0)
            
        }else{
            HUD.flash(.progress)
            WebServices.instance.updateLocation(countryID: self.countryID, cityID: self.cityID, completion: { (status) in
                if status {
                    print(status)
                    HUD.flash(.success, delay: 2.0)
                    self.dismiss(animated: true, completion: nil)
                }else {
                    HUD.flash(.labeledError(title: "Wrong".localized, subtitle: "ERRORBACKEND".localized), delay: 2.0)
                }
            })
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return APPCOUNTRY.count
        }else{
            return APPCITY.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return APPCOUNTRY[row].titleEN
        }else{
            return APPCITY[row].titleEN
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
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
        }else{
            self.city.text = APPCITY[row].titleEN
            self.cityID = APPCITY[row].id!
        }
    }
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelbtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

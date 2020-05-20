//
//  LanguageManger.swift
//  DriverRequest
//
//  Created by MacBook on 5/23/18.
//  Copyright © 2018 Technosaab. All rights reserved.
//

import Foundation
import UIKit


class LanguageManger {
    
    // ChangeLanguage Func
    public func changeLanguage(_ View: UIViewController){
        var actionSheet: UIAlertController!
        var popUpTilte = "Select your Langauge"
        var arabicTitle = "Arabic"
        var englishTitle = "English"
        var cancelTitle = "Cancel"
        if Bundle.main.preferredLocalizations.first == "ar"{ //<----------------  print the status
            popUpTilte = "من فضلك إختار اللغة"
            arabicTitle = "الغة العربية"
            englishTitle = "اللغة الإنجليزية"
            cancelTitle = "إلغاء"
        }else{
            popUpTilte = "Select your Language"
            arabicTitle = "Arabic"
            englishTitle = "English"
            cancelTitle = "Cancel"
        }
        actionSheet = UIAlertController(title: nil, message: popUpTilte, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let arabicAction = UIAlertAction(title: arabicTitle, style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.changeToLanguage("ar", View)
        })
        
        let englishAction = UIAlertAction(title: englishTitle, style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.changeToLanguage("en", View)
            
        })
        
        
        let cancelAction = UIAlertAction(title:cancelTitle, style: UIAlertActionStyle.cancel, handler: {
            (alert: UIAlertAction) -> Void in
        })
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(arabicAction)
        actionSheet.addAction(englishAction)
        View.present(actionSheet, animated: true, completion: nil)
        
    }
    
    // ChangeLanguage Func
    public func changeToLanguage (_ langCode: String, _ View: UIViewController) {
        
        var restartTilte = ""
        var restart = ""
        var close = ""
        var cancel = ""
        if Bundle.main.preferredLocalizations.first != langCode {
            if Bundle.main.preferredLocalizations.first != "en"{
                restartTilte = "App resart required"
                restart = "In order to change the language, the App must be closed and open by you."
                close = "Close now"
                cancel = "Cancel"
            }else{
                
                restartTilte = "تحتاج الي اعادة التشغيل"
                restart =  "حتي تستطيع تغير اللغه ، تحتاج ال غلق البرنامج و من ثم تفوم بفتحه مرة اخري"
                close = "اغلقه الان"
                cancel = "لا اريد"
            }
            let confirmAlertCtrl = UIAlertController(title: restartTilte, message: restart, preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: close, style: .destructive) { _ in
                UserDefaults.standard.set([langCode], forKey: "AppleLanguages")
                UserDefaults.standard.synchronize()
                exit(EXIT_SUCCESS)
                
            }
            confirmAlertCtrl.addAction(confirmAction)
            let cancelAction = UIAlertAction(title: cancel, style: .cancel, handler: nil)
            confirmAlertCtrl.addAction(cancelAction)
            
            View.present(confirmAlertCtrl, animated: true, completion: nil)
            
        }
        
    }
    
}



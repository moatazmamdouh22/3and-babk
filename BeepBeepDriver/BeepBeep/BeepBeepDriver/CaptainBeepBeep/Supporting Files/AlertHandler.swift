
import Foundation
import UIKit


class AlertHandler{
    public func displayMyAlertMessage(message: String, title: String, okTitle: String, view: UIViewController){
        
        let myAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title: okTitle, style:UIAlertActionStyle.default, handler:nil);
        myAlert.addAction(okAction);
        view.present(myAlert, animated:true, completion:nil);
    }
    func displayAlert(message: String, title: String, okTitle: String,view: UIViewController){
        // Create the alert controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: okTitle, style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        // Present the controller
        view.present(alertController, animated: true, completion: nil)
    }
}



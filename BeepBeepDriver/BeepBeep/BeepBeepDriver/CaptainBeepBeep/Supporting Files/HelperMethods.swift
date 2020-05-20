//
//  HelperMethods.swift
//  DriverRequest
//
//  Created by MacBook on 4/24/18.
//  Copyright © 2018 Technosaab. All rights reserved.
//
import UIKit
import SystemConfiguration
import MessageUI
import AVFoundation
import AVKit
import MapKit

public enum validateTypes
{
    case empty , email , min , max  ;
}


public var screenWidth:CGFloat { get { return UIScreen.main.bounds.size.width } }
public var screenHeight:CGFloat { get { return UIScreen.main.bounds.size.height } }


class mydelegets:UIViewController, MFMessageComposeViewControllerDelegate , MFMailComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - get App Version
public func getVersion() -> String {
    if let AppVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString"){
        return AppVersion as! String
    }
    return "0.0"
    
}
//MARK: - call number
public func makeCall(forNumber number:String)->Bool {
    let url:URL = URL(string:"tel://\(number)")!
    if UIApplication.shared.canOpenURL(url) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
        }
        return true
    }
    return false
}

//MARK: - copy string
public func makeCopy(ofString string:String){
    UIPasteboard.general.string = string
}



//MARK: - dates

//get current date
public func getCurrentDate()->String{
    let format = DateFormatter()
    format.dateFormat = "dd-MM-yyyy hh:mm:ss"
    format.locale = Locale(identifier: "en")
    let date = format.string(from: Date())
    return date
}

// get Date And Time As String From String With Format
public func getDateAndTimeAsStringFromStringWithFormat(_ dateString:String,formatString:String)->(date:String,time:String)? {
    var output:(date:String,time:String)
    
    if let date = getDateFromStringWithFormat(dateString, formatString: formatString) {
        let format = DateFormatter()
        format.dateFormat = "d MMMM YYYY"
        
        if getCurrentDateWithFormat("d MMMM YYYY") == format.string(from: date) {
            output.date = "Today"
        }else{
            output.date = format.string(from: date)
        }
        
        format.dateFormat = "h:mma"
        format.amSymbol = "am"
        format.pmSymbol = "pm"
        
        output.time = format.string(from: date)
        return output
    }
    
    return nil
}

// get Current Date With Format
public func getCurrentDateWithFormat(_ formatString:String)->String{
    let format = DateFormatter()
    format.dateFormat = formatString
    format.locale = Locale(identifier: "en")
    let date = format.string(from: Date())
    return date
}

// get Date From String With Format
public func getDateFromStringWithFormat(_ dateString:String,formatString:String)->Date? {
    
    let format = DateFormatter()
    format.locale = Locale(identifier: "en")
    format.dateFormat = formatString
    let date = format.date(from: dateString)
    return date
}
// get Date From String With Format
public func getDateFromString(_ time:String,formatString:String)->String {
    let string = time
    let dateFormatter = DateFormatter()
    let tempLocale = dateFormatter.locale // save locale temporarily
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    let date = dateFormatter.date(from: string)!
    dateFormatter.dateFormat = formatString
    dateFormatter.locale = tempLocale // reset the locale
    let dateString = dateFormatter.string(from: date)
    print("EXACT_DATE : \(dateString)")
    return dateString
}
// get distance
public func  distanceBetweenLocations(locationOne: CLLocation , locationTwo: CLLocation) -> Double {
    
    let distance = locationOne.distance(from: locationTwo) / 1000
    return Double(distance).rounded(toPlaces: 2)
}
//MARK: - alerts

//
public func emptyLabel(_ message:String,forController controller:UIViewController){
    let w = UIScreen.main.bounds.width
    let h = UIScreen.main.bounds.height
    
    let  label = UILabel(frame: CGRect(x:0 , y: h / 2, width: w, height: 30))
    label.text = message
    label.center = CGPoint(x: w / 2, y: h / 2)
    label.textAlignment = .center
    label.textColor = hexStringToUIColor(hex: "6E6E6E", opacity: 1)
    label.font = label.font.withSize(20)
    controller.self.view.addSubview(label)
}



//MARK: - internet

//check internet connection
public func isConnectedToNetwork() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            SCNetworkReachabilityCreateWithAddress(nil, $0)
        }
    }) else {
        return false
    }
    
    var flags: SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
        return false
    }
    
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    
    return (isReachable && !needsConnection)
}


// MARK: - Play video from URL

public func playVideoFromURL(_ container:UIView , URLString:String)
{
    let videoURL = URL(string: URLString)
    let player = AVPlayer(url: videoURL!)
    let playerLayer = AVPlayerLayer(player: player)
    playerLayer.frame = container.bounds
    container.layer.addSublayer(playerLayer)
    player.play()
}


// MARK: - Share APP
public func shareApp(link: String , controller: UIViewController){
    let textToShare = "Share it Now !"
    
    if let myWebsite = NSURL(string: link) {
        let objectsToShare = [textToShare, myWebsite] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        activityVC.popoverPresentationController?.sourceView = controller.view
        controller.present(activityVC, animated: true, completion: nil)
        
    }
}

//MARK: - Observers NSNotifications


public func setObserverNotification( forController controller: UIViewController , selector:Selector , name:String)
{
    NotificationCenter.default.addObserver(controller, selector: selector, name:NSNotification.Name(rawValue: name), object: nil)
}

public func getObserverNotifiationWith(name:String)
{
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: name), object: nil)
}
/// Makes a progress bar with tag 5000
///   Don't call before making your loader
///
/// - Parameter controller: The view controller to present the bar on
public func makeProgressBar(_ controller : UIViewController) {
    // After this (to wait for loader creation)
    mainQueue {
        // Get loader
        let loader = controller.view.viewWithTag(4000)
        
        // Create a progress bar
        let progressBar = UIProgressView(progressViewStyle: .default)
        
        // Layout the progress bar
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.isHidden = false
        loader?.addSubview(progressBar)
        NSLayoutConstraint(item: progressBar, attribute: .centerX, relatedBy: .equal, toItem: loader, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: progressBar, attribute: .centerY, relatedBy: .equal, toItem: loader, attribute: .centerY, multiplier: 1, constant: 64).isActive = true
        NSLayoutConstraint(item: progressBar, attribute: .width, relatedBy: .equal, toItem: loader, attribute: .width, multiplier: 0.2, constant: 0).isActive = true
        
        // Give tag to use outside this function
        progressBar.tag = 5000
        
        // Prepare progress bar
        progressBar.setProgress(0, animated: false)
    }
    
}


//validate email
public func isValidEmail(_ testStr:String) -> Bool {
    let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    let result = emailTest.evaluate(with: testStr)
    return result
}




public func validateString(_ text:String?)->String {
    return text ?? ""
}

//Validate optional int
public func validateInt(_ val:Int?)->Int {
    return val ?? 0
}

//MARK: - dispatch queues
//delay to time
public func delay(_ delay: Double, closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

public func mainQueue(_ closure: @escaping ()->()){
    DispatchQueue.main.async(execute: closure)
}

public func backgroundQueue(_ closure: @escaping ()->()){
    DispatchQueue.global(qos: .background).async {
        closure()
    }
}


//MARK: - active controller
// Returns the most recently presented UIViewController (visible)
public func getCurrentViewController() -> UIViewController? {
    
    // we must get the root UIViewController and iterate through presented views
    if let rootController = UIApplication.shared.keyWindow?.rootViewController {
        
        var currentController: UIViewController! = rootController
        
        // Each ViewController keeps track of the view it has presented, so we
        // can move from the head to the tail, which will always be the current view
        while( currentController.presentedViewController != nil ) {
            
            currentController = currentController.presentedViewController
        }
        return currentController
    }
    
    return nil
}



//MARK: - Localization and languages
public func localizedSitringFor(key:String)->String {
    return NSLocalizedString(key, comment: "")
}


//MARK: - Colors
public func hexStringToUIColor (hex:String , opacity : CGFloat) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.characters.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(opacity)
    )
}

// MARK: - Convert Arabic numbers
public func getNSNumberFromString(_ text : String) -> NSNumber? {
    return NumberFormatter().number(from: text)
}

public func intFromString(_ text : String?) -> Int? {
    if text == nil { return nil }
    if let n = getNSNumberFromString(text!) { return n.intValue } else { return nil }
}
public func uintFromString(_ text : String?) -> UInt? {
    if text == nil { return nil }
    if let n = getNSNumberFromString(text!) { return n.intValue >= 0 ? n.uintValue : nil } else { return nil }
}
public func doubleFromString(_ text : String?) -> Double? {
    if text == nil { return nil }
    if let n = getNSNumberFromString(text!) { return n.doubleValue } else { return nil }
}
public func decimalFromString(_ text : String?) -> NSDecimalNumber? {
    if text == nil { return nil }
    if let n = getNSNumberFromString(text!) { return NSDecimalNumber(decimal: n.decimalValue) } else { return nil }
}


// MARK: - Validation with effects


func animateValidationError(errorText : UILabel) {
    errorText.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
    UIView.animate(withDuration: 0.2, animations: {
        errorText.transform = CGAffineTransform(scaleX: 1, y: 1)
    }, completion: { _ in
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: DispatchTime.now().uptimeNanoseconds + (3 * NSEC_PER_SEC)), execute: {
            UIView.animate(withDuration: 0.2, animations: {
                errorText.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }, completion: { _ in
                errorText.removeFromSuperview()
            })
        })
    })
}

func revealValidationError(over view : UIView, superView : UIView, text : String) {
    let errorText = UILabel()
    errorText.backgroundColor = UIColor(red: 0, green: 1, blue: 1, alpha: 0.2)
    errorText.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    errorText.text = text
    errorText.font = UIFont(name: "Cairo-regular", size: 17)
    errorText.translatesAutoresizingMaskIntoConstraints = false
    errorText.isOpaque = true
    errorText.isHidden = false
    superView.addSubview(errorText)
    NSLayoutConstraint(item: errorText, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: errorText, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: -8).isActive = true
    animateValidationError(errorText: errorText)
}
// MARK: Constraints


public func constraintsWithFormat(format:String , views:UIView...)
{
    var viewsDic = [String: UIView]()
    for (index , view ) in views.enumerated() {
        let key = "v\(index)"
        
        viewsDic[key] = view
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let constraints =   NSLayoutConstraint.constraints(withVisualFormat: format, options: [], metrics: nil, views: viewsDic)
    NSLayoutConstraint.activate(constraints)
    
    
    
    
    
}


func setNormalConstraints(item:UIView , relatedTo:UIView , attr:NSLayoutAttribute , relatedBy:NSLayoutRelation , multiplier: CGFloat , constant : CGFloat)
    
{
    
    item.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint(item: item, attribute: attr, relatedBy: relatedBy, toItem: relatedTo, attribute: attr, multiplier: multiplier, constant: constant).isActive = true
    
    
    
    
}



func timeAgoSinceDate(_ date:Date,currentDate:Date, numericDates:Bool) -> String {
    let calendar = Calendar.current
    let now = currentDate
    let earliest = (now as NSDate).earlierDate(date)
    let latest = (earliest == now) ? date : now
    let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
    
    if (components.year! >= 2) {
        return "\(components.year!) years ago"
    } else if (components.year! >= 1){
        if (numericDates){
            return "1 year ago"
        } else {
            return "Last year"
        }
    } else if (components.month! >= 2) {
        return "\(components.month!) months ago"
    } else if (components.month! >= 1){
        if (numericDates){
            return "1 month ago"
        } else {
            return "Last month"
        }
    } else if (components.weekOfYear! >= 2) {
        return "\(components.weekOfYear!) weeks ago"
    } else if (components.weekOfYear! >= 1){
        if (numericDates){
            return "1 week ago"
        } else {
            return "Last week"
        }
    } else if (components.day! >= 2) {
        return "\(components.day!) days ago"
    } else if (components.day! >= 1){
        if (numericDates){
            return "1 day ago"
        } else {
            return "Yesterday"
        }
    } else if (components.hour! >= 2) {
        return "\(components.hour!) hours ago"
    } else if (components.hour! >= 1){
        if (numericDates){
            return "1 hour ago"
        } else {
            return "An hour ago"
        }
    } else if (components.minute! >= 2) {
        return "\(components.minute!) minutes ago"
    } else if (components.minute! >= 1){
        if (numericDates){
            return "1 minute ago"
        } else {
            return "A minute ago"
        }
    } else if (components.second! >= 3) {
        return "\(components.second!) seconds ago"
    } else {
        return "Just now"
    }
    
}

class Stopwatch {
    var counter = 0.0
    var startTime:Date?
    
    func startTimer() {
        startTime = Date();
    }
    
    
    func elapsedTimeSinceStart() -> String {
        counter = counter + 0.1
        return String(format: "%.1f", counter)
        
        //        var elapsed = 0.0;
        ////        if let elapsedTime = startTime {
        //
        //                elapsed = Date().timeIntervalSinceNow
        //
        ////                elapsed = elapsedTime.timeIntervalSinceNow - 45*60
        //
        ////        }
        //        elapsed = -elapsed
        //        let minutes = Int(floor((elapsed / 60)));
        //        let seconds = Int(floor((elapsed.truncatingRemainder(dividingBy: 60))));
        //                print(elapsed)
        //        let timeString = String(format: "%02d:%02d", minutes, seconds)
        //                print(timeString)
        //        return timeString
    }
    
}

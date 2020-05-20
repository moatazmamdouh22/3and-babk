//
//  OrderDetailsVC.swift
//  DriverRequest
//
//  Created by MacBook on 4/24/18.
//  Copyright © 2018 Technosaab. All rights reserved.
//

import UIKit
import PKHUD
import SwiftyJSON
import Alamofire
import AVFoundation
import UserNotifications
class OrderDetailsVC: BaseViewController {
    @IBOutlet weak var timeCounter: UILabel!
    @IBOutlet weak var marketname: UILabel!
    @IBOutlet weak var clientname: UILabel!
    @IBOutlet weak var ordernumber: UILabel!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var delivaryplace: UILabel!
    @IBOutlet weak var travelieddistance: UILabel!
    @IBOutlet weak var delivarycost: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var couponnumber: UILabel!
    @IBOutlet weak var gotomarket: UILabel!
    @IBOutlet weak var marketnamelabel: UILabel!
    @IBOutlet weak var clientnamelabel: UILabel!
    @IBOutlet weak var chatlabel: UIButton!
    @IBOutlet weak var orderdetailslabel: UIButton!
    @IBOutlet weak var calllabel: UIButton!
    @IBOutlet weak var ordernumberlabel: UILabel!
    @IBOutlet weak var costlabel: UILabel!
    @IBOutlet weak var delivaryplacelabel: UILabel!
    @IBOutlet weak var travelledplacelabel: UILabel!
    @IBOutlet weak var delivarycostlabel: UILabel!
    @IBOutlet weak var ordertimelabel: UILabel!
    @IBOutlet weak var couponnumberlabel: UILabel!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var orderdetailslabelt: UILabel!
    @IBOutlet weak var redgreenview: UIImageView!
    
    @IBOutlet weak var orderBtn: UIButton!
    
    var order = Order()
    var phNo = ""
    var dist = 0.0
    var player: AVAudioPlayer?
    var Y = ""
    var langitude = 0.0
    var latitude = 0.0
    var createdAt = ""
    var imagecheck = #imageLiteral(resourceName: "Slice 24")
    let id = UserDefaults.standard.value(forKey: "RequestID") as! String
    let DriverID = UserDefaults.standard.value(forKey: "id") as! String
    let userimg =  UserDefaults.standard.value(forKey: "personalImg") as! String
    var billcheck = 0
    let currentlat = UserDefaults.standard.value(forKey: "CurrentLatitude")
    let currentlang = UserDefaults.standard.value(forKey: "CurrentLonitude")
    override func viewDidLoad() {
        super.viewDidLoad()
        MySocket.instance.socket.on("requestCanceled", callback: { (data, ack) in
            guard let url = Bundle.main.url(forResource: "ring", withExtension: "mp3") else { return }
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                
                let player = try AVAudioPlayer(contentsOf: url)
                
                player.play()
            } catch let error {
                print(error.localizedDescription)
            }

            let alert = UIAlertController(title: "Attention".localized, message: "Request Cancled !!".localized, preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: { action in
                switch action.style{
                case .default:
                    self.player?.stop()
                    print("default")
                    UserDefaults.standard.removeObject(forKey: "Receipt_imgPath")

                    UserDefaults.standard.removeObject(forKey: "x")
                    UserDefaults.standard.removeObject(forKey: "2")
                    UserDefaults.standard.removeObject(forKey: "Receipt_itemCost")
                    UserDefaults.standard.removeObject(forKey: "RequestID")

                    MySocket.instance.disconnect()
                    self.performSegue(withIdentifier: "exitchat", sender: nil)

                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                    
                }}))
            self.present(alert, animated: true, completion: nil)
            
        })
        listenOnChat()
        if UserDefaults.standard.value(forKey: "x") as? Bool == true {
            redgreenview.image = #imageLiteral(resourceName: "39278305_1918283741551461_6097608977581867008_n")
            self.imagecheck = #imageLiteral(resourceName: "39278305_1918283741551461_6097608977581867008_n")
        }
//        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: navigationController, action: nil)
//        navigationItem.leftBarButtonItem = backButton
        orderBtn.setTitle("order".localized, for: .normal)
        marketnamelabel.text = "marketlabel".localized
       gotomarket.text = "gotomarket".localized
        clientnamelabel.text = "clientname".localized
        chatlabel.setTitle("chatlabel".localized, for: .normal)
        
       orderdetailslabel.setTitle("orderdetails".localized, for: .normal)
        calllabel.setTitle("calllabel".localized, for: .normal)
            orderdetailslabelt.text = "orderdetails".localized
        ordernumberlabel.text = "ordernumber".localized
        costlabel.text = "cost".localized
        delivaryplacelabel.text = "delivaryplace".localized
         travelledplacelabel.text = "travelledplace".localized
         delivarycostlabel.text = "delivarycost".localized
       ordertimelabel.text = "ordertime".localized
        datelabel.text = "orderdate".localized
       couponnumberlabel.text = "Couponnumber".localized
        MySocket.instance.socket.on("connect") {data, ack in
            MySocket.instance.socket.emit("addUserToRoom",self.id,self.userimg,1,self.DriverID)
        }

        HUD.show(.progress)
        WebServices.instance.getRequistByID(id: id, completion: { (order) in
            HUD.hide()
            print(order)
            self.cost.text = order.cost
            UserDefaults.standard.set(order.cost, forKey: "orderCost")
            self.marketname.text = order.marketName
            self.time.text = getDateFromString(order.createdAt!,formatString: "h:mm a")
            self.date.text = getDateFromString(order.createdAt!,formatString: "MM/dd/yyyy")
            self.ordernumber.text = order._id
            self.clientname.text = order.username
            self.phNo = order.usermobile!
            self.createdAt = order.createdAt!
         //   self.travelieddistance.text = order.distance
         //   self.delivarycost.text = self.cost
            self.cost.text = order.cost
            let userlang = order.userLng
            let useraut = order.userAut
            self.delivaryplace.text = UserDefaults.standard.value(forKey: "delplace") as! String
            Alamofire.request(APIKeys().getOrderMinFees, method: .get ,  encoding: URLEncoding.default).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value).dictionaryValue
                    let Cost = json["value"]?.doubleValue
                    print("____________")
                    print(Cost!)
                    UserDefaults.standard.set(Cost, forKey: "req_cost")
                case .failure(let error):
                    print(error)
                }
            }
            Alamofire.request(APIKeys().getOrderFees, method: .get ,  encoding: URLEncoding.default).validate().responseJSON { response in
                // // print(response.debugDescription)
                switch response.result {
                case .success(let value):
                    let json = JSON(value).dictionaryValue
                    let fees = json["value"]?.doubleValue
                    UserDefaults.standard.set(fees, forKey: "app_fees")
                case .failure(let error):
                    print(error)
                    
                }
            }

            let url = "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=\(order.userAut!),%20\(order.userLng!)&destinations=\(order.marketAut!),%20\(order.marketLng!)&key=AIzaSyA8Zpd6jjGvcaiCHrCquNV0n_Xhkkk83GI"
            
            Alamofire.request(url, method: .get , encoding: URLEncoding.default).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("URL",url)
                    let json = JSON(value)
                    print("All Value",json)
                    let rows = json["rows"]
                    for (_, subJson) in rows {
                        let element = subJson["elements"]
                        print("asdasdasdasd",element)
                        for (_, subJson) in element {
                            let Distance = subJson["distance"]
                            self.dist = Distance["text"].doubleValue
                            print("Distance is -->" , self.dist)
                            self.travelieddistance.text! = "\(self.dist)Km"
                            if self.dist < 5
                            {
                                print("more than 5")
                                self.delivarycost.text = "\(Int(UserDefaults.standard.double(forKey: "req_cost")))"
                                var Cost = self.delivarycost.text
                                UserDefaults.standard.set(Cost, forKey: "Cost")
                                print(UserDefaults.standard.double(forKey: "req_cost"))
                            }
                            else{
                                print("in else of more than 5")

                                let reDistance = Int(self.dist) - 5
                                self.delivarycost.text = String(Int(UserDefaults.standard.double(forKey: "req_cost")) + (Int(reDistance) * Int(UserDefaults.standard.double(forKey: "app_fees"))))
                                var Cost = self.delivarycost.text
                                UserDefaults.standard.set(Cost, forKey: "Cost")
                                print("1321321321321231231")
                                print(UserDefaults.standard.double(forKey: "app_fees"))
                            }
                        }
                    }
                    print("..............................")
                case .failure(let error):
                    print(error)
                }
            }


            let _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.counter), userInfo: nil, repeats: true)
        })
        self.order = SAVEDORDER
    }
    
    
    
    @IBAction func call(_ sender: Any) {
        if let phoneUrl = URL(string: "telprompt:\(phNo)")
        {
            print(phoneUrl)
            UIApplication.shared.open(phoneUrl, options: [:], completionHandler: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func secondstepbtn(_ sender: Any) {
        if redgreenview.image == #imageLiteral(resourceName: "Slice 24"){
            self.performSegue(withIdentifier: "finish", sender: nil)
        }else if redgreenview.image == #imageLiteral(resourceName: "39278305_1918283741551461_6097608977581867008_n") {
            if UserDefaults.standard.bool(forKey:"true") != false {
                let alertController = UIAlertController(title: "Attention !".localized, message: "you make sure you finished order", preferredStyle: .alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "continue".localized, style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                    UserDefaults.standard.removeObject(forKey: "Receipt_imgPath")
                    MySocket.instance.socket.emit("requestReady")
                    UserDefaults.standard.removeObject(forKey: "x")
                    UserDefaults.standard.removeObject(forKey: "2")
                    UserDefaults.standard.removeObject(forKey: "Receipt_itemCost")
                    UserDefaults.standard.removeObject(forKey: "RequestID")
                    UserDefaults.standard.removeObject(forKey: "true")
                    MySocket.instance.disconnect()
                    self.performSegue(withIdentifier: "exitchat", sender: nil)
                }
                let cancelAction = UIAlertAction(title: "Exit".localized, style: UIAlertActionStyle.cancel) {
                    UIAlertAction in
                    NSLog("Cancel Pressed")
                }
                
                // Add the actions
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
                
                
            }
            else{
            let alert = UIAlertController(title: "Attention".localized, message: "Youmustmakerecipttoexitrequest".localized, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    self.performSegue(withIdentifier: "chatapp", sender: nil)
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                }}))
            self.present(alert, animated: true, completion: nil)
            }
        }
    }
    @IBAction func greenbtn(_ sender: Any) {
        print("item:ANy")
        print("---------")
        if redgreenview.image == #imageLiteral(resourceName: "Slice 24"){
            print("asdsads")
            self.imagecheck = #imageLiteral(resourceName: "Slice 24")

            self.performSegue(withIdentifier: "finish", sender: nil)
        }else if redgreenview.image == #imageLiteral(resourceName: "39278305_1918283741551461_6097608977581867008_n") {
            self.imagecheck = #imageLiteral(resourceName: "39278305_1918283741551461_6097608977581867008_n")

            self.performSegue(withIdentifier: "chatapp", sender: nil)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dist = segue.destination as? ChatDriverVC {
            dist.imagecheck = imagecheck
        }
    }
    override func viewWillAppear(_ animated: Bool) {

    }
    @IBAction func gotomarket(_ sender: Any) {
        UIApplication.shared.openURL(URL(string:"https://www.google.com/maps/@\(currentlat!)),\(currentlang!))")!)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	func listenOnChat(){
		MySocket.instance.socket.on("getMessage", callback: { (data, ack) in
			let json = JSON(rawValue: data)?.arrayValue
			
			let status = json![0]["type"].intValue
			if json![0]["username"].stringValue != "user" {
				if status == 0  {
					// text
					let message = Chat()
					message.senderID = "driver"
					message.messageType = "0"
					message.senderText = json![0]["message"].stringValue
					self.showChatNotification(title: "You have new Message", body: json![0]["message"].stringValue)
				}else if status == 2  {
					// image
					let message = Chat()
					message.senderID = "driver"
					message.messageType = "1"
					message.senderImage = json![0]["message"].stringValue
					self.showChatNotification(title: "You have new Message", body: "📷 It's Image")
				}else if status == 1  {
					// recored
					let message = Chat()
					message.senderID = "driver"
					message.messageType = "2"
					message.senderVoice = json![0]["message"].stringValue
					self.showChatNotification(title: "You have new Message", body: "🎤 Voice Message")
				}
			}
		})
	}
	
	func showChatNotification(title: String , body: String){
		if #available(iOS 10.0, *) {
			let content = UNMutableNotificationContent()
			content.body = body
			content.title = title
			content.sound = UNNotificationSound.default()
			let triger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
			let request = UNNotificationRequest(identifier: "chat", content: content, trigger: triger)
			UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
		} else {
			// Fallback on earlier versions
		}
	}

    @objc func counter() {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"  //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        let finishDate = dateFormatter.date(from: createdAt)
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: finishDate! , to: (date as Date))
        
        let seconds = "\(difference.second ?? 0)"
        let minutes = "\(difference.minute ?? 0)" + ":" + seconds
        let hours = "\(difference.hour ?? 0)" + ":" + minutes
        
        if let second = difference.second, second   > 0 {
            self.timeCounter.text = hours
        }
    }
}

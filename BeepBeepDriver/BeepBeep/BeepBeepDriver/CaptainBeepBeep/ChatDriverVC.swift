//  UserChatViewController.swift
//  Request
//
//  Created by Basem Elgendy on 11/23/17.
//  Copyright © 2017 basem. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import AVFoundation
import AudioToolbox
import Cosmos
import SocketIO
import UserNotifications
class ChatDriverVC: BaseViewController , UITableViewDataSource , UITableViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,RecorderViewDelegate {
    
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var driverImage: UIImageView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextView: UITextField!
    @IBOutlet weak var sendchat: UILabel!
    @IBOutlet weak var VoiceStack: UIStackView!
    @IBOutlet weak var cam: UILabel!
    @IBOutlet weak var voice: UILabel!
    @IBOutlet weak var TextStack: UIStackView!
    @IBOutlet weak var genbil: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    var lang = 0.0
    var lat = 0.0
    var imagecheck = #imageLiteral(resourceName: "Slice 24")
    var player: AVAudioPlayer?
    
    let socketmanager = SocketManager(socketURL: URL(string: "http://104.131.8.69:7000")!)
    var userId = ""
    let DriverID = UserDefaults.standard.value(forKey: "id") as! String
    let userimg =  UserDefaults.standard.value(forKey: "personalImg") as! String
    var check = 0
    let id = UserDefaults.standard.value(forKey: "RequestID") as! String
    var image = UIImageView()
    var imageString :String?
    var actionSheet: UIAlertController!
    var recorderView: RecorderViewController!
    var listMessages:[Chat] = []
    
    
    override func viewDidLoad() {
        
        print("check chat",check)
        WebServices.instance.getRequistByID(id: id, completion: { (order) in
            self.userId = order.userID!
        })
        
        self.genbil.text = "genbill".localized
        super.viewDidLoad()
        WebServices.instance.getRequistByID(id: id, completion: { (order) in
            self.driverName.text = order.drivername
        })
        
        sendchat.text = "Send".localized
        detailsLabel.text = "orderdetails".localized
        messageTextView.placeholder = "typee".localized
        
        
        tableView.estimatedRowHeight = 100
        tableView.contentOffset = CGPoint(x: 0, y: CGFloat.greatestFiniteMagnitude)
        self.setRightTitle(title: "Chat")
        
        // SOCKET
        MySocket.instance.socket.on("getReceipt", callback: { (data, ack) in
            self.check = 2
            print(data,"<---Receipt")
            let json = JSON(rawValue: data)?.arrayValue
            let userimg = json![0]["imgPath"].stringValue
            let itemCost = json![0]["itemCost"].stringValue
            let orderCost = json![0]["orderCost"].stringValue
            let totalCost = json![0]["totalCost"].stringValue
            let imgPath = json![0]["username"].stringValue
            UserDefaults.standard.set(userimg, forKey: "User_Image")
            UserDefaults.standard.set(itemCost, forKey: "Receipt_itemCost")
            UserDefaults.standard.set(orderCost, forKey: "Receipt_orderCost")
            UserDefaults.standard.set(totalCost, forKey: "Receipt_totalCost")
            UserDefaults.standard.set(userimg, forKey: "Receipt_imgPath")
            let receipt = Chat()
            receipt.messageType = "0"
            receipt.senderID = "driver"
            receipt.senderText = "itemCost: \(itemCost)\n orderCost: \(orderCost)\n totalCost: \(totalCost)"
            self.listMessages.append(receipt)
            if UserDefaults.standard.string(forKey: "Receipt_imgPath") != ""{
                let receipt = Chat()
                receipt.messageType = "2"
                receipt.senderID = "driver"
                receipt.senderImage = UserDefaults.standard.string(forKey: "Receipt_imgPath")!
                self.listMessages.append(receipt)
            }
            self.tableView.reloadData()

        })
        MySocket.instance.socket.on("requestCanceled", callback: { (data, ack) in
            self.playSound()
            
            let alert = UIAlertController(title: "Attention".localized, message: "Request Cancled !!".localized, preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: { action in
                switch action.style{
                    
                case .default:
                    self.pausesound()
                    print("default")
                    UserDefaults.standard.removeObject(forKey: "Receipt_imgPath")
                    UserDefaults.standard.removeObject(forKey: "RequestID")
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
        
        
//        MySocket.instance.socket.on("getStatus", callback: { (data, ack) in
//            let json = JSON(rawValue: data)?.arrayValue
//            let status = json![0]["type"].intValue
//            print("--",json!,"--")
//            var x = json![0]["username"].stringValue
//            if json![0]["username"].stringValue != "user" {
//                x = "driver"
//            }
//            if status == 0  {
//                // text
//                let message = Chat()
//                message.senderID = x
//                message.messageType = "0"
//                message.senderText = json![0]["message"].stringValue
//                self.listMessages.append(message)
//                print(self.listMessages)
//                self.tableView.reloadData()
//            }
//        })
        MySocket.instance.socket.on("getStatus", callback: { (data, ack) in
            
            let json = JSON(rawValue: data)?.arrayValue
            let status = json![0]["type"].intValue
            if status == 0  {
                self.statusLabel.text = ""
                self.statusView.isHidden = true
            }else if status == 1  {
                self.statusLabel.text = "is typing"
                self.statusView.isHidden = false
            }else if status == 2  {
                self.statusLabel.text = "is recording"
                self.statusView.isHidden = false
            }
        })

        MySocket.instance.socket.on("getMessage", callback: { (data, ack) in
            let json = JSON(rawValue: data)?.arrayValue
            let status = json![0]["type"].intValue
            print("--",json!,"--")
            var x = json![0]["username"].stringValue
            if json![0]["username"].stringValue != "user" {
                x = "driver"
                let message = Chat()
                message.senderID = "driver"
            }
            if status == 0  {
                // text
                let message = Chat()
                message.senderID = x
                message.messageType = "0"
                message.senderText = json![0]["message"].stringValue
                self.showChatNotification(title: "You have new Message", body: json![0]["message"].stringValue)
                
                self.listMessages.append(message)
                self.tableView.reloadData()
            }else if status == 2  {
                // image
                let message = Chat()
                message.senderID = x
                message.messageType = "2"
                message.senderImage = json![0]["message"].stringValue
                self.showChatNotification(title: "You have new Message", body: "📷 It's Image")
                
                self.listMessages.append(message)
                self.tableView.reloadData()
            }else if status == 1  {
                // recored
                let message = Chat()
                message.senderID = x
                message.messageType = "1"
                message.senderVoice = json![0]["message"].stringValue
                self.showChatNotification(title: "You have new Message", body: "🎤 It's Voice")
                
                self.listMessages.append(message)
                self.tableView.reloadData()
            }
            self.tableView.reloadData()
        })
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.value(forKey: "2")as? Int == 2 {
            self.check = 2
        }else{
            self.check = 1
        }
        TextStack.isHidden = true
        WebServices.instance.getRequestChat(requestID: id) { (chat) in
            self.listMessages = chat
            if let itemCost = UserDefaults.standard.string(forKey: "Receipt_itemCost"){
                let orderCost =   UserDefaults.standard.string(forKey: "Receipt_orderCost")
                let totalCost =   UserDefaults.standard.string(forKey: "Receipt_totalCost")
                //                UserDefaults.standard.set(imgPath, forKey: "Receipt_imgPath")
                let receipt = Chat()
                receipt.messageType = "0"
                receipt.senderID = "driver"
                receipt.senderText = "itemCost: \(itemCost)\n orderCost: \(orderCost!)\n totalCost: \(totalCost!)"
                self.listMessages.append(receipt)
                self.tableView.reloadData()
                print("***",UserDefaults.standard.string(forKey: "Receipt_imgPath")!)
                if UserDefaults.standard.string(forKey: "Receipt_imgPath") != "" && UserDefaults.standard.string(forKey: "Receipt_imgPath") != nil && UserDefaults.standard.string(forKey: "Receipt_imgPath") != "null" && UserDefaults.standard.string(forKey: "Receipt_imgPath") != "nil" {
                    let receipt = Chat()
                    receipt.messageType = "2"
                    receipt.senderID = "driver"
                    receipt.senderImage = UserDefaults.standard.string(forKey: "Receipt_imgPath")!
                    self.listMessages.append(receipt)
                    print("sora",UserDefaults.standard.string(forKey: "Receipt_imgPath")!)
                    print("fatora",receipt)
                    self.tableView.reloadData()
                }
                //self.tableView.reloadData()
            }
            let receipt = Chat()
            let status = receipt.messageType
            var x = receipt.senderID
            if receipt.senderID != "user" {
                x = "driver"
            }
            if status == "0"  {
                // text
                let message = Chat()
                message.senderID = x
                message.messageType = "0"
                message.senderText = receipt.senderText
                self.listMessages.append(message)
                self.tableView.reloadData()
            }else if status == "2"  {
                // image
                let message = Chat()
                message.senderID = x
                message.messageType = "2"
                message.senderImage = receipt.senderImage
                self.listMessages.append(message)
                self.tableView.reloadData()
            }else if status == "1" {
                // recored
                let message = Chat()
                message.senderID = x
                message.messageType = "1"
                message.senderVoice = receipt.senderVoice
                self.listMessages.append(message)
                self.tableView.reloadData()
            }
            self.tableView.reloadData()
        }
    }
    @IBAction func whileEdit(_ sender: Any) {
        if messageTextView.text! != "" {
            VoiceStack.isHidden = true
            TextStack.isHidden = false
            
        }else{
            VoiceStack.isHidden = false
            TextStack.isHidden = true
        }
    }
    
    @IBAction func sendStatus(_ sender: Any) {
        MySocket.instance.socket.emit("sendStatus",1,"is typing...")
        print("is typing .. ")
    }
    
    @IBAction func finishTyping(_ sender: Any) {
        MySocket.instance.socket.emit("sendStatus",0,"")
        print("stop typing")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendBtnPressed(_ sender: UIButton) {
        TextStack.isHidden = true
        VoiceStack.isHidden = false
        AudioServicesPlayAlertSound(1004)
        
        MySocket.instance.socket.emit("sendMessage",0,messageTextView.text!)
        messageTextView.text = ""
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMessages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let size = CGSize(width: 250, height:1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: "self.messageText").boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)], context: nil)
        let messeage = self.listMessages[indexPath.row]
        if messeage.senderID == "user" {
            
            if messeage.messageType == "0" {
                // text
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellUser", for: indexPath) as! Message
                cell.userTextBubbleView.frame.size.width = estimatedFrame.width
                cell.userTextBubbleView.layer.cornerRadius = 15
                cell.userTextBubbleView.layer.masksToBounds = true
                cell.userMessageTextView.text = messeage.senderText
                cell.time.text = messeage.dateTime ?? "now"
                return cell
            }
                // image
                else if messeage.messageType == "2" {
                    // image
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellUserImage", for: indexPath) as! Message
                    cell.userTextBubbleView.layer.cornerRadius = 15
                    cell.userTextBubbleView.layer.masksToBounds = true
                    cell.messageImage.image = messeage.image
                if messeage.senderImage != ""{
                    if let urlPath = messeage.senderImage{
                        print(urlPath)
                        let messeagePhoto = URL(string:"\(urlPath)")!
                        cell.messageImage.sd_setImage(with: messeagePhoto)
                        cell.loading.isHidden = true
                    }
                }
                    cell.time.text = messeage.dateTime ?? "now"
                    return cell
                }else{
                // voice
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellUserVoice", for: indexPath) as! Message
                cell.userTextBubbleView.frame.size.width = estimatedFrame.width
                cell.userTextBubbleView.layer.cornerRadius = 15
                cell.userTextBubbleView.layer.masksToBounds = true
                cell.soundURL = messeage.senderVoice!
                cell.time.text = messeage.dateTime ?? "now"
                return cell
            }
        }else{
            if messeage.messageType == "0" {
                // text
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellSender", for: indexPath) as! Message
                cell.senderTextBubbleView.layer.cornerRadius = 15
                cell.senderTextBubbleView.layer.masksToBounds = true
                cell.senderMessageTextView.text = messeage.senderText
                if let urlDriverPath = SAVEDORDER.imgPath{
                    let messeagePhoto = URL(string:"\(urlDriverPath)")!
                    cell.driverImage.sd_setImage(with: messeagePhoto)
                    self.tableView.reloadData()
                    
                }
                cell.time.text = messeage.dateTime
                return cell
            }
            else if messeage.messageType == "2" {
                // image
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellSenderImage", for: indexPath) as! Message
                cell.senderTextBubbleView.layer.cornerRadius = 15
                cell.senderTextBubbleView.layer.masksToBounds = true
                if let urlDriverPath = SAVEDORDER.imgPath{
                    let messeagePhoto = URL(string:"\(urlDriverPath)")!
                    cell.driverImage.sd_setImage(with: messeagePhoto)
                }
                if messeage.senderImage != ""{

                if let urlPath = messeage.senderImage{
                    let messeagePhoto = URL(string:"\(urlPath)")!
                    cell.messageImage.sd_setImage(with: messeagePhoto)
                }
                }
                cell.time.text = messeage.dateTime ?? ""
                cell.loading.isHidden = true
                return cell
            }else{
                // voice
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellSenderVoice", for: indexPath) as! Message
                cell.senderTextBubbleView.layer.cornerRadius = 15
                cell.senderTextBubbleView.layer.masksToBounds = true
                cell.soundURL = messeage.senderVoice!
                if let urlDriverPath = SAVEDORDER.imgPath{
                    let messeagePhoto = URL(string:"\(urlDriverPath)")!
                    cell.driverImage.sd_setImage(with: messeagePhoto)
                }
                print(messeage.senderVoice!)
                cell.time.text = messeage.dateTime ?? "now"
                return cell
            }
        }
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        var popUpTilte : String!
        var galleryTitle : String!
        var cameraTitle : String!
        var cancelTitle : String!
        
        if Bundle.main.preferredLocalizations.first == "en"{
            popUpTilte = "please select"
            galleryTitle = "gallery"
            cameraTitle = "camera"
            cancelTitle = "cancel"
        }
        else{
            popUpTilte = "من فضلك إختار المصدر"
            galleryTitle = "الصور"
            cameraTitle = "الكاميرا"
            cancelTitle = "إلغاء"
        }
        
        actionSheet = UIAlertController(title: nil, message: popUpTilte, preferredStyle: UIAlertControllerStyle.actionSheet)
        let galleryAction = UIAlertAction(title: galleryTitle, style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        
        let cameraAction = UIAlertAction(title: cameraTitle, style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        
        let cancelAction = UIAlertAction(title:cancelTitle, style: UIAlertActionStyle.cancel, handler: {
            (alert: UIAlertAction) -> Void in
        })
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(galleryAction)
        actionSheet.addAction(cameraAction)
        actionSheet.popoverPresentationController?.sourceView = self.view
        
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: sender.center.x , y: sender.center.y , width: 1.0, height: 1.0)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        if info[UIImagePickerControllerEditedImage] != nil {
            self.image.image = info[UIImagePickerControllerEditedImage] as? UIImage
            self.imageString = (self.image.image?.base64(format: .png))!
        }else {
            self.image.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            self.imageString = (self.image.image?.base64(format: .png))!
        }
        let message = Chat()
        message.senderID = "user"
        message.messageType = "2"
        WebServices.instance.uploadImage(image: self.image.image!) { (path) in
            if let urlPath = path{
                let messeagePhoto = URL(string:"\(urlPath)")!
                // self.tableView.reloadData()
                // self.listMessages.append(message)
                MySocket.instance.socket.emit("sendMessage",2,urlPath)
            }
        }
        message.image = self.image.image
    }
    @IBAction func generatebillbtn(_ sender: Any) {
        if check == 1 {
            if imagecheck == #imageLiteral(resourceName: "39278305_1918283741551461_6097608977581867008_n") {
                self.performSegue(withIdentifier: "billl", sender: nil)
            }else{
                let alert = UIAlertController(title: "Attention".localized, message: "Youmustrecievedorderfrommarket".localized, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK".localized, style: .cancel, handler: { action in
                    switch action.style{
                    case .default:
                        print("default")
                        
                    case .cancel:
                        print("cancel")
                        
                    case .destructive:
                        print("destructive")
                    }}))
                self.present(alert, animated: true, completion: nil)
                
            }
            
        }else if check == 2 {
            let alert = UIAlertController(title: "Attention".localized, message: "You created a bill".localized, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK".localized, style: .cancel, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                }}))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func sendVoice(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        recorderView = storyboard.instantiateViewController(withIdentifier: "RecorderViewController") as! RecorderViewController
        recorderView.delegate = self
        recorderView.createRecorder()
        recorderView.modalTransitionStyle = .crossDissolve
        recorderView.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(recorderView, animated: true, completion: nil)
        self.recorderView.startRecording()
    }
    
    internal func didFinishRecording(_ recorderViewController: RecorderViewController) {
        
        print(recorderView.recording.url)
        let message = Chat()
        message.senderID = "user"
        message.messageType = "1"
        WebServices.instance.uploadVoice(fileLink: recorderView.recording.url) { (status,url) in
            if status {
                message.senderVoice = url!
                self.tableView.reloadData()
                var socketio:SocketIOClient
                socketio = self.socketmanager.defaultSocket
                MySocket.instance.socket.emit("sendMessage",1,url!)
            }
            //        file = recorderView.recording.url
        }
    }
    func playSound() {
        guard let url = Bundle.main.url(forResource: "ring", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else { return }
            
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    func pausesound() {
        guard let url = Bundle.main.url(forResource: "ring", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else { return }
            
            player.pause()
            player.stop()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func call(_ sender: Any) {
        
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
}



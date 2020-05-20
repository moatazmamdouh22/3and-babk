//
//  SettingsChatViewController.swift
//  DriverRequest
//
//  Created by MacBook on 5/28/18.
//  Copyright © 2018 Technosaab. All rights reserved.
//

//  Copyright © 2017 basem. All rights reserved.
//

import UIKit

class SettingsChatViewController: BaseViewController , UITableViewDataSource , UITableViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate ,RecorderViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextView: UITextField!
    @IBOutlet weak var sendbtn: UILabel!
    
    @IBOutlet weak var TextStack: UIStackView!
    @IBOutlet weak var VoiceStack: UIStackView!
    var image = UIImageView()
    var imageString :String?
    var actionSheet: UIAlertController!
    let messageText = "testetetetetetetetetete"
    var recorderView: RecorderViewController!
    var listMessages:[Chat] = []
    
    
    @IBAction func whileEdit(_ sender: Any) {
        if messageTextView.text! != "" {
            VoiceStack.isHidden = true
            TextStack.isHidden = false
        }else{
            VoiceStack.isHidden = false
            TextStack.isHidden = true
        }
    }
    override func viewDidLoad() {
        print("id",UserDefaults.standard.value(forKey: "id") as! String)
        super.viewDidLoad()
        sendbtn.text = "send".localized
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        TextStack.isHidden = true
        WebServices.instance.getUserChat { (status) in
            self.listMessages = status
            self.tableView.reloadData()
        }
    }
    
    @IBAction func sendBtnPressed(_ sender: UIButton) {
        TextStack.isHidden = true
        VoiceStack.isHidden = false
        sender.isEnabled = false
        WebServices.instance.sendToCustomer(message: self.messageTextView.text!, messageType: "0", completion: { (status) in
            if status {
                let message = Chat()
                message.senderID = "user"
                message.messageType = "0"
                message.senderText =  self.messageTextView.text!
                self.listMessages.append(message)
                self.tableView.reloadData()
                self.messageTextView.text = "";
            }
            sender.isEnabled = true
        })
        
    }
    @IBAction func RefreshBtnPressed(_ sender: UIButton) {
        WebServices.instance.getUserChat { (status) in
            self.listMessages = status
            self.tableView.reloadData()
        }
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
        let estimatedFrame = NSString(string: self.messageText).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)], context: nil)
        let messeage = self.listMessages[indexPath.row]
        if messeage.senderID == "user" {
            
            if messeage.messageType == "0" {
                // text
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellUser", for: indexPath) as! Message
                cell.userTextBubbleView.frame.size.width = estimatedFrame.width
                cell.userTextBubbleView.layer.cornerRadius = 15
                cell.userTextBubbleView.layer.masksToBounds = true
                cell.userMessageTextView.text = messeage.senderText
                return cell
            }else if messeage.messageType == "1" {
                // image
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellUserImage", for: indexPath) as! Message
                cell.userTextBubbleView.layer.cornerRadius = 15
                cell.userTextBubbleView.layer.masksToBounds = true
                if messeage.senderImage == nil{
                    cell.messageImage.image = messeage.image
                    WebServices.instance.uploadImage(image: self.image.image!) { (path) in
                        WebServices.instance.sendToCustomer(message: path!, messageType: "1", completion: { (status) in
                            cell.loading.isHidden = true
                        })
                    }
                }else{
                    
                    if let urlPath = messeage.senderImage{
                        let messeagePhoto = URL(string:"\(urlPath)")!
                        cell.messageImage.sd_setImage(with: messeagePhoto)
                        cell.loading.isHidden = true
                    }
                    
                }
                return cell
            }else{
                // voice
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellUserVoice", for: indexPath) as! Message
                cell.userTextBubbleView.frame.size.width = estimatedFrame.width
                cell.userTextBubbleView.layer.cornerRadius = 15
                cell.userTextBubbleView.layer.masksToBounds = true
                cell.soundURL = messeage.senderVoice!
                return cell
            }
            
        }else{
            
            if messeage.messageType == "0" {
                // text
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellSender", for: indexPath) as! Message
                cell.senderTextBubbleView.layer.cornerRadius = 15
                cell.senderTextBubbleView.layer.masksToBounds = true
                cell.senderMessageTextView.text = messeage.senderText
                return cell
            }else if messeage.messageType == "1" {
                // image
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellSenderImage", for: indexPath) as! Message
                cell.senderTextBubbleView.layer.cornerRadius = 15
                cell.senderTextBubbleView.layer.masksToBounds = true
                if let urlPath = messeage.senderImage{
                    let messeagePhoto = URL(string:"\(urlPath)")!
                    cell.messageImage.sd_setImage(with: messeagePhoto)
                }
                return cell
            }else{
                // voice
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellSenderVoice", for: indexPath) as! Message
                cell.senderTextBubbleView.layer.cornerRadius = 15
                cell.senderTextBubbleView.layer.masksToBounds = true
                //                cell.soundURL = "http://ia800208.us.archive.org/22/items/TvQuran.com__Athkar/TvQuran.com_athkar_03.mp3"
                print(messeage.senderVoice!)
                return cell
            }
            
        }
        
        
    }
    @IBAction func addImage(_ sender: UIButton) {
        var   popUpTilte : String!
        var   galleryTitle : String!
        var  cameraTitle : String!
        var cancelTitle : String!
        
        if Bundle.main.preferredLocalizations.first == "en"{
            popUpTilte = "please select"
            galleryTitle = "gallery"
            cameraTitle = "camera"
            cancelTitle = "cancel"
        }else{
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
        message.senderID = (UserDefaults.standard.value(forKey: "id") as! String)
        message.messageType = "1"
        message.image = self.image.image
        self.listMessages.append(message)
        WebServices.instance.uploadImage(image: self.image.image!) { (path) in
            message.senderImage = path
            self.listMessages.append(message)
            self.tableView.reloadData()
            WebServices.instance.sendToCustomer(message: path!, messageType: "1", completion: { (status) in
                self.tableView.reloadData()
            })
        }
        //        self.tableView.reloadData()
        
    }
    @IBAction func closechat(_ sender: Any) {
        messageTextView.text = ""
        TextStack.isHidden = true
        VoiceStack.isHidden = false
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
        message.senderID = (UserDefaults.standard.value(forKey: "id") as! String)
        message.messageType = "2"
        WebServices.instance.uploadVoice(fileLink: recorderView.recording.url) { (status,url) in
            if status {
                message.senderVoice = url!
                self.listMessages.append(message)
                self.tableView.reloadData()
                WebServices.instance.sendToCustomer(message: url!, messageType: "2", completion: { (status) in
                    self.tableView.reloadData()

                })
            }else{
            }
        }
        //        file = recorderView.recording.url
    }
    /*
     // MARK: - Navigation
     cell.messageImage.sd_setImage(with: messeagePhoto)
     WebServicesManager.instance.sendToCustomer(message: path!, messageType: "1", completion: { (status) in
     if status {
     //                        cell.loading.isHidden = true }
     
     }
     
     })
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


//
//  DetailsPopupVC.swift
//  DriverRequest
//
//  Created by MacBook on 4/26/18.
//  Copyright © 2018 Technosaab. All rights reserved.
//

import UIKit
import AVFoundation
import PKHUD
class DetailsPopupVC: UIViewController {

    @IBOutlet weak var orderDetails: UILabel!
    @IBOutlet weak var playerSlider: UISlider!
    @IBOutlet weak var durLabel: UILabel!
    @IBOutlet weak var curLabel: UILabel!
    @IBOutlet weak var PlayAll: UIButton!
    
    @IBOutlet weak var showImage: UIButton!
    var player: AVPlayer!
    var playerItem: AVPlayerItem!
    var playerLayer:AVPlayerLayer?
    var playStaus = true
    var fileUrl : URL!
    let id = UserDefaults.standard.value(forKey: "RequestID") as! String

    @IBOutlet weak var ViewDisappear: UIView!
    @IBOutlet weak var imagesrc: UIImageView!
    
    @IBAction func Cancel(_ sender: Any) {
        ViewDisappear.isHidden = true
    }
    
    @IBAction func show(_ sender: Any) {
        ViewDisappear.isHidden = false
    }
    override func viewDidLoad() {
        self.playerSlider.isHidden = true
        self.PlayAll.isHidden = true
        self.showImage.isHidden = true

        HUD.show(.progress)
        WebServices.instance.getRequistByID(id: id, completion: { (order) in
            HUD.hide()
            if let url = order.audioPath, url != "" {
                self.playerSlider.isHidden = false
                self.PlayAll.isHidden = false
                self.showImage.isHidden = false
                self.fileUrl = URL(string: url)
                self.playerItem = AVPlayerItem(url: self.fileUrl)
                self.player = AVPlayer(playerItem: self.playerItem)
                self.orderDetails.text = order.item
            }else{
                self.playerSlider.isHidden = true
                self.PlayAll.isHidden = true
                self.showImage.isHidden = true
                self.orderDetails.text = order.item
                print(order.item!)
            }
            if let url = order.imgPath, url != "" {
                let x = URL(string:"\(url)")!
                self.imagesrc.sd_setImage(with: x)
                print(url)
            }
        })
        playerSlider.setThumbImage(UIImage(named: "Oval"), for: .normal)
        
        ViewDisappear.isHidden = true
        
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func playAllAction(_ sender: Any) {
        
        if playStaus {
            self.PlayAll.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
            playStaus = false
            setPlayer()
        }else{
            stopVoice()
        }
        
        
    }
    
    func setPlayer(){
        player.play()
        playerLayer=AVPlayerLayer(player: player!)
        playerLayer?.frame=CGRect(x: 0, y: 0, width: 10, height: 50)
        self.view.layer.addSublayer(playerLayer!)
        let duration : CMTime = playerItem.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
        
        let mySecs = Int(seconds) % 60
        let myMins = Int(seconds / 60)
        
        let myTimes = String(myMins) + ":" + String(mySecs);
        self.durLabel.isHidden = false
        self.durLabel.text = myTimes;
        playerSlider!.maximumValue = Float(seconds)
        playerSlider!.isContinuous = true
        playerSlider!.tintColor = UIColor.green
        
        playerSlider?.addTarget(self, action: #selector(self.playbackSliderValueChanged(_:)), for: .valueChanged)
        
        
        //subroutine used to keep track of current location of time in audio file
        player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if self.player!.currentItem?.status == .readyToPlay {
                let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
                
                let myMins2 = Int(time / 60)
                let mySecs2 = Int(time) % 60
                let myTimes2 = String(myMins2) + ":" + String(mySecs2);
                self.curLabel.isHidden  = false
                self.curLabel.text = myTimes2;//current time of audio track
                self.playerSlider!.value = Float ( time );
            }
        }
    }
    
    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider)
    {
        
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        
        player!.seek(to: targetTime)
        
        if player!.rate == 0
        {
            player?.play()
        }
    }
    func stopVoice(){
        
        player.pause()
        self.PlayAll.setImage(#imageLiteral(resourceName: "icons8-pause-button-50"), for: .normal)
        playStaus = true
        durLabel.isHidden = true
        curLabel.isHidden = true
        player?.seek(to: CMTimeMake(0, 1))
        
        
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


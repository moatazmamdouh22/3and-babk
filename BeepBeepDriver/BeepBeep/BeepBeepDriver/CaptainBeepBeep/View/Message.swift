//
//  Message.swift
//  DriverRequest
//
//  Created by MacBook on 4/29/18.
//  Copyright © 2018 Technosaab. All rights reserved.
//

import UIKit
import AVFoundation
class Message: UITableViewCell {
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var driverImage: UIImageView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var userMessageTextView: UITextView!
    @IBOutlet weak var userTextBubbleView: UIView!
    @IBOutlet weak var senderMessageTextView: UITextView!
    @IBOutlet weak var senderTextBubbleView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var messageImage: UIImageView!

    
    var playerLayer:AVPlayerLayer?
    var soundURL = "http://104.131.8.69:7000/uploadFiles/upload_9beeeeaa584777dc7f1cf78eb31c40f0.3gp"
    var playStaus = true
    var fileUrl : URL!
    var player: AVPlayer!
    var playerItem: AVPlayerItem!
    
    
    
    
    @IBAction func playAllAction(_ sender: Any) {
        if playStaus {
            self.playButton.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
            playStaus = false
            setPlayer()
        }else{
            stopVoice()
        }
    }
    
    func setPlayer(){
        fileUrl = URL(string: soundURL)
        playerItem = AVPlayerItem(url: fileUrl)
        player = AVPlayer(playerItem: playerItem)
        player.play()
        playerLayer=AVPlayerLayer(player: player!)
        playerLayer?.frame=CGRect(x: 0, y: 0, width: 10, height: 50)
        self.contentView.layer.addSublayer(playerLayer!)
        let duration : CMTime = playerItem.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
        
        let mySecs = Int(seconds) % 60
        let myMins = Int(seconds / 60)
        
        
        slider!.maximumValue = Float(seconds)
        slider!.isContinuous = true
        slider!.tintColor = UIColor.green
        
        slider?.addTarget(self, action: #selector(self.playbackSliderValueChanged(_:)), for: .valueChanged)
        
        
        //subroutine used to keep track of current location of time in audio file
        player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if self.player!.currentItem?.status == .readyToPlay {
                let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
                
                let myMins2 = Int(time / 60)
                let mySecs2 = Int(time) % 60
                let myTimes2 = String(myMins2) + ":" + String(mySecs2);
                
                self.slider!.value = Float ( time );
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
        self.playButton.setImage(#imageLiteral(resourceName: "icons8-pause-button-50"), for: .normal)
        playStaus = true
        player?.seek(to: CMTimeMake(0, 1))
        
    }
}


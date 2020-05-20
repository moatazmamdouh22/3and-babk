//
//  homeVC.swift
//  DriverRequest
//
//  Created by MacBook on 4/12/18.
//  Copyright © 2018 Technosaab. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON
import SocketIO
import AVFoundation
class homeVC: BaseViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var tabbarbtn: UIBarButtonItem!
    @IBOutlet weak var reqgo: UIButton!
    @IBOutlet weak var continueBtn: UIButton!
//    let socketmanager = SocketManager(socketURL: URL(string: "http://104.131.8.69:7000")!)
    var lang = 0.0
    var lat = 0.0
    var isConnected = false
    let marker = GMSMarker()
    var mLocation:CLLocationCoordinate2D = CLLocationCoordinate2D()
    let driverID = UserDefaults.standard.value(forKey: "id") as! String
    var player: AVAudioPlayer?
    
    //To handle current location
    let locationManager = CLLocationManager()
    
    let requestID = UserDefaults.standard.value(forKey: "RequestID") as? String
    
    @IBAction func request_go(_ sender: Any) {
        
        if(!isConnected){
            
            isConnected = true
            locationManager.stopUpdatingLocation()
            tabbarbtn.title = "Available".localized
            
            //tabbarbtn.tintColor = UIColor(hexString:"ffffff")
            tabbarbtn.tintColor = UIColor.green
            //     locationManager.stopUpdatingLocation()
//            var socketio:SocketIOClient
//            socketio = socketmanager.defaultSocket
            //   socketio.emit("joinSocket",driverID,mLocation.longitude,mLocation.latitude)
            MySocket.instance.socket.emit("joinSocket",driverID,mLocation.longitude,mLocation.latitude)
            self.lat = mLocation.latitude
            self.lang = mLocation.longitude
//            print(socketio.emit("joinSocket",driverID,mLocation.longitude,mLocation.latitude))
            print("socket",mLocation.longitude)
            print("socket",mLocation.latitude)
            
        }else {
            isConnected = false
            tabbarbtn.title = "Outofservice".localized
            tabbarbtn.tintColor = UIColor(hexString:"ffffff")
//            var socketio:SocketIOClient
//            socketio = socketmanager.defaultSocket
            MySocket.instance.socket.emit("leaveSocket")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dist = segue.destination as? RequestResVC {
            dist.lang = lang
            dist.lat = lat
        }
        if let dist = segue.destination as? ChatDriverVC {
            dist.lang = lang
            dist.lat = lat
        }
    }
    override func viewWillAppear(_ animated: Bool) {
           if UserDefaults.standard.value(forKey: "RequestID") as? String != "" {
            continueBtn.isHidden = false
            //tabbarbtn.title = "Available".localized
            //tabbarbtn.tintColor = UIColor.green
            //reqgo.isUserInteractionEnabled = false
         }
           else {
            continueBtn.isHidden = true
            continueBtn.isUserInteractionEnabled = false
            //reqgo.isUserInteractionEnabled = true
        }
    }
    @IBAction func `continue`(_ sender: Any) {
        self.performSegue(withIdentifier: "REQUESTIDCONTINE", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.value(forKey: "RequestID") as? String == nil {
            continueBtn.alpha = 0
            continueBtn.isUserInteractionEnabled = false
        }
        continueBtn.setTitle("continue".localized, for: .normal)
        self.navigationItem.title = "home".localized
        reqgo.setTitle("RequestGo".localized, for: .normal)
        print("Driver ID",driverID)
        print("longit",mLocation.longitude)
        print("latit",mLocation.latitude)
        tabbarbtn.title = "Outofservice".localized
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startMonitoringSignificantLocationChanges()
        self.locationManager.startUpdatingLocation()
        mapView.delegate = self
        //   var socketio:SocketIOClient
        //  socketio = socketmanager.defaultSocket
        MySocket.instance.socket.on("getRequest"){data, ack in
            let RequestID = data
            let RequestObj = RequestID[0] as! NSDictionary
            print(RequestObj["requestID"]!)
            let ReqID = RequestObj["requestID"]!
            UserDefaults.standard.set(ReqID, forKey: "RequestID")
            self.performSegue(withIdentifier: "request", sender: nil)
        }
        MySocket.instance.socket.on(clientEvent: .connect) {data, ack in
            print(data)
            print("socket connected")
            print("MMM")
        }
        MySocket.instance.socket.connect()
    }
    //Fires when the user Allow/Doesn't allow the permission of getting the current location
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    //Get the user location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 17, bearing: 0, viewingAngle: 0)
            mLocation = location.coordinate
            marker.position = CLLocationCoordinate2D(latitude: mLocation.latitude, longitude: mLocation.longitude)
            let rect = CGRect(x: 0, y: 0, width: 150, height: 150)
            UIGraphicsBeginImageContext(rect.size)
            #imageLiteral(resourceName: "BEEB LOC").draw(in: rect)
            let picture1: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            marker.icon = picture1
            marker.map = mapView
            //locationManager.stopUpdatingLocation()
//            var socketio:SocketIOClient
//            socketio = socketmanager.defaultSocket
            MySocket.instance.socket.emit("sendLocation",mLocation.latitude,mLocation.longitude)
            print("newloc",mLocation.latitude)
            print("newloc",mLocation.longitude)
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
}

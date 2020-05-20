//
//  RequestResVC.swift
//  DriverRequest
//
//  Created by MacBook on 4/15/18.
//  Copyright © 2018 Technosaab. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON
import PKHUD
import SocketIO
import AVFoundation

class RequestResVC: BaseViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var yourplace: UILabel!
    @IBOutlet weak var marketplace: UILabel!
    @IBOutlet weak var ordercost: UILabel!
    @IBOutlet weak var ordertime: UILabel!
    @IBOutlet weak var orderdate: UILabel!
    @IBOutlet weak var counter: UILabel!
    @IBOutlet weak var newReq: UILabel!
    @IBOutlet weak var couponnumber: UILabel!
    @IBOutlet weak var rejectlabel: UIButton!
    @IBOutlet weak var aceeptlabel: UIButton!
    @IBOutlet weak var couponnumberlabel: UILabel!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var ordertimelabel: UILabel!
    @IBOutlet weak var ordercostlabel: UILabel!
    @IBOutlet weak var yourplacelabel: UILabel!
    @IBOutlet weak var marketplacelabel: UILabel!
    @IBOutlet weak var clientplacelabel: UILabel!
    @IBOutlet weak var clientplace: UILabel!
//    let socketmanager = SocketManager(socketURL: URL(string: "http://46.101.212.87:7000")!)
    var player: AVAudioPlayer?
    var timer = 19
    var order = Order()
    var timerTest : Timer?
    var userId = ""
    var destination: CLLocation!
    let id = UserDefaults.standard.value(forKey: "RequestID") as! String
    let DriverID = UserDefaults.standard.value(forKey: "id") as! String
    let userimg =  UserDefaults.standard.value(forKey: "personalImg") as! String
    var lat = 0.0
    var lang = 0.0
    //To handle current location
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        MySocket.instance.socket.on("requestCanceled", callback: { (data, ack) in
            self.playSound()
            let alert = UIAlertController(title: "Attention".localized, message: "Request Cancled !!".localized, preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    self.pausesound()
                    UserDefaults.standard.removeObject(forKey: "true")
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

        self.playSound()
//        var socketio:SocketIOClient
//        socketio = socketmanager.defaultSocket
//        socketio.on(clientEvent: .connect) {data, ack in
//            print(data)
//            print("socket connected")
//            print("MMM")
//        }
//        socketio.connect()
        newReq.text = "newrequest".localized
        clientplacelabel.text = "clientplace".localized
        yourplacelabel.text = "yourplace".localized
        marketplacelabel.text = "marketplace".localized
        ordercostlabel.text = "ordercost".localized
        ordertimelabel.text = "ordertime".localized
        couponnumberlabel.text = "couponnumber".localized
        aceeptlabel.setTitle("Accept".localized, for: .normal)
        rejectlabel.setTitle("reject".localized, for: .normal)
        HUD.show(.progress)
        MySocket.instance.connect()
        self.order = SAVEDORDER
        WebServices.instance.getRequistByID(id: id, completion: { (order) in
            HUD.hide()
            print("---------------")
            self.ordercost.text = order.cost
            self.marketplace.text = order.marketName
            self.ordertime.text = getDateFromString(order.createdAt!,formatString: "h:mm a")
            self.orderdate.text = getDateFromString(order.createdAt!,formatString: "MM/dd/yyyy")
            self.userId = order.userID!
            self.destination = CLLocation(latitude: order.marketAut!, longitude: order.marketLng!)
            let camera = GMSCameraPosition.camera(withLatitude: order.marketAut!, longitude: order.marketLng!, zoom: 10.0)
            self.mapView.camera = camera
            self.setMarker(lat: order.userAut!, lng: order.userLng!)
            let userlang = order.userLng
            let useraut = order.userAut
            let ceo: CLGeocoder = CLGeocoder()
            let loc: CLLocation = CLLocation(latitude:useraut!, longitude: userlang!)
            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    let pm = placemarks! as [CLPlacemark]
                    
                    if pm.count > 0 {
                        let pm = placemarks![0]
                        self.clientplace.text = pm.subLocality!
                        UserDefaults.standard.set(pm.subLocality, forKey: "delplace")
                        var addressString : String = ""
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }
                        print("addressString",addressString)
                    }
            })
            
        })
        let backButton = UIBarButtonItem(title: "", style: .plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        timerTest = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(RequestResVC.countDown), userInfo: nil, repeats: true)
        listenOnChat()
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
            //Setup the map camera
            UserDefaults.standard.set(location.coordinate.latitude, forKey: "CurrentLatitude")
            UserDefaults.standard.set(location.coordinate.longitude, forKey: "CurrentLonitude")
            let ceo: CLGeocoder = CLGeocoder()
            let loc: CLLocation = CLLocation(latitude:location.coordinate.latitude, longitude: location.coordinate.longitude)
            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    let pm = placemarks! as [CLPlacemark]
                    
                    if pm.count > 0 {
                        let pm = placemarks![0]
                        self.yourplace.text = pm.subLocality!
                        
                        var addressString : String = ""
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }
                        
                        print("addressString",addressString)
                    }
            })

        }
    }

    @objc func countDown(){
        if timer > 0 {
            timer = timer - 1
            self.counter.text = "\(timer)"
        }
        else if timer == 0{
//            var socketio:SocketIOClient
//            socketio = socketmanager.defaultSocket
            self.timer = -1
            MySocket.instance.socket.emit("rejectRequest",self.id)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func acceptrequest(_ sender: Any) {
        WebServices.instance.ordermohamed( requestID: id) { (status,error)  in
            if status{
                print(self.DriverID)
                print(self.id)
                print(status)
                self.pausesound()
                self.timerTest?.invalidate()
                self.timerTest = nil
                print(self.id,self.userimg,1,self.userId)

//                var socketio:SocketIOClient
//                socketio = self.socketmanager.defaultSocket
                MySocket.instance.socket.emit("joinSocket",self.DriverID,self.lang,self.lat)
                MySocket.instance.socket.emit("addUserToRoom",self.id,self.userimg,1,self.userId)
                MySocket.instance.socket.emit("acceptRequest",self.id)
                self.performSegue(withIdentifier: "acceptrequest", sender: nil)
            }else if error == ""{
                print("FUCK THAT")
            }
        }
    }
    @IBAction func rejectrequest(_ sender: Any) {
        self.pausesound()
//        var socketio:SocketIOClient
//        MySocket.instance.socket = socketmanager.defaultSocket
        MySocket.instance.socket.emit("rejectRequest",self.id)
        self.timer = -1
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setMarker(lat: Double , lng: Double){
        mapView.clear()
        let source = CLLocation(latitude: lat, longitude: lng)
        
        print(self.destination,"1")
        drawPath(startLocation: source , endLocation: self.destination)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
//        marker.icon = #imageLiteral(resourceName: "logo 2-40@1x")
//        marker.title = title
//        marker.map = mapView
        let rect = CGRect(x: 0, y: 0, width: 60, height: 60)
        UIGraphicsBeginImageContext(rect.size)
        #imageLiteral(resourceName: "BEEB LOC").draw(in: rect)
        let picture1: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        marker.icon = picture1
        marker.title = title
        marker.map = mapView
        let destination = GMSMarker()
        destination.position = CLLocationCoordinate2D(latitude: self.destination.coordinate.latitude  , longitude: self.destination.coordinate.longitude)
        destination.icon = #imageLiteral(resourceName: "house")
        destination.title = "The Destination"
        destination.map = mapView
    }

    func drawPath(startLocation: CLLocation, endLocation: CLLocation)
    {
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
        
        Alamofire.request(url).responseJSON { response in
            print(response.request as Any)  // original URL request
            print(response.response as Any) // HTTP URL response
            print(response.data as Any)     // server data
            print(response.result as Any)   // result of response serialization
            
            let json = JSON(response.data!)
            let routes = json["routes"].arrayValue
            
            // print route using Polyline
            for route in routes
            {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 4
                polyline.strokeColor = UIColor.red
                polyline.map = self.mapView
            }
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

    func listenOnChat(){
//        var socketio:SocketIOClient
//        socketio = socketmanager.defaultSocket

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
                }else if status == 2  {
                    // image
                    let message = Chat()
                    message.senderID = "driver"
                    message.messageType = "1"
                    message.senderImage = json![0]["message"].stringValue
                }else if status == 1  {
                    // recored
                    let message = Chat()
                    message.senderID = "driver"
                    message.messageType = "2"
                    message.senderVoice = json![0]["message"].stringValue
                }
            }
        })
    }
}

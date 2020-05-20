 //  Webservice.swift
//  DriverRequest
//
//  Created by MacBook on 4/16/18.
//  Copyright © 2018 Technosaab. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class WebServices {
    
    static let instance = WebServices()
//Models
    func getModels(){
        APPMODELS = []
        Alamofire.request(APIKeys().GET_MODELS, method: .get ,encoding:URLEncoding(), headers: nil).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value).arrayValue
                print("-->APPMODELS",json)
                for models in json {
                    let singleModel = Models()
                    singleModel.id = models["_id"].stringValue
                    singleModel.titleAR = models["TitleAR"].stringValue
                    singleModel.titleEN = models["TitleEN"].stringValue
                    APPMODELS.append(singleModel)
                }
            case .failure(let error):
       // print(response.response!)
                print(error)
            }
        }
    }
//Country
    func getCountry()
    {
        APPCOUNTRY = []
        Alamofire.request(APIKeys().GET_COUNTRY, method: .get , encoding: URLEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value).arrayValue
                print("-->APPCOUNTRY",json)
                for country in json {
                    let singleCountry = Country()
                    singleCountry.id = country["_id"].stringValue
                    singleCountry.titleAR = country["titleAR"].stringValue
                    singleCountry.titleEN = country["titleEN"].stringValue
                    APPCOUNTRY.append(singleCountry)
                }
            case .failure(let error):
                print(response.response)
                print(error)
            }
        }
    }
    // MARK: - SEND TO CUSTOMER
    
    func sendToCustomer(message: String,messageType: String ,completion: @escaping (_ status: Bool) -> ())
    {
        let SenderID = UserDefaults.standard.value(forKey: "id") as! String
        let parameters = ["message":message, "messageType":messageType,"reciverID":SenderID,"SenderID":SenderID,"userType":0] as [String : Any]
        Alamofire.request(APIKeys().customerServices, method: .post ,parameters: parameters,  encoding: URLEncoding.default).validate().responseJSON { response in
            // // print(response.debugDescription)
            print("--Parameters", parameters)
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                completion(true)
            case .failure(let error):
                print(error)
                
            }
        }
    }
    // MARK: - GET USER CHAT
    
    func getUserChat(completion: @escaping (_ chat: [Chat]) -> ())
    {
        let SenderID = UserDefaults.standard.value(forKey: "id") as! String
        let parameters = ["id":SenderID]
        Alamofire.request(APIKeys().getCustomerServices, method: .get ,parameters: parameters,  encoding: URLEncoding.default).validate().responseJSON { response in
            print("--Parameters", parameters)
            switch response.result {
            case .success(let value):
                let json = JSON(value).arrayValue
                var schat : [Chat] = []
                for item in json{
                    let chat = Chat()
                    chat.messageType = item["type"].stringValue
                    
                    chat.dateTime = getDateFromString(item["dateTime"].stringValue,formatString: "h:mm a") + getDateFromString(item["dateTime"].stringValue,formatString: "MM/dd")
                    if item["type"].stringValue == "0" {
                        // text
                        chat.senderText = item["message"].stringValue
                    }else if item["type"].stringValue == "1"  {
                        // image
                        chat.senderImage = item["message"].stringValue
                    } else if item["type"].stringValue == "2" {
                        // voice
                        chat.senderVoice = item["message"].stringValue
                    }
                    
                    if item["username"].stringValue != "user"{
                        chat.senderID = "user"
                    }else{
                        chat.senderID = "customer"
                    }
                    
                    schat.append(chat)
                }
                print(json)
                completion(schat)
            case .failure(let error):
                print(error)
                
            }
        }
    }
    // All Orders
    func allfuckinOrders(completion: @escaping (_ status: [Orders]) -> ())
    {
        let SenderID = UserDefaults.standard.value(forKey: "id") as! String
        Alamofire.request("\(APIKeys().AllOrder)?driverID=\(SenderID)", method: .get ,  encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value).arrayValue
                print(json)
                var Notificat: [Orders] = []
                print("-->ALL-ORDERS",json)
                for notify in json {
                    let single = Orders()
                    single._id = notify["_id"].stringValue
                    single.createdAt = notify["createdAt"].stringValue
                    single.cost = notify["cost"].stringValue
                    single.distance = notify["distance"].stringValue
                    single.fees = notify["fees"].stringValue
                     single.marketName = notify["marketName"].stringValue
                    single.userAut = notify["userAut"].stringValue
                    single.userLng = notify["marketName"].stringValue

                    Notificat.append(single)
                }
                completion(Notificat)
                
            case .failure(let error):
                print(error)
                completion([])
                
            }
        }
    }

    
    
    // request number
    func requestnumber(completion: @escaping (_ number:String) -> ())
    {
        let DriverID = UserDefaults.standard.value(forKey: "id") as! String
        Alamofire.request("\(APIKeys().totalDriverOrders)?id=\(DriverID)", method: .get ,  encoding: URLEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(APIKeys().currentCredit)
                print(json)
                let number = json["message"].stringValue
                completion(number)
            case .failure(let _):
                completion("")
            }
        }
    }
    // banking transfer
    func bankingtransfer(imgPath:String,bankName:String,value:String,accountNumber:String,description:String,userID:String,completion: @escaping (_ status: Bool, _ error: String) -> ()){
        let parameters = ["imgPath":imgPath,"bankName":bankName,"value":value,"accountNumber":accountNumber,"description":description,"userID":userID] as [String : Any]
        Alamofire.request(APIKeys().bankTransfer, method: .post ,parameters:parameters, encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value).arrayValue
                print(parameters)
                print(json)
                completion(true,"")
            case .failure(let error):
                print(error)
                completion(false,"")
            }
        }
    }
// current credit
    func currentCredit(completion: @escaping (_ fees:Double) -> ())
    {
        let DriverID = UserDefaults.standard.value(forKey: "id") as! String
        Alamofire.request("\(APIKeys().currentCredit)?id=\(DriverID)", method: .get ,  encoding: URLEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(APIKeys().currentCredit)
                print(json)
                let fees = json["fees"].doubleValue
                completion(fees)
            case .failure(let _):
                completion(0.00)
            }
        }
    }
    // Add driver order
    func DriverOrdernumbertwo(DriverID: String,requestID:String, completion: @escaping (_ status: Bool) -> ())
    {
        Alamofire.request("\(APIKeys().ADDUSERORDER)?id=\(requestID)&driverID=\(DriverID)", method: .get ,  encoding: URLEncoding.default,headers: nil).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value).stringValue
                print(json)
                print(response.response!)
                print(response.result)
                completion(true)
            case .failure(let _):
                completion(false)
            }

        }
    }
    func DriverOrder(requestID:String,completion: @escaping (_ Status: Bool,_ error :String) -> ())
    {
        let DriverID = UserDefaults.standard.value(forKey: "id") as! String
        let parameters = ["driverID":DriverID,"id":requestID]

        Alamofire.request(APIKeys().ADDUSERORDER, method: .get ,parameters:parameters,  encoding: URLEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                completion(true,"")
            case .failure(let error):
                let json = JSON(error)
                print(error)
                completion(false,"")
            }
        }
    }
    // How it works
    func HowItWorks(completion: @escaping (_ video: String,_ error :String) -> ())
    {
        Alamofire.request(APIKeys().HOWITWORKS, method: .get ,  encoding: URLEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let video = json["value"].stringValue
                print(video)
                completion(video,"")
            case .failure(let error):
                let json = JSON(error)
                print(error)
                completion("","")
            }
        }
    }
    // driverLimitFees
    func DriverFees(completion: @escaping (_ Driverfees:Double) -> ())
    {
        let DriverID = UserDefaults.standard.value(forKey: "id") as! String
        Alamofire.request("\(APIKeys().driverLimitFees)?id=\(DriverID)", method: .get ,  encoding: URLEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("\(APIKeys().driverLimitFees)?id=\(DriverID)")
                print(json)
                let limitFees = json["limitFees"].doubleValue
                completion(limitFees)
            case .failure(let _):
                completion(0.00)
            }
        }
    }
    // Pay Credit
    func paynow(cardNum:String,id:String,completion: @escaping (_ status: Bool, _ error: String) -> ()){
        let parameters = ["cardNum":cardNum,"id":id] as [String : Any]
        Alamofire.request(APIKeys().paynow, method: .get ,parameters:parameters, encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value).arrayValue
                print(parameters)
                print(json)
                completion(true,"")
            case .failure(let error):
                print(error)
                completion(false,"")
            }
        }
    }
    // Driver Amount
    func DriverAmount(completion: @escaping (_ Driverfees:String) -> ())
    {
        let DriverID = UserDefaults.standard.value(forKey: "id") as! String
        Alamofire.request("\(APIKeys().totalDriverOrdersFeesA)?id=\(DriverID)", method: .get ,  encoding: URLEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("\(APIKeys().totalDriverOrdersFeesA)?id=\(DriverID)")
                print(json)
                let DriverfeesA = json["message"].stringValue
                completion(DriverfeesA)
            case .failure(let _):
                completion("")
            }
        }
    }

    
//Cities
    func getCities(id: String,  completion: @escaping (_ status: Bool, _ error: String) -> ()){
        APPCITY = []
        let params = ["id":id]
        Alamofire.request(APIKeys().GET_CITIES, method: .get ,parameters: params , encoding:URLEncoding(), headers: nil).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value).arrayValue
                print(APIKeys().GET_CITIES)
                print(response.response!)
                print("-->APPCITIES",json)
                for city in json {
                    let singleCity = City()
                    singleCity.id = city["_id"].stringValue
                    singleCity.titleAR = city["titleAR"].stringValue
                    singleCity.titleEN = city["titleEN"].stringValue
                    APPCITY.append(singleCity)
                }
            case .failure(let error):
                print(response.response!)
                print(error)
            }
        }
    }
//upload Image
    typealias CompletionHandler = (_ success:Bool,_ response:Any? ,_ error:String?) -> Void
    class func uploadThumbnail(thumbnail:UIImage ,completionHandler: @escaping CompletionHandler)  {
        
        let imageData:Data = UIImageJPEGRepresentation(thumbnail, 0.2)!
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        let result = formatter.string(from: date)
        let URL = try! URLRequest(url: APIKeys().UPLOAD_FILE, method: .post, headers: nil)
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "file", fileName: "\(result).jpg", mimeType: "image/jpg")
        },
            with: URL ,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        let dataString = String(data: response.data!, encoding: String.Encoding.utf8)
                        completionHandler(response.response?.statusCode == 200 ,dataString as Any,nil)
                        }
                        .uploadProgress { progress in
                            print("Upload Progress: \(progress.fractionCompleted * 100)")
                    }
                    break
                case .failure(let encodingError):
                    completionHandler(false ,encodingError,encodingError.localizedDescription)
                    break
                }
        })
    }
    // order eftkasst mohamed
    func ordermohamed(requestID: String , completion: @escaping (_ status: Bool , _ error: String) -> ())
    {
        let DriverID = UserDefaults.standard.value(forKey: "id") as! String
        let url = "\(APIKeys().ORDERPUTEFTKSTMOHAMED)\(requestID)"
        let parameters = ["driverID":DriverID]
        Alamofire.request(url, method: .put ,parameters: parameters,  encoding: URLEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("-->Order",json)
                completion(true, "")
            case .failure(let error):
                print(error)
                completion(false, "")
            }
        }
    }

    // UPDATE Driver EMAIL
    func updateEmail(email: String , completion: @escaping (_ status: Bool , _ error: String) -> ())
    {
        let DriverID = UserDefaults.standard.value(forKey: "id")
        let url = "\(APIKeys().DRIVER_UPDATE)\(DriverID!)"
        let parameters = ["email":email]
        Alamofire.request(url, method: .put ,parameters: parameters,  encoding: URLEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("-->USER",json)
                if json["message"].stringValue == "sorry is email exsist" {
                    completion(false, "")
                }else{
                    completion(true, "")
                    let email = json["email"].stringValue
                    UserDefaults.standard.set(email, forKey: "email")
                }
                let email = json["email"].stringValue
                UserDefaults.standard.set(email, forKey: "email")
                completion(true, "")
            case .failure(let error):
                print(error)
                completion(false, "")
            }
        }
    }
    // MARK: - UPDATE Driver MOBILE
    func updateMobile(mobile: String , completion: @escaping (_ status: Bool , _ error: String) -> ())
    {
        let DriverID = UserDefaults.standard.value(forKey: "id")
        let url = "\(APIKeys().DRIVER_UPDATE)\(DriverID!)"
        let parameters = ["mobile":mobile]
        Alamofire.request(url, method: .put ,parameters: parameters,  encoding: URLEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("-->USER",json)
                if json["message"].stringValue == "sorry is mobile exsist" {
                    completion(false, "")
                }else{
                    completion(true, "")
                    let mobile = json["mobile"].stringValue
                    UserDefaults.standard.set(mobile, forKey: "mobile")
                }
                let mobile = json["mobile"].stringValue
                UserDefaults.standard.set(mobile, forKey: "mobile")
                completion(true, "")
            case .failure(let error):
                print(error)
                completion(false, "")
            }
        }
    }
    /*
     Alamofire.request(APIKeys().REQUESTS_ORDER, method: .get ,parameters: ["id":ReqID], encoding:URLEncoding(), headers: nil).responseJSON { (response) in
     switch response.result {
     case .success(let value):
     let json = JSON(value).arrayValue
     print("-->ORDERS",json)
     var userOrders: [Order] = []
     
     for item in json {
     let singleOrder = Order()
     singleOrder._id = item["_id"].stringValue
     if let image = item["imgPath"].string{
     singleOrder.imgPath = image
     }
     if let audio =  item["audioPath"].string{
     singleOrder.audioPath = audio
     }
     singleOrder.updatedAt = item["updatedAt"].stringValue
     singleOrder.createdAt = item["createdAt"].stringValue
     singleOrder.item = item["item"].stringValue
     singleOrder.marketAut = item["marketAut"].doubleValue
     singleOrder.marketLng = item["marketLng"].doubleValue
     singleOrder.marketName = item["marketName"].stringValue
     singleOrder.userAut = item["userAut"].doubleValue
     singleOrder.userLng = item["userLng"].doubleValue
     singleOrder.rate = item["rate"].doubleValue
     singleOrder.fess = item["fess"].stringValue
     singleOrder.status = item["status"].stringValue
     singleOrder.cost = item["cost"].stringValue
     userOrders.append(singleOrder)
     print("User Order",userOrders)
     }
     
     case .failure(let error):
     print(error)
     print("ERROR")
     }
     }
     */
 //Request byId
    func getRequistByID(id: String,completion: @escaping (_ order: Order) -> ())
    {
        
        Alamofire.request(APIKeys().REQUESTS_ORDER, method: .get ,parameters: ["id":id],  encoding: URLEncoding.default).validate().responseJSON { response in
            // // print(response.debugDescription)
            switch response.result {
            case .success(let value):
                let json = JSON(value).arrayValue
                print(json)
                for item in json {
                    let singleOrder = Order()
                    singleOrder._id = item["_id"].stringValue
                    if let image = item["imgPath"].string{
                        singleOrder.imgPath = image
                    }
                    if let audio =  item["audioPath"].string{
                        singleOrder.audioPath = audio
                    }
                    if let userID  = item["userID"].dictionary{
                        if let fullname = userID["fullname"]?.string {  singleOrder.username = fullname}
                         if let usermobile = userID["mobile"]?.string {  singleOrder.usermobile = usermobile}
                        if let usID = userID["_id"]?.string {  singleOrder.userID = usID}
                    }
                    if let DriverID  = item["driverID"].dictionary{
                        if let fullname = DriverID["fullname"]?.string {  singleOrder.drivername = fullname}
                        if let Driverimg = DriverID["identityImg"]?.string {  singleOrder.driverimg = Driverimg}
                    }

                    singleOrder.updatedAt = item["updatedAt"].stringValue
                    singleOrder.createdAt = item["createdAt"].stringValue
                    singleOrder.item = item["item"].stringValue
                    singleOrder.marketAut = item["marketAut"].doubleValue
                    singleOrder.marketLng = item["marketLng"].doubleValue
                    singleOrder.marketName = item["marketName"].stringValue
                    singleOrder.userAut = item["userAut"].doubleValue
                    singleOrder.userLng = item["userLng"].doubleValue
                    singleOrder.rate = item["rate"].doubleValue
                    singleOrder.fess = item["fess"].stringValue
                    singleOrder.status = item["status"].stringValue
                    singleOrder.cost = item["cost"].stringValue
                    singleOrder.distance = item["distance"].stringValue
                    completion(singleOrder)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    
 //register
    func register(fullname: String, countryID: String,  cityID: String,  mobile: String,  email: String,  password: String,  nationality: String,  caryear: String,  carmodel: String,  carnumber: String,  carcolor: String,  personalimg: String,  identityimage: String,  drivinglicenseimg: String,  carlicenceimg: String,  carimage: String, completion: @escaping (_ status: Bool , _ error: String) -> ())
    {

        let parameters = ["fullname":fullname,"countryID":countryID,"cityID":cityID,"mobile":mobile,"email":email,"password":password,"Nationality":nationality,"carYear":caryear,"carModel":carmodel,"carNumber":carnumber,"carColor":carcolor,"personalImg":personalimg,"identityImg":identityimage,"drivingLicenseImg":drivinglicenseimg,"carLicenseImg":carlicenceimg,"carImg":carimage]
        print(parameters)
        Alamofire.request(APIKeys().REGISTER_URL, method: .post ,parameters: parameters,  encoding: URLEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("-->USER",json)
                if json["message"].stringValue == "sorry is email exsist" {
                    completion(false, "")
                }else if json["message"].stringValue == "sorry is mobile exsist" {
                    completion(false, "")
                }else{
                    completion(true, "")
                }
            case .failure(let error):
                print(error)
                completion(false, "")
            }
        }
    }
// GET CHAT
    func getRequestChat(requestID: String,completion: @escaping (_ chat: [Chat]) -> ())
    {
        let parameters = ["id":requestID]
        Alamofire.request(APIKeys().getRequestChat, method: .get ,parameters: parameters,  encoding: URLEncoding.default).validate().responseJSON { response in
            // // print(response.debugDescription)
            
            switch response.result {
            case .success(let value):
                let json = JSON(value).arrayValue
                print(json)
                var schat : [Chat] = []
                for item in json{
                    let chat = Chat()
                    chat.messageType = item["type"].stringValue
                    chat.dateTime = getDateFromString(item["dateTime"].stringValue,formatString: "MM/dd h:mm a")
                    if item["type"].stringValue == "0" {
                        // text
                        chat.senderText = item["message"].stringValue
                    }else if item["type"].stringValue == "2"  {
                        // image
                        chat.senderImage = item["message"].stringValue
                    } else if item["type"].stringValue == "1" {
                        // voice
                        chat.senderVoice = item["message"].stringValue
                    }
                    if item["username"].stringValue == "user"{
                        chat.senderID = "user"
                    }else{
                        chat.senderID = "customer"
                    }
                    schat.append(chat)
                }
                print(json)
                completion(schat)
            case .failure(let error):
                print(error)
                
            }
        }
    }
// UPDATE LOCATION
    func updateLocation(countryID: String,cityID: String , completion: @escaping (_ status: Bool) -> ())
    {
        let DriverID = UserDefaults.standard.value(forKey: "id")
        let url = "\(APIKeys().DRIVER_UPDATE)\(DriverID!)"
        let parameters = ["countryID":countryID,"cityID":cityID]
        Alamofire.request(url, method: .put ,parameters: parameters,  encoding: URLEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("-->USER",json)
                if let Country  = json["countryID"].dictionary{
                    let titleEN = Country["titleEN"]?.string
                    UserDefaults.standard.set(titleEN, forKey: "Country")
                }
                if let City  = json["cityID"].dictionary{
                    UserDefaults.standard.set(City, forKey: "CityID")
                    let titleEN = City["titleEN"]?.string
                    UserDefaults.standard.set(titleEN, forKey: "City")
                }

                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
// REVIWERS
    func saidAboutDriver(completion: @escaping ([Reviews]) -> ())
    {
        let DriverID = UserDefaults.standard.value(forKey: "id")
        let url = "\(APIKeys().SAIDABOUTDRIVER)?driverID=\(DriverID!)"
        Alamofire.request(url, method: .get ,  encoding: URLEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                print(value)
                let json = JSON(value).arrayValue
                var array : [Reviews] = []
                for item in json {
                    let single = Reviews()
                    single.id = item["_id"].stringValue
                    single.rate = item["rate"].doubleValue
                    single.userComment = item["userComment"].stringValue
                    array.append(single)
                }
                completion(array)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // USER NOTIFY
    func usernotify(completion: @escaping ([UserNotify]) -> ())
    {
        let DriverID = UserDefaults.standard.value(forKey: "id")
        let url = "\(APIKeys().usernotify)?id=\(DriverID!)"
        Alamofire.request(url, method: .get ,  encoding: URLEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                print(value)
                let json = JSON(value).arrayValue
                var array : [UserNotify] = []
                for item in json {
                    let single = UserNotify()
                    single.id = item["_id"].stringValue
                    single.msg = item["msg"].stringValue
                    single.title = item["title"].stringValue
                    array.append(single)
                }
                completion(array)
            case .failure(let error):
                print(error)
            }
        }
    }
    

    
// UPDATE PASSWORD
    
    
    func updatePassword(password: String , completion: @escaping (_ status: Bool) -> ())
    {
        let DriverID = UserDefaults.standard.value(forKey: "id")
        let url = "\(APIKeys().DRIVER_UPDATE)\(DriverID!)"
        let parameters = ["password":password]
        Alamofire.request(url, method: .put ,parameters: parameters,  encoding: URLEncoding.default).validate().responseJSON { response in
            // // print(response.debugDescription)
            switch response.result {
            case .success(let value):
                print(value)
                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
// getDriverLimitFees
    func getDriverLimitFees(DriverID: String , completion: @escaping (_ status: Bool) -> ())
    {
        let parameters = ["id":DriverID]
        Alamofire.request(APIKeys().getDriverLimitFees, method: .get ,parameters: parameters,  encoding: URLEncoding.default).validate().responseJSON { response in
            // // print(response.debugDescription)
            switch response.result {
            case .success(let value):
                print(value)
                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    // getDriverFess
    func getDriverFess(DriverID: String , completion: @escaping (_ status: Bool) -> ())
    {
        let parameters = ["id":DriverID]
        Alamofire.request(APIKeys().getDriverFess, method: .get ,parameters: parameters,  encoding: URLEncoding.default).validate().responseJSON { response in
            // // print(response.debugDescription)
            switch response.result {
            case .success(let value):
                print(value)
                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    // getDriverFess
    func totalDriverOrders(DriverID: String , completion: @escaping (_ status: Bool) -> ())
    {
        let parameters = ["id":DriverID]
        Alamofire.request(APIKeys().totalDriverOrders, method: .get ,parameters: parameters,  encoding: URLEncoding.default).validate().responseJSON { response in
            // // print(response.debugDescription)
            switch response.result {
            case .success(let value):
                print(value)
                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    // totalDriverOrderCoupon
    func totalDriverOrderCoupon(DriverID: String , completion: @escaping (_ status: Bool) -> ())
    {
        let parameters = ["id":DriverID]
        Alamofire.request(APIKeys().totalDriverOrderCoupon, method: .get ,parameters: parameters,  encoding: URLEncoding.default).validate().responseJSON { response in
            // // print(response.debugDescription)
            switch response.result {
            case .success(let value):
                print(value)
                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    // totalDriverOrderCoupon
    func totalDriverOrderFess(DriverID: String , completion: @escaping (_ status: Bool) -> ())
    {
        let parameters = ["id":DriverID]
        Alamofire.request(APIKeys().totalDriverOrderFess, method: .get ,parameters: parameters,  encoding: URLEncoding.default).validate().responseJSON { response in
            // // print(response.debugDescription)
            switch response.result {
            case .success(let value):
                print(value)
                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }

//Get Terms
    func getTerms()
    {
        APPTERMS = []
        Alamofire.request(APIKeys().termsDriver, method: .get ,  encoding: URLEncoding.default).validate().responseJSON { response in
            // // print(response.debugDescription)
            switch response.result {
            case .success(let value):
                let json = JSON(value).arrayValue
                print("-->APPTERMS",json)
                for term in json {
                    let single = AppData()
                    single.id = term["_id"].stringValue
                    single.titleAR = term["titleAR"].stringValue
                    single.titleEN = term["titleEN"].stringValue
                    APPTERMS.append(single)
                }
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
//Get Privacy
    func getPrivacy()
    {
        APPPRIVACY = []
        Alamofire.request(APIKeys().policyDriver, method: .get ,  encoding: URLEncoding.default).validate().responseJSON { response in
            // // print(response.debugDescription)
            switch response.result {
            case .success(let value):
                let json = JSON(value).arrayValue
                print("-->APPPRIVACY",json)
                for data in json {
                    let single = AppData()
                    single.id = data["_id"].stringValue
                    single.titleAR = data["titleAR"].stringValue
                    single.titleEN = data["titleEN"].stringValue
                    APPPRIVACY.append(single)
                }
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
    // MARK: - Get App Email
    func getAppEmail()
    {
        
        Alamofire.request(APIKeys().getEmail, method: .get ,  encoding: URLEncoding.default).validate().responseJSON { response in
            // // print(response.debugDescription)
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                APPEMAIL = json["value"].stringValue
            case .failure(let error):
                print(error)
                
            }
        }
    }
    // MARK: - Get App Email
    func getAppPhone()
    {
        
        Alamofire.request(APIKeys().getPhone, method: .get ,  encoding: URLEncoding.default).validate().responseJSON { response in
            // // print(response.debugDescription)
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                APPPHONE = json["value"].stringValue
            case .failure(let error):
                print(error)
                
            }
        }
    }

//Get About
    func getAbout()
    {
        APPABOUT = []
        Alamofire.request(APIKeys().AboutDriver, method: .get ,  encoding: URLEncoding.default).validate().responseJSON { response in
            // // print(response.debugDescription)
            switch response.result {
            case .success(let value):
                let json = JSON(value).arrayValue
                print("-->APPABOUT",json)
                for data in json {
                    let single = AppData()
                    single.id = data["_id"].stringValue
                    single.titleAR = data["titleAR"].stringValue
                    single.titleEN = data["titleEN"].stringValue
                    APPABOUT.append(single)
                }
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
//upload
    func uploadImage(image: UIImage, completion: @escaping  (String?) -> Void) {
        guard let data = UIImageJPEGRepresentation(image, 0.9) else {
            return
        }
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let imageName = formatter.string(from: date)
        Alamofire.upload(multipartFormData: { (form) in
            form.append(data, withName: "file", fileName: "\(imageName).jpg", mimeType: "image/jpg")
            
        }, to: APIKeys().uploadFile, encodingCompletion: { result in
            switch result {
            case .success(let upload, _, _):
                
                upload.responseString { response in
                    print(response.value!)
                    completion(response.value!)
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
    }
    func uploadVoice(fileLink: URL, completion: @escaping  (_ value: Bool,_ url:String?) -> ()) {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let voiceName = formatter.string(from: date)
        
        Alamofire.upload(multipartFormData: { (form) in
            form.append(fileLink, withName: "file", fileName: "\(voiceName).mp3", mimeType: "audio/wav")
            
        }, to: APIKeys().uploadFile, encodingCompletion: { result in
            switch result {
            case .success(let upload, _, _):
                
                upload.responseString { response in
                    print(response.value!)
                    completion(true,response.value!)
                }
            case .failure(let encodingError):
                print(encodingError)
                completion(false,"")
            }
        })
    }
//login
func login(email: String ,password: String ,  completion: @escaping (_ status: Bool, _ error: String) -> ())
{
    let parameters = ["email":email,"password":password]
    Alamofire.request(APIKeys().LOGIN_URL, method: .get ,parameters: parameters,  encoding: URLEncoding.default).responseJSON { response in
        switch response.result {
        case .success(let value):
            let json = JSON(value)
            print("-->USER",json)
            if json["message"].stringValue == "Authentication failed. User not found." {
                completion(false, "")
            }else if json["message"].stringValue == "Authentication failed. Wrong password." {
                completion(false, "")
            }else if json["message"].stringValue == "this account is suspended !!!" {
                completion(false, "")
            }else{
                let fullname = json["fullname"].stringValue
                let email = json["email"].stringValue
                let id = json["_id"].stringValue
                let mobile = json["mobile"].stringValue
                let password = json["password"].stringValue
                let personalimg = json["personalImg"].stringValue
                UserDefaults.standard.set(fullname, forKey: "fullname")
                UserDefaults.standard.set(email, forKey: "email")
                UserDefaults.standard.set(id, forKey: "id")
                UserDefaults.standard.set(mobile, forKey: "mobile")
                UserDefaults.standard.set(password, forKey: "password")
                UserDefaults.standard.set(personalimg, forKey: "personalImg")
                if let Country  = json["countryID"].dictionary{
                     let titleEN = Country["titleEN"]?.string
                    UserDefaults.standard.set(titleEN, forKey: "Country")
                }
                if let City  = json["cityID"].dictionary{
                    let titleEN = City["titleEN"]?.string
                    UserDefaults.standard.set(titleEN, forKey: "City")
                }
                print(id)
                completion(true,"")
            }
        case .failure(let error):
            print(error)
            print(response.response!)
            completion(false,"")
      }
    }
  }
}

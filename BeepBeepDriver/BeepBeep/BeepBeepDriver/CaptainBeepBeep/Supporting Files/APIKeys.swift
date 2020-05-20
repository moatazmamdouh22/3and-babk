//
//  APIKeys.swift
//  DriverRequest
//
//  Created by MacBook on 4/16/18.
//  Copyright © 2018 Technosaab. All rights reserved.
//

import UIKit

class APIKeys: NSObject {
    var BASE_URL:String {
		return "http://46.101.212.87:7000/api/driver/"
    }
    var BASE_URL_2:String {
		return "http://46.101.212.87:7000/api/app/"
    }
    var baseURLUSER:String {
		return "http://46.101.212.87:7000/api/user/"
    }

    var REGISTER_URL: String { return BASE_URL + "Driver"}
    var LOGIN_URL: String { return BASE_URL_2 + "loginDriver"}
    var GET_COUNTRY: String{return BASE_URL_2 + "GetCountries"}
    var GET_CITIES: String{return BASE_URL_2 + "GetCites"}
    var GET_MODELS: String{return BASE_URL + "getCarModel"}
    var UPLOAD_FILE: String{return BASE_URL_2 + "uploadFile"}
    var DRIVER_UPDATE: String{return BASE_URL_2 + "user/"}
    var REQUESTS_ORDER: String{return BASE_URL + "orderByID"}
    var getRequestChat: String{return BASE_URL_2+"chatHistory"}
    var SAIDABOUTDRIVER: String{return BASE_URL + "saidAboutDriver"}
    var termsDriver: String { return BASE_URL + "termsDriver"}
    var policyDriver: String { return BASE_URL + "policyDriver"}
    var AboutDriver: String { return BASE_URL + "aboutAppDriver"}
    var getEmail: String { return baseURLUSER + "getEmail"}
    var getPhone: String { return baseURLUSER + "getPhone"}
    var getDriverLimitFees: String { return BASE_URL + "getDriverLimitFees"}
    var getDriverFess: String { return BASE_URL + "getDriverFess"}
    var totalDriverOrders: String { return BASE_URL + "totalDriverOrders"}
    var totalDriverOrderCoupon: String { return BASE_URL + "totalDriverOrderCoupon"}
    var totalDriverOrderFess: String { return BASE_URL + "totalDriverOrderFess"}
    var getOrderFees: String {return baseURLUSER + "getOrderFees"}
    var getOrderMinFees: String { return baseURLUSER + "getOrderMinFees"}
    var uploadFile: String { return BASE_URL_2 + "uploadFile"}
    var getCustomerServices: String {return BASE_URL_2 + "GetCustomerServices"}
    var customerServices: String { return BASE_URL_2 + "customerServices"}
    var currentCredit: String { return BASE_URL + "getDriverFees" }
    var driverLimitFees: String { return BASE_URL + "getDriverLimitFees" }
    var totalDriverOrdersFeesA: String { return BASE_URL + "totalDriverOrdersFees" }
    var paynow: String {return BASE_URL + "payCredit"}
    var bankTransfer: String {return BASE_URL + "bankTransfer"}
    var AllOrder: String {return BASE_URL + "order"}
    var usernotify: String {return BASE_URL_2 + "allUserNotify"}
    var ADDUSERORDER: String {return BASE_URL + "addDriverIdToOrder"}
    var ORDERPUTEFTKSTMOHAMED: String {return BASE_URL + "order/"}
    var HOWITWORKS: String {return BASE_URL_2 + "howItWork/"}
}

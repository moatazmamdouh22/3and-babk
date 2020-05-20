//
//  AppDelegate.swift
//  DriverRequest
//
//  Created by MacBook on 3/27/18.
//  Copyright © 2018 Technosaab. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import Firebase
import UserNotifications
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey("AIzaSyC8tl0sYlVjQuPjOKSq724p-1HB5_cUSaI")
        GMSPlacesClient.provideAPIKey("AIzaSyC8tl0sYlVjQuPjOKSq724p-1HB5_cUSaI")
		IQKeyboardManager.shared.enable = true
		FirebaseApp.configure()
		askForNotificaions(application: application)
        return true
    }
	private func askForNotificaions(application: UIApplication)
	{
		// [START set_messaging_delegate]
		Messaging.messaging().delegate = self
		// [END set_messaging_delegate]
		// Register for remote notifications. This shows a permission dialog on first run, to
		// show the dialog at a more appropriate time move this registration accordingly.
		// [START register_for_notifications]
		if #available(iOS 10.0, *) {
			// For iOS 10 display notification (sent via APNS)
			UNUserNotificationCenter.current().delegate = self
			
			let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
			UNUserNotificationCenter.current().requestAuthorization(
				options: authOptions,
				completionHandler: {_, _ in })
		} else {
			let settings: UIUserNotificationSettings =
				UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
			application.registerUserNotificationSettings(settings)
		}
		
		application.registerForRemoteNotifications()
		// [END register_for_notifications]
	}

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
	
	// Receive displayed notifications for iOS 10 devices.
	func userNotificationCenter(_ center: UNUserNotificationCenter,
								willPresent notification: UNNotification,
								withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		let userInfo = notification.request.content.userInfo
		
		print(userInfo)
		
		// Change this to your preferred presentation option
		completionHandler([.alert, .badge, .sound])
		
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter,
								didReceive response: UNNotificationResponse,
								withCompletionHandler completionHandler: @escaping () -> Void) {
		let userInfo = response.notification.request.content.userInfo
		// Print message ID.
		print(userInfo)
		completionHandler()
	}
	
	func notificationsAction(_ userInfo: [AnyHashable : Any]){
		
	}
	func tokenString(_ deviceToken:Data) -> String{
		//code to make a token string
		let bytes = [UInt8](deviceToken)
		var token = ""
		for byte in bytes{
			token += String(format: "%02x",byte)
		}
		return token
	}
}
extension AppDelegate : MessagingDelegate {
	// [START refresh_token]
	func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
		print("Firebase registration token: \(fcmToken)")
		UserDefaults.standard.set(fcmToken, forKey: "FCMToken")
	}
	// [END refresh_token]
	// [START ios_10_data_message]
	// Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
	// To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
	func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
		print("Received data message: \(remoteMessage.appData)")
	}
	// [END ios_10_data_message]
}

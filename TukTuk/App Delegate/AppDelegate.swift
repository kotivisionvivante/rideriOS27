//


import UIKit
import CoreData
import GoogleMaps
import GooglePlaces
import CoreLocation
import IQKeyboardManagerSwift
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
        let gcmMessageIDKey = "gcm.Message_id"
        var nofificationData = [AnyHashable: Any]()
    var window: UIWindow?

    private var mlocationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        manager.distanceFilter = kCLLocationAccuracyBest
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    private var currentLocation: CLLocation?
    var DeviceToken: String = "a1b2c3d4e5f6"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        mlocationManager.delegate = self
        registerForPushNotifications()
        IQKeyboardManager.shared.enable = true
        GMSServices.provideAPIKey(GOOGLEAPIKEY)
        GMSPlacesClient.provideAPIKey(GOOGLEAPIKEY)
        
        if let launchOptions = launchOptions,
            let userInfo = launchOptions[.remoteNotification] as? [AnyHashable: Any]
        {
            // App was launched through a notification, execute some code here...
            Logger.log(message: "didFinishLaunchingWithOptions:\(userInfo)")
            nofificationData = userInfo
        }
        
        
        return true
    }
    
}

//MARK:- Firebase Push Delegate
extension AppDelegate: UNUserNotificationCenterDelegate,MessagingDelegate{
    

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print(fcmToken)
        DeviceToken = fcmToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        
        let userInfo = response.notification.request.content.userInfo
         // Print message ID.
         if let messageID = userInfo[gcmMessageIDKey] {
           print("Message ID: \(messageID)")
         }

         // With swizzling disabled you must let Messaging know about the message, for Analytics
         // Messaging.messaging().appDidReceiveMessage(userInfo)

         // Print full message.
         print("from didReceive response",userInfo)
 
         completionHandler()
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)

        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
          print("Message ID: \(messageID)")
        }

        // Print full message.
        print("from Will Present##",userInfo)
         print("from Will Presentttttttttttttttttttttttttt")

        // Change this to your preferred presentation option
        completionHandler([[.alert, .sound, .badge]])
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
      if let messageID = userInfo["gcmMessageIDKey"] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print("didReceiveRemoteNotification##",userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
      if let messageID = userInfo["gcmMessageIDKey"] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print("didReceiveRemoteNotification##@esc",userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }

    
}

//MARK:- Register Push Notification
extension AppDelegate {
    
    //MARK: - Push Notifications
    
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                print("Permission granted: \(granted)")
                
                guard granted else { return }
                self.getNotificationSettings()
            }
        } else {
            // Fallback on earlier versions
        }
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
    }
    
    func getNotificationSettings() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                print("Notification settings: \(settings)")
                guard settings.authorizationStatus == .authorized else { return }
                DispatchQueue.main.async{
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
}


//MARK:- Location Delegate
extension AppDelegate: CLLocationManagerDelegate {
    //MARK: CLLocationManager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if  locations.count == 0  {
            return
        }
        guard let lastLocation = locations.last else { return }
        currentLocation = lastLocation
        if currentLocation!.coordinate.latitude != 0 {
            CLGeocoder().reverseGeocodeLocation(currentLocation!, completionHandler:{  placemarks, error -> Void in
                if error != nil {
                    return
                }
                guard let placemarks = placemarks else { return }
                if placemarks.count > 0 {
                        guard let countryCode  = placemarks[0].isoCountryCode else { return }
                        guard let locality = placemarks[0].locality else {return}
                        if let filePath = Bundle.main.path(forResource: "countryCodes", ofType: "json") {
                            do {
                                let data = try Data(contentsOf: URL(fileURLWithPath: filePath), options: .mappedIfSafe)
                                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                                guard let totalArray = json as? [[String:String]] else  { return }
                                totalArray.forEach { data in
                                    if let code = data["code"] {
                                        if code == countryCode {
                                            var countryData = [String:String]()
                                            countryData["countrycode"] = data["code"] ?? ""
                                            countryData["countrydialcode"] =  data["dial_code"] ?? ""
                                            countryData["countryname"] =  data["name"] ?? ""
                                            countryData["countycity"] = locality
                                            self.mlocationManager.stopUpdatingLocation()
                                            NotificationCenter.default.post(name:Notification.Name(UPDATE_LOCATION), object:countryData)
                                            return
                                        }
                                    }
                                }
                            } catch let error {
                                print(error.localizedDescription)
                            }
                        }
                    }
                self.mlocationManager.stopUpdatingLocation()
            })
        }
    }
}


extension UIApplication {
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}


class Logger {
    
    static func log(message: Any?) {
        #if DEBUG
        guard let message = message else {return}
        print("DKLogger Printing: \(message)")
        #endif
    }
    
}

//
//  Constants.swift
//  TukTuk
//
//  Created by Harjot Harry on 2/18/20.
//  Copyright © 2020 TukTuk Inc. All rights reserved.
//

import UIKit
import Foundation


///  ///   com.visionvivante.tuktukrider   /// com.flyority.flyority

let APPDELEGATE     = UIApplication.shared.delegate as! AppDelegate
let iPHONE4         = UIScreen.main.bounds.size.height == 480
let iPHONE5         = UIScreen.main.bounds.size.height == 568
let iPHONE6         = UIScreen.main.bounds.size.height == 667
let iPHONE6P        = UIScreen.main.bounds.size.height == 736
let iPHONEX         = UIScreen.main.bounds.size.height == 812
let iPHONEXR        = UIScreen.main.bounds.size.height == 812
let iPHONEXMAX      = UIScreen.main.bounds.size.height == 812
let iPAD            = UIDevice.current.model == "iPad"

let vehicleSize : CGSize = CGSize(width: 24.0, height: 38.0)
var vehicleCurrentSize : CGSize = CGSize(width: 24.0, height: 38.0)
let minimumZoom : Float = 2.0
let maximumZoom : Float = 20.0

//http://server.visionvivante.com:8080/tuktuk_new/public/
// MARK: Project Base URLS
let baseURL = "http://server.visionvivante.com:8080/tuktuk_new/public/api/user/"
//let IMAGE_BASE_URL = "http://server.visionvivante.com:8080/tuktuk_new/public/uploads/"
let IMAGE_BASE_URL = "http://server.visionvivante.com:8080/tuktuk_new/storage/app/"

//MARK:- URL End Point
let kregister_mobile = baseURL + "register-mobile"
let kverify_otp_mobile = baseURL + "verify-mobile"
let kverify_otp_resend = baseURL + "resend"
let kadd_place =  baseURL + "add-destination"
let ksaved_place =  baseURL + "get-saved-places"
let kremove_place = baseURL + "remove-destination"
let kget_services = baseURL + "get-available-services"
let kride_sendRequest = baseURL + "send/request"
let kservice_provider = baseURL + "show/providers"
let kpayment_methods = baseURL + "get-payment-Method-list"
let kdefault_method = baseURL + "set-default-card"
 
/// App Colors
let WHITE_COLOR = UIColor.white
let BLACK_COLOR = UIColor.black
let BG_GREEN_COLOR = UIColor(named: "BackgroundGreen")
let LIGHT_GREEN_COLOR = UIColor(named: "Color_LightGreen")

let UPDATE_LOCATION = "UpdateLocation"

let GOOGLEAPIKEY = "AIzaSyBMkD749sssjsayHE8XILcCVUI8ExXpqHs"

/// Device Type
let DEVICE_TYPE = "ios"


@available(iOS 13.0, *)
let k_WINDOW = UIApplication.shared.connectedScenes
    .filter({$0.activationState == .foregroundActive})
    .map({$0 as? UIWindowScene})
    .compactMap({$0})
    .first?.windows
    .filter({$0.isKeyWindow}).first

// MARK: - UserDefaults Identifiers

let k_UserDef = UserDefaults.standard
let SKIP_TUTORIAL = "Skip_Tutorial"
let USER_DETAILS = "userDetail"
let IS_USER_LOGGED_IN = "isUserLoggedIn"

// MARK: - StoryBoard Identifiers

let SB_LOADER = UIStoryboard(name: "Loader", bundle: nil)
struct SBLOADER {
    let LOADER = "LoaderVC"
}

/// Landing Storyboard
let SB_LANDING = UIStoryboard(name: "Landing", bundle: nil)
struct SBLANDING {
    let PHONEVERIFY = "PhoneVerifyViewController"
    let OTPVERIFICATION = "OTPVerificationViewController"
}

/// Country Code
let SB_COUNTRYCODE = UIStoryboard(name: "CountryCode", bundle: nil)
struct SBCOUNTRYCODE {
    let COUNTRYCODE = "kCountryCodeView"
}

/// Dashboard View
let SB_DASHBOARD = UIStoryboard(name: "Dashboard", bundle: nil)
struct SBDASHBOARD {
    let DASHBOARD_VIEW = "DashboardViewController"
    let SIDEMENU_VIEW = "kLeftMenuView"
}

enum Storyboard:String {
    case Splash = "Splash"
    case Dashboard = "Dashboard"
    case Landing = "Landing"
    case SideMenu = "SideMenu"
}

enum Controller:String {
    case TutorialOneVC = "TutorialOneViewController"
    case TutorialTwoVC = "TutorialSecondViewController"
    case TutorialThreeVC = "TutorialThirdViewController"
    case PhoneVerifyVC = "PhoneVerifyViewController"
    case OtpVerifyVC = "OTPVerificationViewController"
    case DashboardVC = "DashboardViewController"
    case SetupLocationVC = "SetupLocationVC"
    case SearchVC = "SearchViewController"
    case SavedLocationVC = "SavedLocationVC"
    case AddPlaceVC = "AddPlaceVC"
    case AddStopVC = "AddStopVC"
    case AddScheduleVC = "AddScheduleVC"
    case PaymentMethodsVC = "PaymentMethodsVC"
    case LocationUpdateVC = "LocationUpdateVC"
    case FareDetailsVC = "FareDetailsVC"
}

//MARK:- Side Menu Index Handle
var globalSideMenuIndex = -1

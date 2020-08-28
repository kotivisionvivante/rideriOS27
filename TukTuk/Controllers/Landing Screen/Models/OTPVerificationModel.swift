//


import UIKit
import Foundation
import ObjectMapper

struct PhoneVerifyDM : Mappable {
    var status : Bool?
    var data : PhoneVerifyM?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        status <- map["status"]
        data <- map["data"]
    }

}

struct PhoneVerifyM : Mappable {
    var id : Int?
    var first_name : String?
    var last_name : String?
    var payment_mode : String?
    var email : String?
    var gender : String?
    var mobile : String?
    var picture : String?
    var device_token : String?
    var device_id : String?
    var device_type : String?
    var login_by : String?
    var social_unique_id : String?
    var latitude : String?
    var longitude : String?
    var stripe_cust_id : String?
    var status : String?
    var wallet_balance : Int?
    var referral_code : String?
    var rating : String?
    var otp : Int?
    var otp_count : Int?
    var last_otp : String?
    var free_triel_date : String?
    var updated_at : String?
    var access_token : String?
    var currency : String?
    var sos : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        payment_mode <- map["payment_mode"]
        email <- map["email"]
        gender <- map["gender"]
        mobile <- map["mobile"]
        picture <- map["picture"]
        device_token <- map["device_token"]
        device_id <- map["device_id"]
        device_type <- map["device_type"]
        login_by <- map["login_by"]
        social_unique_id <- map["social_unique_id"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        stripe_cust_id <- map["stripe_cust_id"]
        status <- map["status"]
        wallet_balance <- map["wallet_balance"]
        referral_code <- map["referral_code"]
        rating <- map["rating"]
        otp <- map["otp"]
        otp_count <- map["otp_count"]
        last_otp <- map["last_otp"]
        free_triel_date <- map["free_triel_date"]
        updated_at <- map["updated_at"]
        access_token <- map["access_token"]
        currency <- map["currency"]
        sos <- map["sos"]
    }

}

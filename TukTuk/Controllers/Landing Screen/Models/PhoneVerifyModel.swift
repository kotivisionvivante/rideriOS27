//


import UIKit
import Foundation
import ObjectMapper

struct PhoneRegisterDM : Mappable {
    var status : Bool?
    var password : Bool?
    var data : PhoneRegisterM?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        status <- map["status"]
        password <- map["password"]
        data <- map["data"]
    }

}

struct PhoneRegisterM: Mappable {
    var mobile : String?
    var device_type : String?
    var device_token : String?
    var payment_mode : String?
    var referral_code : String?
    var updated_at : String?
    var id : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        mobile <- map["mobile"]
        device_type <- map["device_type"]
        device_token <- map["device_token"]
        payment_mode <- map["payment_mode"]
        referral_code <- map["referral_code"]
        updated_at <- map["updated_at"]
        id <- map["id"]
    }

}

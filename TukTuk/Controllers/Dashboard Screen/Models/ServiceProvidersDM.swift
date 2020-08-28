//

import Foundation
import ObjectMapper

struct ServiceProvidersDM : Mappable {
    var status : Bool?
    var data : [ServiceProvidersM]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        status <- map["status"]
        data <- map["data"]
    }

}


struct ServiceProvidersM : Mappable {
    var id : Int?
    var first_name : String?
    var last_name : String?
    var email : String?
    var gender : String?
    var mobile : String?
    var avatar : String?
    var rating : String?
    var status : String?
    var fleet : Int?
    var latitude : String?
    var longitude : String?
    var otp : Int?
    var otp_count : Int?
    var new_register : Int?
    var last_otp : String?
    var experince : String?
    var bio : String?
    var fun_fact : String?
    var created_at : String?
    var updated_at : String?
    var login_by : String?
    var social_unique_id : String?
    var payment_mode : String?
    var service : ServiceM?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        email <- map["email"]
        gender <- map["gender"]
        mobile <- map["mobile"]
        avatar <- map["avatar"]
        rating <- map["rating"]
        status <- map["status"]
        fleet <- map["fleet"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        otp <- map["otp"]
        otp_count <- map["otp_count"]
        new_register <- map["new_register"]
        last_otp <- map["last_otp"]
        experince <- map["experince"]
        bio <- map["bio"]
        fun_fact <- map["fun_fact"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        login_by <- map["login_by"]
        social_unique_id <- map["social_unique_id"]
        payment_mode <- map["payment_mode"]
        service <- map["service"]
    }

}

struct ServiceM : Mappable {
    var id : Int?
    var provider_id : Int?
    var service_type_id : Int?
    var chassis_number : String?
    var status : String?
    var prime : Int?
    var active_status : Int?
    var service_number : String?
    var service_model : String?
    var service_year : String?
    var service_color : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        provider_id <- map["provider_id"]
        service_type_id <- map["service_type_id"]
        chassis_number <- map["chassis_number"]
        status <- map["status"]
        prime <- map["prime"]
        active_status <- map["active_status"]
        service_number <- map["service_number"]
        service_model <- map["service_model"]
        service_year <- map["service_year"]
        service_color <- map["service_color"]
    }

}

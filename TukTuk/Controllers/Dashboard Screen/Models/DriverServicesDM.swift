//

import Foundation
import ObjectMapper

struct DriverServicesDM : Mappable {
    var status : Bool?
    var total_distance : String?
    var default_payment_mode : String?
    var data : [DriverServicesM]?
    var provider : [ServiceProvidersM]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        status <- map["status"]
        total_distance <- map["total_distance"]
        default_payment_mode <- map["default_payment_mode"]
        data <- map["data"]
        provider <- map["providers"]
    }

}

struct DriverServicesM : Mappable {
    var id : Int?
    var name : String?
    var provider_name : String?
    var image : String?
    var capacity : Int?
    var fixed : Int?
    var price : Int?
    var stop_price : Int?
    var minute : Int?
    var hour : String?
    var night_charges : Int?
    var airport_charges : Int?
    var cancellation_fee : Int?
    var platform_fee : Int?
    var surge : String?
    var distance : Int?
    var calculator : String?
    var description : String?
    var status : Int?
    var arrival_time : String?
    var total_price : AnyObject?
    var drop_off_time : String?
    var fareDetails : [FareDetails]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        name <- map["name"]
        provider_name <- map["provider_name"]
        image <- map["image"]
        capacity <- map["capacity"]
        fixed <- map["fixed"]
        price <- map["price"]
        stop_price <- map["stop_price"]
        minute <- map["minute"]
        hour <- map["hour"]
        night_charges <- map["night_charges"]
        airport_charges <- map["airport_charges"]
        cancellation_fee <- map["cancellation_fee"]
        platform_fee <- map["platform_fee"]
        surge <- map["surge"]
        distance <- map["distance"]
        calculator <- map["calculator"]
        description <- map["description"]
        status <- map["status"]
        arrival_time <- map["arrival_time"]
        total_price <- map["total_price"]
        drop_off_time <- map["drop_off_time"]
        fareDetails <- map["fare_details"]
    }

}

struct FareDetails : Mappable {
    var title : String?
    var value : AnyObject?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        title <- map["title"]
        value <- map["value"]
    }

}

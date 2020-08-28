//


import Foundation
import ObjectMapper

struct AddedPlacesDM : Mappable {
    var status : Bool?
    var places : AddedPlacesM?
    var message : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        status <- map["status"]
        places <- map["places"]
        message <- map["message"]
    }

}

struct AddedPlacesM : Mappable {
    var home : SavedPlacesM?
    var office : SavedPlacesM?
    var saved_places : [SavedPlacesM]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        home <- map["home"]
        office <- map["office"]
        saved_places <- map["saved_places"]
    }

}

struct SavedPlacesM : Mappable {
    var id : Int?
    var user_id : Int?
    var name : String?
    var address : String?
    var latitude : AnyObject?
    var longitude : AnyObject?
    var favourite : String?
    var home : String?
    var type : Int?
    var isDeleted : Int?
    var placeID : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        user_id <- map["user_id"]
        name <- map["name"]
        address <- map["address"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        favourite <- map["favourite"]
        home <- map["home"]
        type <- map["type"]
        isDeleted <- map["IsDeleted"]
        placeID <- map["place_id"]
    }

}

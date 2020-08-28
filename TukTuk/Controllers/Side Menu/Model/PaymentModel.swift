//

import Foundation
import ObjectMapper

struct PaymentModel : Mappable {
    var status : Bool?
    var data : DataPayment?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        status <- map["status"]
        data <- map["data"]
    }

}

struct DataPayment : Mappable {
    var methods : [String]?
    var listOfCards : [ListOfCards]?
    var defaultMethod : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        methods <- map["methods"]
        listOfCards <- map["list-of-cards"]
        defaultMethod <- map["default_payment_mode"]
    }

}

struct ListOfCards : Mappable {
    var id : Int?
    var user_id : Int?
    var card_name : String?
    var card_number : String?
    var brand : String?
    var cvv : String?
    var expity_date : String?
    var is_default : Int?
    var created_at : String?
    var updated_at : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        user_id <- map["user_id"]
        card_name <- map["card_name"]
        card_number <- map["card_number"]
        brand <- map["brand"]
        cvv <- map["cvv"]
        expity_date <- map["expity_date"]
        is_default <- map["is_default"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
    }

}

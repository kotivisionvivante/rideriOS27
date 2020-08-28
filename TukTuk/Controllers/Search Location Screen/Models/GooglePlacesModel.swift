//

import Foundation

class SourceDestinationDM : NSObject, NSCoding {
    
    var sourceLocation: GooglePlacesModel? = nil
    var destinationLocation: GooglePlacesModel? = nil
    var stopLocation: [GooglePlacesModel?]? =  nil
    
    // Normal initializer
    init(sourceLocation: GooglePlacesModel?, destinationLocation: GooglePlacesModel?,stopLocation: [GooglePlacesModel?]?) {
        self.sourceLocation = sourceLocation
        self.destinationLocation = destinationLocation
        self.stopLocation = stopLocation
    }
    
    // MARK: NSCoding
    required convenience init?(coder decoder: NSCoder) {
        guard let sourcePlace = decoder.decodeObject(forKey: "sourceLocation") as? GooglePlacesModel
        else { return nil }
        guard let destinationPlace = decoder.decodeObject(forKey: "destinationLocation") as? GooglePlacesModel
               else { return nil }
        guard let stopPlace = decoder.decodeObject(forKey: "stopLocation") as? [GooglePlacesModel?]
               else { return nil }
        
        self.init(
            sourceLocation: sourcePlace,
            destinationLocation: destinationPlace,
            stopLocation:stopPlace)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.sourceLocation, forKey: "sourceLocation")
        aCoder.encode(self.destinationLocation, forKey: "destinationLocation")
        aCoder.encode(self.stopLocation, forKey: "stopLocation")
    }
}

class GooglePlacesModel : NSObject, NSCoding,Codable {
    
    var primaryPlace: String
    var secondaryPlace: String
    var fullAddress: String
    var placeID: String
    var latitude:Double
    var longitude:Double
    var titleHomeWork : String
    var iconName : String
    var locationId : String
    
    // Normal initializer
    init(primaryPlace: String, secondaryPlace: String,fullAddress: String,placeID: String,latitude:Double,longitude:Double,titleHomeWork:String,iconName:String,locationId:String) {
        self.primaryPlace = primaryPlace
        self.secondaryPlace = secondaryPlace
        self.fullAddress = fullAddress
        self.placeID = placeID
        self.latitude = latitude
        self.longitude = longitude
        self.titleHomeWork = titleHomeWork
        self.iconName = iconName
        self.locationId = locationId
    }
    
    // MARK: NSCoding
    required convenience init?(coder decoder: NSCoder) {
        guard let priPlace = decoder.decodeObject(forKey: "primaryPlace") as? String
        else { return nil }
        guard let secPlace = decoder.decodeObject(forKey: "secondaryPlace") as? String
               else { return nil }
        guard let address = decoder.decodeObject(forKey: "fullAddress") as? String
               else { return nil }
        guard let plaID = decoder.decodeObject(forKey: "placeID") as? String
               else { return nil }
        guard let lat = decoder.decodeObject(forKey: "latitude") as? Double
               else { return nil }
        guard let long = decoder.decodeObject(forKey: "longitude") as? Double
               else { return nil }
        guard let homeWork = decoder.decodeObject(forKey: "titleHomeWork") as? String
                      else { return nil }
        guard let icon = decoder.decodeObject(forKey: "iconName") as? String
                      else { return nil }
        guard let locationId = decoder.decodeObject(forKey: "locationId") as? String
                      else { return nil }
        
        self.init(
            primaryPlace: priPlace,
            secondaryPlace: secPlace,
            fullAddress:address,
            placeID:plaID,
            latitude:lat,
            longitude:long, titleHomeWork: homeWork, iconName: icon, locationId: locationId)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.primaryPlace, forKey: "primaryPlace")
        aCoder.encode(self.secondaryPlace, forKey: "secondaryPlace")
        aCoder.encode(self.fullAddress, forKey: "fullAddress")
        aCoder.encode(self.placeID, forKey: "placeID")
        aCoder.encode(self.latitude, forKey: "latitude")
        aCoder.encode(self.longitude, forKey: "longitude")
        aCoder.encode(self.titleHomeWork, forKey: "titleHomeWork")
        aCoder.encode(self.iconName, forKey: "iconName")
        aCoder.encode(self.locationId, forKey: "locationId")
    }
}

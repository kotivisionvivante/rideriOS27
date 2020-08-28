//

import Foundation
import ObjectMapper
import GooglePlaces

protocol AddedPlacesVMDelegate {
    func addedPlaces(savedPlaceData:AddedPlacesM?)
    func getGoogleSearchResult(arrayPlaces : [GooglePlacesModel])
    func fetchGooglePlaceDetail(searchModel:GooglePlacesModel?)
}

class AddedPlaceVM: NSObject {
    
    //MARK:- Variables
    var delegate:AddedPlacesVMDelegate?
     var placesClient = GMSPlacesClient()
    
    // MARK: Init
     init(delegate:AddedPlacesVMDelegate) {
        self.delegate = delegate
    }
    
}

//MARK:- Custom Methods
extension AddedPlaceVM {
    
    func callWebService(address:String,latitude:String,longitude:String,type:String,favourite:String,
                        name:String,placeID:String) {
        if address.isEmpty {
            showWarningAlertWithTitle(title: "Alert", message: "Please select address.")
        }
        else if name.isEmpty {
            if type == "3" {
                showWarningAlertWithTitle(title: "Alert", message: "Please enter name.")
            }
            else {
                addPlaceApi(address: address, latitude: latitude, longitude: longitude, type: type, favourite: favourite, name: name, placeID: placeID)
            }
        }
        else {
            addPlaceApi(address: address, latitude: latitude, longitude: longitude, type: type, favourite: favourite, name: name, placeID: placeID)
        }
        
    }
}

//MARK:- Service Implementation
extension AddedPlaceVM {
    
    func addPlaceApi(address:String,latitude:String,longitude:String,type:String,
                     favourite:String,name:String,placeID:String) {
        var param = ["address":address,
                     "latitude":latitude,
                     "longitude":longitude,
                     "type":type,
                     "name":name,
                     "place_id":placeID]
        
        if type == "3" {
            param.updateValue(favourite, forKey: "favourite")
        }
        
        ActivityIndicator.shared.showActivityIndicator()
        APIManager.shared.request(url: kadd_place, method: .post, parameters: param, tryAgain: false, completionCallback: { (response) in
            ActivityIndicator.shared.hideActivityIndicator()
        }, success: { (jsonResponse) in
            let data = Mapper<AddedPlacesDM>().map(JSONObject: jsonResponse)
            self.delegate?.addedPlaces(savedPlaceData: data?.places)
            
        }) { (error) in
            self.showWarningAlertWithTitle(title: "Alert!", message: error ?? "")
        }
    }
    
    func getGooglePlacesResult(searchText:String) {
         let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String ?? ""

        let filter = GMSAutocompleteFilter()
        filter.country = countryCode
        placesClient.autocompleteQuery(searchText, bounds: nil, filter: filter) { (results, error) -> Void in
            var arrayPlaces = [GooglePlacesModel]()
            if let error = error {
                print("Autocomplete error \(error)")
            }
            if let results = results {
                for result in results {
                    let placeObject = GooglePlacesModel(primaryPlace: result.attributedPrimaryText.string, secondaryPlace: result.attributedSecondaryText?.string ?? "", fullAddress: result.attributedFullText.string, placeID: result.placeID,latitude: 0.00,longitude: 0.00,titleHomeWork: "",iconName: "", locationId: "")
                    arrayPlaces.append(placeObject)
                }
                self.delegate?.getGoogleSearchResult(arrayPlaces: arrayPlaces)
            }
        }
    }
    
    func fetchPlaceAddress(searchModel:GooglePlacesModel?=nil) {
        
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue) |  UInt(GMSPlaceField.addressComponents.rawValue) |  UInt(GMSPlaceField.formattedAddress.rawValue) | UInt(GMSPlaceField.coordinate.rawValue))!
        
        placesClient.fetchPlace(fromPlaceID:searchModel?.placeID ?? "", placeFields: fields, sessionToken: nil, callback: {
            (place: GMSPlace?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let place = place {
                searchModel?.latitude = place.coordinate.latitude
                searchModel?.longitude = place.coordinate.longitude
                self.delegate?.fetchGooglePlaceDetail(searchModel: searchModel)
            }
        })
    }
}

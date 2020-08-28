//

import UIKit
import GooglePlaces

protocol LocationCellDelegate {
    func savedPlaceLocationCell(savedPlaces:[SavedPlacesM])
}

class LocationCell: UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var labelPrimaryAddress: UILabel!
    @IBOutlet weak var labelSecondaryAddress: UILabel!
    @IBOutlet weak var buttonFavourite: UIButton!
    
    //MARK:-Variables
    var placesClient = GMSPlacesClient()
    var placeVM : AddedPlaceVM? = nil
    var locationDelegate : LocationCellDelegate?
    var placeObject:GooglePlacesModel? {
        didSet {
            labelPrimaryAddress.text = placeObject?.primaryPlace
            labelSecondaryAddress.text = placeObject?.secondaryPlace
        }
    }

    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
          placeVM = AddedPlaceVM(delegate: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

//MARK:- Action
extension LocationCell {
    
    @IBAction func buttonActionFavourite(_ sender: UIButton) {
       
        //        let favourite = sender.isSelected ? "yes" : "no"
        //        fetchPlaceAddress(searchModel: placeObject!, isFavourite: favourite)
        if !sender.isSelected {
             sender.isSelected =  true
            self.placeVM?.callWebService(address: placeObject?.secondaryPlace ?? "", latitude: "\(placeObject?.latitude ?? 0.00)", longitude: "\(placeObject?.longitude ?? 0.00)", type: "3", favourite: "yes",name: placeObject?.primaryPlace ?? "", placeID: placeObject?.placeID ?? "")
        }
        else {
            
        }
    }
}

//MARK:- Google Fetch WS
extension LocationCell {
//    func fetchPlaceAddress(searchModel:GooglePlacesModel,isFavourite:String) {
//
//        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
//            UInt(GMSPlaceField.placeID.rawValue) |  UInt(GMSPlaceField.addressComponents.rawValue) |  UInt(GMSPlaceField.formattedAddress.rawValue) | UInt(GMSPlaceField.coordinate.rawValue))!
//
//        placesClient.fetchPlace(fromPlaceID:searchModel.placeID, placeFields: fields, sessionToken: nil, callback: {
//            (place: GMSPlace?, error: Error?) in
//            if let error = error {
//                print(error.localizedDescription)
//            }
//            if let place = place {
//                self.placeVM?.callWebService(address: searchModel.secondaryPlace, latitude: "\(place.coordinate.latitude)", longitude: "\(place.coordinate.longitude)", type: "3", favourite: isFavourite,name: searchModel.primaryPlace, placeID: searchModel.placeID)
//            }
//
//        })
//    }
}

//MARK:- Added Places Delegate
extension LocationCell:AddedPlacesVMDelegate {
    func fetchGooglePlaceDetail(searchModel: GooglePlacesModel?) {
        
    }
    
    func getGoogleSearchResult(arrayPlaces: [GooglePlacesModel]) {
    }
    
    func addedPlaces(savedPlaceData: AddedPlacesM?) {
        locationDelegate?.savedPlaceLocationCell(savedPlaces: savedPlaceData?.saved_places ?? [])
    }
}

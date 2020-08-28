//

import UIKit

class LocationUpdateVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var tableViewSavedPlace: UITableView!
    
    //MARK:- Properties
    var savedPlacesVM : ListSavedPlacesVM?=nil
    var arrayHomeWorkAddress = [GooglePlacesModel]()
    var addedPlaceModel: AddedPlacesM?
    var removeAddressIndex = -1
    var placeVM : AddedPlaceVM? = nil
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSavedPlace.register(UINib(nibName: "HomeWorkCell", bundle: nil), forCellReuseIdentifier: "HomeWorkCell")
        tableViewSavedPlace.tableFooterView = UIView()
        savedPlacesVM = ListSavedPlacesVM(delegate: self)
        placeVM = AddedPlaceVM(delegate: self)
        savedPlacesVM?.callWebService()
        globalSideMenuIndex = 7
    }
}
//MARK:- Custom Method
extension LocationUpdateVC {
    func setupHomeWorkObject(home:SavedPlacesM?,work:SavedPlacesM?) {
        arrayHomeWorkAddress = [GooglePlacesModel]()
        let homeTitle  = home?.address == "" || home == nil ? "ADD HOME" : "HOME"
        let workTitle  = work?.address == "" || work == nil ? "ADD WORK" : "WORK"
        let homePlace = GooglePlacesModel(primaryPlace: home?.address ?? "", secondaryPlace:  "", fullAddress: "", placeID: home?.placeID ?? "", latitude: home?.latitude as? Double ?? 0.00, longitude: home?.longitude as? Double ?? 0.00, titleHomeWork: homeTitle, iconName: "House_icon", locationId: "\(home?.id ?? 0)")
        let workPlace = GooglePlacesModel(primaryPlace: work?.address ?? "", secondaryPlace:  "", fullAddress: "", placeID: home?.placeID ?? "", latitude: work?.latitude as? Double ?? 0.00, longitude: work?.longitude as? Double ?? 0.00, titleHomeWork: workTitle, iconName: "Work_icon", locationId: "\(work?.id ?? 0)")
        arrayHomeWorkAddress.append(homePlace)
        arrayHomeWorkAddress.append(workPlace)
        tableViewSavedPlace.reloadData()
    }
}

//MARK:- Action
extension LocationUpdateVC {
    @IBAction func buttonActionMenu(_ sender: UIButton) {
        slideMenuController()?.toggleLeft()
    }
}

//MARK:- List Saved Places VM Delegate
extension LocationUpdateVC:ListSavePlacesVMDelegate {
    func removePlace() {
        if removeAddressIndex == 0 {
            addedPlaceModel?.home = nil
        }
        if removeAddressIndex == 1 {
            addedPlaceModel?.office = nil
        }
        setupHomeWorkObject(home: addedPlaceModel?.home, work: addedPlaceModel?.office)
    }
    
    func savedPlaces(savedPlacesData: AddedPlacesM?) {
        addedPlaceModel = savedPlacesData
        setupHomeWorkObject(home: addedPlaceModel?.home, work: addedPlaceModel?.office)
    }
}

//MARK:- Home Work Cell Delegate
extension LocationUpdateVC:HomeWorkCellDelegate {
    func deleteSavedPlace(addressID: String, index: Int) {
        removeAddressIndex = index
        savedPlacesVM?.unFavouritePlace(savedPlaceID: addressID)
    }
}

//MARK:- Search Location Delegate
extension LocationUpdateVC:SearchVCDelegate {
    func selectedLocation(searchModel: GooglePlacesModel,selectedIndex:Int) {
        let latitude = String(format: "%f", searchModel.latitude)
        let longitude = String(format: "%f", searchModel.longitude)
        placeVM?.callWebService(address: searchModel.primaryPlace, latitude: latitude, longitude: longitude, type: String(selectedIndex + 1), favourite: "0",name: "", placeID: searchModel.placeID)
    }
}

//MARK:- Added Places VM Delegate
extension LocationUpdateVC:AddedPlacesVMDelegate {
    func addedPlaces(savedPlaceData: AddedPlacesM?) {
        setupHomeWorkObject(home: savedPlaceData?.home, work: savedPlaceData?.office)
    }
    
    func getGoogleSearchResult(arrayPlaces: [GooglePlacesModel]) {
        
    }
    
    func fetchGooglePlaceDetail(searchModel: GooglePlacesModel?) {
        
    }
}

//


import UIKit

protocol SetupLocationVCDelegate {
    func setupRoute(sourceDestinationM:SourceDestinationDM?,isSavedAndStop:Bool)
    func updateSavedPlaces(addedPlaceModel : AddedPlacesM?)
    func addPickUpLocationThroughMap(selected : String?, isSearch:Bool)
}

class SetupLocationVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var tableViewLoc: UITableView!
    @IBOutlet weak var textFieldPickup: UITextField!
    @IBOutlet weak var textFieldDrop: UITextField!
    
    //MARK:- Variables
    enum LocationType {
        case pickup
        case drop
        case none
    }
    var arrayPlaces = [GooglePlacesModel]()
    var isSearchFinish = true
    var isSearhEmpty = true
    var searchText = ""
    var selectedLocation:LocationType = .none
    var savedPlacesVM : ListSavedPlacesVM?=nil
    var placeVM : AddedPlaceVM? = nil
    var arraySavedPlaces = [SavedPlacesM]()
    var delegate : SetupLocationVCDelegate?
    var locationPickup : GooglePlacesModel? = nil
    var locationDrop : GooglePlacesModel? = nil
    var arrayHomeWorkAddress = [GooglePlacesModel]()
    var removedLocationIndex = -1
    var addedPlaceModel : AddedPlacesM?

    var isMapSearch : Bool?
    var stringLocation : String?
    var stringSelected : String?
    
    //MARK:- View Life Cycle 
    override func viewDidLoad() {
        super.viewDidLoad()
        slideMenuController()?.removeLeftGestures()
        setupTableView()
        textFieldPickup.delegate = self
        textFieldDrop.delegate = self
        placeVM = AddedPlaceVM(delegate: self)
        self.arraySavedPlaces = addedPlaceModel?.saved_places ?? []
        setupHomeWorkObject(home: addedPlaceModel?.home, work: addedPlaceModel?.office)
        if LocationManagerH.sharedInstance.isLocationEnable {
            textFieldPickup.text = LocationManagerH.sharedInstance.currentAddress
            textFieldDrop.becomeFirstResponder()
        }
        else {
            textFieldPickup.becomeFirstResponder()
        }
        setupDownGesture()
        setUpMapLocation()
    }
    
}

//MARK:- Map Pickup
extension SetupLocationVC {
    func setUpMapLocation(){
        if self.isMapSearch! {
            locationPickup = Singleton.shared.sourceFromDragMap
            locationDrop = Singleton.shared.destinationFromDragMap
            self.textFieldPickup.text = locationPickup?.primaryPlace
            self.textFieldDrop.text = locationDrop?.primaryPlace
            
            if self.textFieldDrop.text != "" && self.textFieldPickup.text != "" {
                if locationPickup == nil {
                    let address = LocationManagerH.sharedInstance.currentAddress
                    let latitude = LocationManagerH.sharedInstance.latitude
                    let longitude = LocationManagerH.sharedInstance.longitude
                    self.locationPickup = GooglePlacesModel(primaryPlace: address
                        , secondaryPlace: "", fullAddress: "", placeID: "", latitude: latitude, longitude: longitude, titleHomeWork: "",iconName: "", locationId: "")
                }
                if (self.locationPickup != nil && self.locationDrop != nil) {
                    let sourceDestination = SourceDestinationDM(sourceLocation: self.locationPickup, destinationLocation: self.locationDrop, stopLocation: nil)
                    self.getDrawRouteData(sourceDestinationM:sourceDestination,isSavedAndStop: true)
                    Singleton.shared.sourceFromDragMap = nil
                    Singleton.shared.destinationFromDragMap = nil
                }
            }
            else {
//                if isSavedAndStop {
//                    popViewController()
//                }
            }
        }
    }
    
    func setupDownGesture() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {

        if let swipeGesture = gesture as? UISwipeGestureRecognizer {

            switch swipeGesture.direction {
            case .right:
                print("Swiped right")
            case .down:
                print("Swiped down")
                if self.selectedLocation == .pickup {
                    self.delegate?.addPickUpLocationThroughMap(selected: "pickup", isSearch: true)
                    
                } else if self.selectedLocation == .drop {
                    self.delegate?.addPickUpLocationThroughMap(selected: "drop", isSearch: true)
                }

            case .left:
                print("Swiped left")
            case .up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
}

//MARK:- Custom Methods
extension SetupLocationVC {
    func setupTableView() {
        tableViewLoc.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
        tableViewLoc.register(UINib(nibName: "HomeWorkCell", bundle: nil), forCellReuseIdentifier: "HomeWorkCell")
        tableViewLoc.tableFooterView = UIView()
        tableViewLoc.estimatedRowHeight  = 50
        tableViewLoc.rowHeight = UITableView.automaticDimension
        tableViewLoc.keyboardDismissMode = .onDrag
        tableViewLoc.showsVerticalScrollIndicator = false
        tableViewLoc.showsHorizontalScrollIndicator = false
    }
    
   
    func setupFieldsText(searchModel:GooglePlacesModel?=nil,isSavedAndStop:Bool=false) {
        
        let primaryText =  searchModel?.primaryPlace ?? ""
        if self.selectedLocation == .pickup {
            self.textFieldPickup.text = primaryText
            self.locationPickup = searchModel
            self.textFieldDrop.becomeFirstResponder()
        } else if self.selectedLocation == .drop {
            self.textFieldDrop.text = primaryText
            self.locationDrop = searchModel
        }
        
        if self.textFieldDrop.text != "" && self.textFieldPickup.text != "" {
            if locationPickup == nil {
                let address = LocationManagerH.sharedInstance.currentAddress
                let latitude = LocationManagerH.sharedInstance.latitude
                let longitude = LocationManagerH.sharedInstance.longitude
                self.locationPickup = GooglePlacesModel(primaryPlace: address
                    , secondaryPlace: "", fullAddress: "", placeID: "", latitude: latitude, longitude: longitude, titleHomeWork: "",iconName: "", locationId: "")
            }
            if (self.locationPickup != nil && self.locationDrop != nil) {
                let sourceDestination = SourceDestinationDM(sourceLocation: self.locationPickup, destinationLocation: self.locationDrop, stopLocation: nil)
                self.getDrawRouteData(sourceDestinationM:sourceDestination,isSavedAndStop: isSavedAndStop)
            }
        }
        else {
            if isSavedAndStop {
                popViewController()
            }
        }
    }
    
    func checkFavouriteWithPlaceID(placeID:String) -> Bool {
        var isFavourite = false
        for i in 0..<arraySavedPlaces.count {
            let object = arraySavedPlaces[i]
            if placeID == (object.placeID ?? "") {
                if object.favourite == "yes" {
                    isFavourite = true
                    break
                }
            }
        }
        return isFavourite
    }
    
    func getDrawRouteData(sourceDestinationM:SourceDestinationDM?,isSavedAndStop:Bool) {
        self.delegate?.setupRoute(sourceDestinationM: sourceDestinationM, isSavedAndStop: isSavedAndStop)
    }
    
    func setupHomeWorkObject(home:SavedPlacesM?,work:SavedPlacesM?) {
        arrayHomeWorkAddress = [GooglePlacesModel]()
        let homeTitle  = home?.address == "" || home == nil ? "ADD HOME" : "HOME"
        let workTitle  = work?.address == "" || work == nil ? "ADD WORK" : "WORK"
        let homePlace = GooglePlacesModel(primaryPlace: home?.address ?? "", secondaryPlace:  "", fullAddress: "", placeID: home?.placeID ?? "", latitude: home?.latitude as? Double ?? 0.00, longitude: home?.longitude as? Double ?? 0.00, titleHomeWork: homeTitle, iconName: "House_icon", locationId: "\(home?.id ?? 0)")
        let workPlace = GooglePlacesModel(primaryPlace: work?.address ?? "", secondaryPlace:  "", fullAddress: "", placeID: home?.placeID ?? "", latitude: work?.latitude as? Double ?? 0.00, longitude: work?.longitude as? Double ?? 0.00, titleHomeWork: workTitle, iconName: "Work_icon", locationId: "\(work?.id ?? 0)")
        let savedPlace = GooglePlacesModel(primaryPlace: "", secondaryPlace: "", fullAddress: "", placeID:  "", latitude: 0.00, longitude: 0.00, titleHomeWork: "SAVED PLACES", iconName: "Star_icon", locationId: "")
        arrayHomeWorkAddress.append(homePlace)
        arrayHomeWorkAddress.append(workPlace)
        arrayHomeWorkAddress.append(savedPlace)
        arrayHomeWorkAddress = arrayHomeWorkAddress + UserDefaults.getRecentSearch()
        tableViewLoc.reloadData()
    }
    
    func removedModelObjectHomeWork(index:Int) {
        let title = arrayHomeWorkAddress[index].titleHomeWork
        let iconName = arrayHomeWorkAddress[index].iconName
        let locationObject = GooglePlacesModel(primaryPlace:"", secondaryPlace:  "", fullAddress: "", placeID:  "", latitude:  0.00, longitude:  0.00, titleHomeWork: title, iconName: iconName, locationId:"")
        arrayHomeWorkAddress[index] = locationObject
        tableViewLoc.reloadData()
    }
}


//MARK:- Action
extension SetupLocationVC {
    @IBAction func buttonActionBack(_ sender: UIButton) {
        slideMenuController()?.addLeftGestures()
        self.popViewController()
    }
    
    @IBAction func buttonActionAddStop(_ sender: UIButton) {
        pushVC(storyboard: .Dashboard, viewController: .AddStopVC, animated: true) { (vc) in
            (vc as? AddStopVC)?.stopDelegate = self
        }
    }
}

//MARK:- Search Location Delegate
extension SetupLocationVC:SearchVCDelegate {
    func selectedLocation(searchModel: GooglePlacesModel,selectedIndex:Int) {
        let latitude = String(format: "%f", searchModel.latitude)
        let longitude = String(format: "%f", searchModel.longitude)
        placeVM?.callWebService(address: searchModel.primaryPlace, latitude: latitude, longitude: longitude, type: String(selectedIndex + 1), favourite: "0",name: "", placeID: searchModel.placeID)
    }
}

//MARK:- Added Places VM Delegate
extension SetupLocationVC:AddedPlacesVMDelegate {
    func addedPlaces(savedPlaceData: AddedPlacesM?) {
        setupHomeWorkObject(home: savedPlaceData?.home, work: savedPlaceData?.office)
        addedPlaceModel = savedPlaceData
        delegate?.updateSavedPlaces(addedPlaceModel: addedPlaceModel)
    }
    
    func getGoogleSearchResult(arrayPlaces: [GooglePlacesModel]) {
        self.isSearhEmpty = false
        self.arrayPlaces = arrayPlaces
        self.isSearchFinish = true
        self.tableViewLoc.reloadData()
    }
    
    func fetchGooglePlaceDetail(searchModel: GooglePlacesModel?) {
        
        var recentSearch = UserDefaults.getRecentSearch()
        var placeIDExit = false
        for i in 0..<recentSearch.count {
            let recentObject = recentSearch[i]
            if searchModel?.placeID == recentObject.placeID {
                placeIDExit = true
                break
            }
        }
        if !placeIDExit {
            if recentSearch.count == 5 {
                recentSearch.remove(at: 4)
                arrayHomeWorkAddress.remove(at: 7)
            }
            recentSearch.insert(searchModel!, at: 0)
            arrayHomeWorkAddress.insert(searchModel!, at: 3)
            UserDefaults.saveRecentSearch(arrayRecentSearch: recentSearch)
        }
        
        self.setupFieldsText(searchModel:searchModel)
    }
}

//MARK:- Saved Location VC Delegate
extension SetupLocationVC:SavedLocationVCDelegate {
    func selectedPlace(savedPlace: SavedPlacesM) {
        let savedPlace = GooglePlacesModel(primaryPlace: savedPlace.address ?? "", secondaryPlace:  "", fullAddress: "", placeID: savedPlace.placeID ?? "", latitude: savedPlace.latitude as? Double ?? 0.00, longitude: savedPlace.longitude as? Double ?? 0.00, titleHomeWork: "",iconName: "", locationId: "\(savedPlace.id ?? 0)")
        self.setupFieldsText(searchModel: savedPlace, isSavedAndStop: true)
    }
    
    func updatedSavedPlaces(savedPlaces: [SavedPlacesM]) {
        arraySavedPlaces = savedPlaces
        addedPlaceModel?.saved_places = savedPlaces
        delegate?.updateSavedPlaces(addedPlaceModel: addedPlaceModel)
        tableViewLoc.reloadData()
    }
}

//MARK:- Location Cell Delegate
extension SetupLocationVC:LocationCellDelegate {
    func savedPlaceLocationCell(savedPlaces: [SavedPlacesM]) {
        arraySavedPlaces = savedPlaces
        addedPlaceModel?.saved_places = savedPlaces
        delegate?.updateSavedPlaces(addedPlaceModel: addedPlaceModel)
    }
}

//MARK:- Add Stop Delegate
extension SetupLocationVC:AddStopVCDelegate {
    func selectedStopLocation(sourceDestinationPlace: SourceDestinationDM?) {
        getDrawRouteData(sourceDestinationM: sourceDestinationPlace,isSavedAndStop:true)
    }
}

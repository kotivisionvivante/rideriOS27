//


import UIKit
import GooglePlaces
protocol AddPlaceVCDelegate {
    func savedLocationList(savedLocation:[SavedPlacesM])
}

class AddPlaceVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var textFieldAddress: UITextField!
    @IBOutlet weak var textFieldName: UITextField!
    
    //MARK:- Variables
    
    var predictionPlace : GooglePlacesModel?
    var placeVM : AddedPlaceVM? = nil
    var latitude = String()
    var longitude = String()
    var placeID = String()
    var delegate : AddPlaceVCDelegate?
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFields(searchModel: self.predictionPlace)
        placeVM = AddedPlaceVM(delegate: self)
    }
    
}

//MARK:- Action
extension AddPlaceVC {
    @IBAction func buttonActionBack(_ sender: UIButton) {
        dismissViewController()
    }
    
    @IBAction func buttonActionLocation(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.presentVC(storyboard: .Dashboard, viewController: .SearchVC, animated: true) { (vc) in
                (vc as! SearchViewController).delegate = self
                (vc as! SearchViewController).isHeartHide = true
            }
        }
    }
    
    @IBAction func buttonActionSave(_ sender: UIButton) {
        placeVM?.callWebService(address: textFieldAddress.text ?? "", latitude: latitude, longitude: longitude, type: "3", favourite: "yes",name: textFieldName.text ?? "", placeID: placeID)
    }
}
//MARK:- Custom Methods
extension AddPlaceVC {
    
    func setupFields(searchModel: GooglePlacesModel?) {
        textFieldAddress.text = searchModel?.primaryPlace
        latitude = String(format: "%f", searchModel?.latitude ?? 0.00)
        longitude = String(format: "%f", searchModel?.longitude ?? 0.00)
        placeID = searchModel?.placeID ?? ""
    }
}

//MARK:- Search Location Delegate
extension AddPlaceVC:SearchVCDelegate {
    func selectedLocation(searchModel: GooglePlacesModel,selectedIndex:Int) {
        setupFields(searchModel: searchModel)
    }
}

//MARK:- Added Places VM Delegate
extension AddPlaceVC:AddedPlacesVMDelegate {
    func fetchGooglePlaceDetail(searchModel: GooglePlacesModel?) {
        
    }
    
    func getGoogleSearchResult(arrayPlaces: [GooglePlacesModel]) {
        
    }
    
    func addedPlaces(savedPlaceData: AddedPlacesM?) {
        self.dismissViewController()
        delegate?.savedLocationList(savedLocation: savedPlaceData?.saved_places ?? [])
    }
}

//

import UIKit
import GooglePlaces

protocol SavedLocationVCDelegate {
    func selectedPlace(savedPlace:SavedPlacesM)
    func updatedSavedPlaces(savedPlaces:[SavedPlacesM])
}

class SavedLocationVC: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var tableViewSavedPlaces: UITableView!
    
    //MARK:- Varibales
    var arraySavedPlaces = [SavedPlacesM]()
    var savedLocationDelegate : SavedLocationVCDelegate?
    var savedPlacesVM : ListSavedPlacesVM?=nil
    var removePlaceIndex = -1
   
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        savedPlacesVM = ListSavedPlacesVM(delegate: self)
    }

}

//MARK:- Action
extension SavedLocationVC {
    @IBAction func buttonActionBack(_ sender: UIButton) {
       popViewController()
    }
}
//MARK:- Custom Methods
extension SavedLocationVC {
    func setupTableView() {
        tableViewSavedPlaces.register(UINib(nibName: "SavedPlaceCell", bundle: nil), forCellReuseIdentifier: "SavedPlaceCell")
        tableViewSavedPlaces.tableFooterView = UIView()
        tableViewSavedPlaces.estimatedRowHeight  = 50
        tableViewSavedPlaces.rowHeight = UITableView.automaticDimension
    }
}

//MARK:- Saved Place Cell Delegate
extension SavedLocationVC:SavedPlaceCellDelegate {
    func selectedFavourite(object: SavedPlacesM?, index: Int) {
        removePlaceIndex = index
        savedPlacesVM?.unFavouritePlace(savedPlaceID: String(object?.id ?? 0))
    }

}

//MARK:- Search Location Delegate
extension SavedLocationVC:SearchVCDelegate {
    func selectedLocation(searchModel: GooglePlacesModel,selectedIndex:Int) {
            DispatchQueue.main.async {
                self.presentVC(storyboard: .Dashboard, viewController: .AddPlaceVC, animated: true) { (vc) in
                    (vc as? AddPlaceVC)?.predictionPlace = searchModel
                    (vc as? AddPlaceVC)?.delegate = self
                } 
            }
    }
}
//MARK:- Add Place VC Delegate
extension SavedLocationVC:AddPlaceVCDelegate {
    func savedLocationList(savedLocation: [SavedPlacesM]) {
        arraySavedPlaces = savedLocation
        tableViewSavedPlaces.reloadData()
        savedLocationDelegate?.updatedSavedPlaces(savedPlaces: arraySavedPlaces)
    }
}

//MARK:- List Saved Places VM Delegate
extension SavedLocationVC:ListSavePlacesVMDelegate {
    func savedPlaces(savedPlacesData: AddedPlacesM?) {
        
    }
    
    func removePlace() {
        arraySavedPlaces.remove(at: removePlaceIndex)
        tableViewSavedPlaces.reloadData()
        savedLocationDelegate?.updatedSavedPlaces(savedPlaces: arraySavedPlaces)
    }
}


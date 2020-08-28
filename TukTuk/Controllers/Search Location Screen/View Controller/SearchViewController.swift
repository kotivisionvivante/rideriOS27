//

import UIKit
import GooglePlaces

protocol SearchVCDelegate {
    func selectedLocation(searchModel:GooglePlacesModel,selectedIndex:Int)
}

class SearchViewController: UIViewController {
    
    //MARK:-Outlets
    @IBOutlet weak var tableViewLocation: UITableView!
    @IBOutlet weak var textFieldLocation: UITextField!
    
    //MARK:- Variables
      var placeVM : AddedPlaceVM? = nil
      var arrayPlaces = [GooglePlacesModel]()
      var userDefaults = UserDefaults.standard
    
      var isSearchFinish = true
      var searchText = ""
      var delegate : SearchVCDelegate?
      var homeAndWorkIndex = -1
      var isHeartHide = false

    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        placeVM = AddedPlaceVM(delegate: self)
        textFieldLocation.becomeFirstResponder()
    }

}

//MARK:- Custom Methods
extension SearchViewController {
    func setupTableView() {
        tableViewLocation.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
        tableViewLocation.tableFooterView = UIView()
        tableViewLocation.estimatedRowHeight  = 50
        tableViewLocation.rowHeight = UITableView.automaticDimension
        tableViewLocation.showsHorizontalScrollIndicator = false
        tableViewLocation.showsVerticalScrollIndicator = false
    }
}

//MARK:- Action
extension SearchViewController {
    @IBAction func buttonActionBack(_ sender: UIButton) {
        self.dismissViewController()
    }
}

//MARK:- Added Places VM Delegate
extension SearchViewController:AddedPlacesVMDelegate {
    func addedPlaces(savedPlaceData: AddedPlacesM?) {

    }
    
    func getGoogleSearchResult(arrayPlaces: [GooglePlacesModel]) {
        self.arrayPlaces = arrayPlaces
        self.isSearchFinish = true
        self.tableViewLocation.reloadData()
    }
    
    func fetchGooglePlaceDetail(searchModel: GooglePlacesModel?) {
        self.dismissViewController()
        self.delegate?.selectedLocation(searchModel: searchModel!, selectedIndex: self.homeAndWorkIndex)
    }
}

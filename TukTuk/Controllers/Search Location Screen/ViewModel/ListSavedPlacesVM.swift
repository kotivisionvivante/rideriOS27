//

import Foundation
import ObjectMapper

protocol ListSavePlacesVMDelegate:AnyObject {
    func savedPlaces(savedPlacesData:AddedPlacesM?)
    func removePlace()
}

class ListSavedPlacesVM: NSObject {
    
    //MARK:-Variables
    var delegate:ListSavePlacesVMDelegate?
    
    // MARK: Init
     init(delegate:ListSavePlacesVMDelegate) {
        self.delegate  = delegate
    }
    
}

//MARK:- Custom Methods
extension ListSavedPlacesVM {
    
    func callWebService() {
        getPlaceApi()
    }
}

//MARK:- Service Implementation
extension ListSavedPlacesVM {
    
    func getPlaceApi() {
        ActivityIndicator.shared.showActivityIndicator()
        APIManager.shared.request(url: ksaved_place, method: .get, parameters: nil, tryAgain: false, completionCallback: { (response) in
        ActivityIndicator.shared.hideActivityIndicator()
        }, success: { (jsonResponse) in
            let data = Mapper<AddedPlacesDM>().map(JSONObject: jsonResponse)
            self.delegate?.savedPlaces(savedPlacesData: data?.places)
            
        }) { (error) in
          self.showWarningAlertWithTitle(title: "Alert!", message: error ?? "")
        }
    }
    
    func unFavouritePlace(savedPlaceID:String) {
        let param = ["destination_id":savedPlaceID]
        ActivityIndicator.shared.showActivityIndicator()
        APIManager.shared.request(url: kremove_place, method: .post, parameters: param, tryAgain: false, completionCallback: { (response) in
            ActivityIndicator.shared.hideActivityIndicator()
        }, success: { (jsonResponse) in
            self.delegate?.removePlace()
            
        }) { (error) in
            self.showWarningAlertWithTitle(title: "Alert!", message: error ?? "")
        }
    }
}

//

import Foundation
import UIKit

//MARK:- Tableview Delegate and Datasources
extension SearchViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  arrayPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as? LocationCell
        cell?.placeObject = arrayPlaces[indexPath.row]
        cell?.buttonFavourite.isHidden = isHeartHide
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let object = arrayPlaces[indexPath.row]
        placeVM?.fetchPlaceAddress(searchModel: object)
    }
}

//MARK:- Text Field Delegate
extension SearchViewController:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        searchText =  string.isEmpty ? String(searchText.dropLast()) : "\(textField.text ?? "" )\(string)"
        print(searchText)
        if isSearchFinish {
            isSearchFinish = false
            placeVM?.getGooglePlacesResult(searchText: searchText)
        }
        return true
    }
}

//

import Foundation
import UIKit
import CoreLocation

//MARK:- Tableview Delegate and Datasources
extension SetupLocationVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  isSearhEmpty {
            return arrayHomeWorkAddress.count
        }
        return arrayPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if  isSearhEmpty {
            if indexPath.row < 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeWorkCell") as? HomeWorkCell
                cell?.object = arrayHomeWorkAddress[indexPath.row]
                if indexPath.row == 2 {
                    cell?.accessoryType = .disclosureIndicator
                }
                return cell ?? UITableViewCell()
            }
            else {
                let object = arrayHomeWorkAddress[indexPath.row]
                return reuseCell(isFavouriteHide:false, placeObject: object)
            }
        }
        else {
             let object = arrayPlaces[indexPath.row]
            return reuseCell(isFavouriteHide:true, placeObject: object)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if  isSearhEmpty {
            let placeObject = arrayHomeWorkAddress[indexPath.row]
            if indexPath.row == 0 ||  indexPath.row == 1   {
                DispatchQueue.main.async {
                    if placeObject.primaryPlace == "" {
                        self.presentVC(storyboard: .Dashboard, viewController: .SearchVC, animated: true) { (vc) in
                            (vc as! SearchViewController).delegate = self
                            (vc as! SearchViewController).isHeartHide = true
                            (vc as! SearchViewController).homeAndWorkIndex = indexPath.row
                        }
                    }
                    else {
                        self.setupFieldsText(searchModel: placeObject, isSavedAndStop: false)
                    }
                }
            }
            else if indexPath.row == 2 {
                DispatchQueue.main.async {
                    self.pushVC(storyboard: .Dashboard, viewController: .SavedLocationVC, animated: true) { (vc) in
                        (vc as? SavedLocationVC)?.arraySavedPlaces = self.arraySavedPlaces
                        (vc as? SavedLocationVC)?.savedLocationDelegate = self
                    }
                }
            }
            else {
                self.setupFieldsText(searchModel: placeObject, isSavedAndStop: false)
            }
        } else {
            let object = arrayPlaces[indexPath.row]
            placeVM?.fetchPlaceAddress(searchModel: object)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if  isSearhEmpty {
            return 75
        }
        return UITableView.automaticDimension
    }
    
    func reuseCell(isFavouriteHide:Bool,placeObject:GooglePlacesModel) -> UITableViewCell {
        let cell = tableViewLoc.dequeueReusableCell(withIdentifier: "LocationCell") as? LocationCell
        cell?.locationDelegate = self
        cell?.placeObject = placeObject
        cell?.buttonFavourite.isHidden = isFavouriteHide
        cell?.buttonFavourite.isSelected = false
        cell?.buttonFavourite.isHidden = false
        if checkFavouriteWithPlaceID(placeID: placeObject.placeID) {
            cell?.buttonFavourite.isSelected = true
            cell?.buttonFavourite.isHidden = true
        }
        return cell ?? UITableViewCell()
    }
}

//MARK:- Text Field Delegate
extension SetupLocationVC:UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchText = textField.text ?? ""
        if textField == textFieldPickup {
            selectedLocation = .pickup
        } else if textField == textFieldDrop {
            selectedLocation = .drop
        }
        if textField.text == "" {
            isSearhEmpty = true
            tableViewLoc.reloadData()
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        searchText =  string.isEmpty ? String(searchText.dropLast()) : "\(textField.text ?? "" )\(string)"
        print(searchText)
        
        if searchText.isEmpty {
            isSearhEmpty = true
            tableViewLoc.reloadData()
        }
        else {
            if isSearchFinish {
                isSearchFinish = false
                placeVM?.getGooglePlacesResult(searchText: searchText)
            }
        }
        return true
    }
}

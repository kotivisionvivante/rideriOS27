//


import Foundation
import UIKit

//MARK:- Tableview Delegate and Datsources
extension SavedLocationVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraySavedPlaces.count + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedPlaceCell") as? SavedPlaceCell
        cell?.savedPlaceCellDelegate = self
        if indexPath.row == arraySavedPlaces.count {
            cell?.labelTitle.textColor = UIColor.appBlueColor
            cell?.labelTitle.text = "Add Saved Place"
            cell?.labelDescription.text = "Get your favourite destination fast"
            cell?.buttonFavourite.isHidden = true
        }
        else {
            cell?.buttonFavourite.isHidden = false
            cell?.labelTitle.textColor = UIColor.black
            cell?.index = indexPath.row
            cell?.object = arraySavedPlaces[indexPath.row]
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == arraySavedPlaces.count  {
            DispatchQueue.main.async {
                self.presentVC(storyboard: .Dashboard, viewController: .SearchVC, animated: true) { (vc) in
                    (vc as! SearchViewController).delegate = self
                    (vc as! SearchViewController).isHeartHide = true
                }
            }
        }
        else {
            let object = arraySavedPlaces[indexPath.row]
            savedLocationDelegate?.selectedPlace(savedPlace: object)
        }
    }
}

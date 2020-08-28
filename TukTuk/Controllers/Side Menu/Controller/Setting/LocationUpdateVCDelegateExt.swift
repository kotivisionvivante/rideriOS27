//

import Foundation
import UIKit

extension LocationUpdateVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
             return arrayHomeWorkAddress.count
     }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeWorkCell") as? HomeWorkCell
        let object = arrayHomeWorkAddress[indexPath.row]
        cell?.object = object
        cell?.backgroundColor = .white
        cell?.imgView.tintColor = .black
        cell?.index = indexPath.row
        cell?.buttonDelete.isHidden = object.locationId == "" || object.locationId == "0" ?  true : false
        cell?.delegate = self
        return cell ?? UITableViewCell()
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
             return 70
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let object = arrayHomeWorkAddress[indexPath.row]
        if object.locationId == "" || object.locationId == "0" {
            self.presentVC(storyboard: .Dashboard, viewController: .SearchVC, animated: true) { (vc) in
                (vc as! SearchViewController).delegate = self
                (vc as! SearchViewController).isHeartHide = true
                (vc as! SearchViewController).homeAndWorkIndex = indexPath.row
            }
        }
    }
    
}

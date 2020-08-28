//

import Foundation
import UIKit

//MARK:- Table View Delegate and Datasource
extension LeftViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if globalSideMenuIndex == indexPath.row {
            slideMenuController()?.closeLeft()
            return
        }
        
        if let menu = Menu(rawValue: indexPath.row) {
            self.changeViewController(menu)
        }
    }
    
}

extension LeftViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kSlideMenuView", for: indexPath) as! SlideMenuViewCell
        cell.selectionStyle = .none
        cell.lblTitleNames.text = arrayMenuList[indexPath.row]
        cell.imgIcons.image = arrayMenuImageList[indexPath.row]
        return cell
    }
    
}

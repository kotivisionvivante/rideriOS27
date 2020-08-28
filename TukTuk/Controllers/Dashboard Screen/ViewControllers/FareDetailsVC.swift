//

import UIKit

class FareDetailsVC: UIViewController {
    
    var fareDetailsData : [FareDetails]?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
//MARK:- Action
extension FareDetailsVC {
    @IBAction func buttonActionBack(_ sender: UIButton) {
        dismissViewController()
    }
}

//MARK:- UITableView
extension FareDetailsVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.fareDetailsData!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FareDetailCell") as? FareDetailCell
        let faredetail = self.fareDetailsData![indexPath.row]
        cell?.labelTitle.text = faredetail.title
        cell?.labelValue.text = "Rs.\(faredetail.value as? CVarArg ?? "")"
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

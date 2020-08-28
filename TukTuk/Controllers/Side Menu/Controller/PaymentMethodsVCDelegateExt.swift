//

import Foundation
import UIKit

extension PaymentMethodsVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = (paymentModel?.data?.methods?.count ?? 0) +  (paymentModel?.data?.listOfCards?.count ?? 0)
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodsTVC") as? PaymentMethodsTVC
        cell?.delegate = self
        cell?.index = indexPath.row
        var cardid = ""
        let methodCount = paymentModel?.data?.methods?.count ?? 0
        if indexPath.row  <  methodCount  {
            cell?.methodObject = paymentModel?.data?.methods?[indexPath.row]
        }
        else {
            let cardMethod = paymentModel?.data?.listOfCards?[indexPath.row - methodCount]
            cardid = String(cardMethod?.id ?? 0)
            cell?.listOfCards = cardMethod
        }
        
        cell?.viewCard.borderColor = .clear
        cell?.buttonRadio.isSelected = false
        if indexPath.row == selectedIndex {
            let name = indexPath.row < methodCount ? (paymentModel?.data?.methods?[indexPath.row] ?? "") :  "CARD"
            paymentMethod = name
            cardID = name == "CARD" ? cardid : ""
            cell?.viewCard.borderColor = .appOrangeNewColor
            cell?.viewCard.borderWidth = 2
            cell?.buttonRadio.isSelected = true
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 14, y: 0, width: UIScreen.main.bounds.width, height: 50))
        view.backgroundColor = .white
        let label = UILabel()
        label.frame = view.frame
        view.addSubview(label)
        label.text = "Payment Methods"
        label.font = UIFont(name: "NunitoSans-Bold", size: 20)
        label.textColor = .black
        
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}


//

import UIKit
protocol PaymentMethodsTVCDelegate {
    func SelectedCard(selectedIndex:Int)
}

class PaymentMethodsTVC: UITableViewCell {
    
    //MARK:- Outlets

    @IBOutlet weak var buttonSelectCard: UIButton!
    @IBOutlet weak var buttonRadio: UIButton!
    @IBOutlet weak var labelPayment: UILabel!
    @IBOutlet weak var imageViewPayment: UIImageView!
    @IBOutlet weak var viewCard: UIView!
    //MARK:- Variables
    var delegate : PaymentMethodsTVCDelegate?
    var index = Int()
    var methodObject : String? {
        didSet {
            let imageString = methodObject == "Cash" ? "dollar_large_icon" : "wallet_icon"
            imageViewPayment.image = UIImage(named: imageString)
            labelPayment.text =  (methodObject ?? "").capitalized
        }
    }
    
    var listOfCards:ListOfCards? {
        didSet {
            imageViewPayment.image = UIImage(named: "creditCard_icon")
            let getLastFour = (listOfCards?.card_number ?? "" ).suffix(4)
            labelPayment.text = "**** **** **** \(getLastFour)"
        }
    }
    
    
    
    //MARK:-View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

//MARK:- Action
extension PaymentMethodsTVC {
    @IBAction func buttonActionCardSelect(_ sender: UIButton) {
        delegate?.SelectedCard(selectedIndex: index)
     }
}

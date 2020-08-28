//

import UIKit
protocol SavedPlaceCellDelegate {
    func selectedFavourite(object : SavedPlacesM?,index:Int)
}

class SavedPlaceCell: UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var buttonFavourite: UIButton!
    
    //MARK:- Variables
    var savedPlaceCellDelegate:SavedPlaceCellDelegate?
    var index = Int()
    var object : SavedPlacesM? {
        didSet {
            labelTitle.text = object?.name ?? ""
            labelDescription.text = object?.address ?? ""
        }
    }

    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonActionFavourite(_ sender: UIButton) {
        savedPlaceCellDelegate?.selectedFavourite(object: object, index: index)
    }
}
//MARK:- Action
extension SavedPlaceCell {
    
}

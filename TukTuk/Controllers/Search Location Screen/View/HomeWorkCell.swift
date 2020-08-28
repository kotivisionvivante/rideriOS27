//

import UIKit

protocol HomeWorkCellDelegate {
    func deleteSavedPlace(addressID:String,index:Int)
}

class HomeWorkCell: UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var buttonDelete: UIButton!
    
    //MARK:- Variables
    var index = Int()
    var delegate : HomeWorkCellDelegate?
    var object : GooglePlacesModel?{
        didSet {
            labelTitle.text = object?.titleHomeWork ?? ""
            imgView.image = UIImage(named:object?.iconName ?? "")
            imgView.setImageColor(color: UIColor.appBlueNewColor)
            labelLocation.text = object?.primaryPlace ?? ""
        }
    }

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
extension HomeWorkCell {
    @IBAction func buttonActionDelete(_ sender: UIButton) {
        delegate?.deleteSavedPlace(addressID: object?.locationId ?? "", index: index)
    }
}

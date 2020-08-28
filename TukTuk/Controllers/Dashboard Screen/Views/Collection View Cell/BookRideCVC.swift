//


import UIKit

class BookRideCVC: UICollectionViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var imageViewCar: UIImageView!
    @IBOutlet weak var labelCarType: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelCapacity: UILabel!
    @IBOutlet weak var viewCircle: UIView!
    
    //MARK:-Variables
    var driverObject : DriverServicesM? {
        didSet {
            labelDistance.text = driverObject?.arrival_time ?? ""
            labelCarType.text = driverObject?.name ?? ""
            labelPrice.text =  "Rs. \(driverObject?.total_price as? CVarArg ?? "")"
            let placeholderImage = UIImage(named: "DummyCar_icon")!
            imageViewCar.downloadImageFromURL(urlString: "\(IMAGE_BASE_URL)\(driverObject?.image ?? "")", placeHolder: placeholderImage)
            
            labelCapacity.text = "\(driverObject?.capacity ?? 0)"
        }
    }
    
    //MARK:- VLC
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layoutIfNeeded()
        self.imageViewCar.layer.cornerRadius = self.imageViewCar.frame.size.height/2
        self.imageViewCar.clipsToBounds = true
    }

}

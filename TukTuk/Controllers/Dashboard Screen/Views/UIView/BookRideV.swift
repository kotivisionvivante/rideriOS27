//


import UIKit

protocol BookRideVDelegate {
    func selectPaymentMethod()
    func dropOffViewShow()
    func showPickupView()
    func showFareDetails(fareDetail : [FareDetails]?)
}

class BookRideV: UIView {
    
    //MARK:- Outlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var labelPayment: UILabel!
    @IBOutlet weak var collectionViewCars: UICollectionView!
    @IBOutlet weak var buttonBookRide: UIButton!
    @IBOutlet weak var viewBookRide: UIView!
    @IBOutlet weak var viewBookRideBC: NSLayoutConstraint!
    @IBOutlet weak var viewBookRideTC: NSLayoutConstraint!
    
    @IBOutlet weak var viewDropoff: UIView!
    @IBOutlet weak var viewDropOffBC: NSLayoutConstraint!
    @IBOutlet weak var viewDropTC: NSLayoutConstraint!
    @IBOutlet weak var imageViewSelectedType: UIImageView!
    @IBOutlet weak var labelSelectedType: UILabel!
    @IBOutlet weak var labelCapacity: UILabel!
    @IBOutlet weak var labelDropOffTime: UILabel!
    @IBOutlet weak var labelSelectedPrice: UILabel!
    @IBOutlet weak var labelSelectedPayment: UILabel!
    @IBOutlet weak var paymentMethodImage: UIImageView!
    @IBOutlet weak var paymentMethodImageTop: UIImageView!
    
    
    //MARK:- Variables
    var driverData : DriverServicesDM?
    var selectedObject : DriverServicesM?
    var selectedIndex = 0
    var rideDelegate : BookRideVDelegate?
     var viewPickupNib : PickupLocationView?
    
    //MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commitInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commitInit()
    }


}

//MARK:- Custom Method
extension BookRideV {
    
    func commitInit() {
        Bundle.main.loadNibNamed("BookRideV", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let tap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapCollectionView))
        tap.numberOfTapsRequired = 2
        collectionViewCars.addGestureRecognizer(tap)
//        viewDropoff.isHidden = true
//        viewDropTC.constant  = -320
//        viewDropOffBC.constant = 320
    }
}

//MARK:- Action
extension BookRideV {
    @IBAction func buttonActionBookRide(_ sender: UIButton) {
        rideDelegate?.showPickupView()
    }
    @IBAction func buttonActionFareDetails(_ sender: UIButton) {
        rideDelegate?.showFareDetails(fareDetail: selectedObject?.fareDetails)
    }
    
    @IBAction func buttonActionMode(_ sender: UIButton) {
        rideDelegate?.selectPaymentMethod()
    }
    
    @IBAction func buttonActionNext(_ sender: UIButton) {
        rideDelegate?.showPickupView()
    }
    
    @objc func didDoubleTapCollectionView(gesture: UITapGestureRecognizer) {
        let pointInCollectionView: CGPoint = gesture.location(in: self.collectionViewCars)
        let selectedIndexPath: NSIndexPath = self.collectionViewCars.indexPathForItem(at: pointInCollectionView)! as NSIndexPath
        print(selectedIndexPath.row)
        selectedObject =  self.driverData?.data?[ selectedIndexPath.row]
       
        labelSelectedType.text = selectedObject?.name ?? ""
        labelCapacity.text = "\(selectedObject?.capacity ?? 0)"
        labelSelectedPrice.text =  "Rs. \(selectedObject?.total_price as? CVarArg ?? "")"
        labelDropOffTime.text = "\(selectedObject?.drop_off_time ?? "") drop-off "
        let placeholderImage = UIImage(named: "DummyCar_icon")!
        imageViewSelectedType.downloadImageFromURL(urlString: "\(IMAGE_BASE_URL)\(selectedObject?.image ?? "")", placeHolder: placeholderImage)
        if selectedIndexPath.row != selectedIndex {
             selectedIndex = selectedIndexPath.row
             collectionViewCars.reloadData()
        }
       
        rideDelegate?.dropOffViewShow()
        viewDropTC.constant  = 0
        viewDropOffBC.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
}

//MARK:- Custom Methods
extension BookRideV {
    
    func reloadRideView(driverData:DriverServicesDM?) {
        viewDropoff.isHidden = false
        viewDropTC.constant  = 320
        viewDropOffBC.constant = -320
        self.collectionViewCars.register(UINib(nibName: "BookRideCVC", bundle: nil), forCellWithReuseIdentifier: "BookRideCVC")
        self.driverData = driverData
        setPaymentMethodName(methodName: driverData?.default_payment_mode ?? "")
        if (self.driverData?.data?.count ?? 0) > 0 {
            selectedObject = self.driverData?.data?[0]
        }
        self.collectionViewCars.reloadData()
    }
    
    func setPaymentMethodName(methodName:String) {
        labelPayment.text = methodName.capitalized
        labelSelectedPayment.text = methodName.capitalized
        if methodName.lowercased() == "cash" {
            paymentMethodImage.image = UIImage(named: "dollor_icon")
            paymentMethodImageTop.image = UIImage(named: "dollor_icon")
        } else if methodName.lowercased() == "card" {
            paymentMethodImage.image = UIImage(named: "creditCard_small")
            paymentMethodImageTop.image = UIImage(named: "creditCard_small")
        } else {
            paymentMethodImage.image = UIImage(named: "wallet_small")
            paymentMethodImageTop.image = UIImage(named: "wallet_small")
        }
    }
    
    func hideDropOffView() {
        viewDropTC.constant  = 320
        viewDropOffBC.constant = -320
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }

}


//MARK:- Collection View Delegate and Datasource
extension BookRideV : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.driverData?.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookRideCVC", for: indexPath) as? BookRideCVC
        let arrayDriver = self.driverData?.data
        cell?.driverObject = arrayDriver?[indexPath.row]
        cell?.viewCircle.borderColor = .appLightGrayNewColor
        if indexPath.row == selectedIndex {
            cell?.viewCircle.borderColor = .appRedNewColor
        }
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != selectedIndex {
            selectedIndex = indexPath.row
            selectedObject = self.driverData?.data?[ indexPath.row]
            collectionView.reloadData()
        }
    }
     
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.size.width/3.0, height: 150)
    }
    
}

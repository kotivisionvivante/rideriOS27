//

import UIKit

protocol PickupLocationDelegate {
    func pushToSearch(location: String?, selectedLocation: String?)
    func sendRequestRide(selectedObject : DriverServicesM?,paymentMode:String)

}
protocol SearchLocationDelegate {
    //func pushToSearch(location: String?, selectedLocation: String?)
    //func sendRequestRide(selectedObject : DriverServicesM?,paymentMode:String)
    func searchLocation()
}

class PickupLocationView: UIView {
         
    //MARK:- Outlets
    
    @IBOutlet var viewContent: UIView!
    @IBOutlet weak var labelPickupLocation: UILabel!
   
    var selectedLocation : String!
    var isSearch : Bool!
    var pickUpDelegate : PickupLocationDelegate?
    var searchLocationDelegate : SearchLocationDelegate?
    var selectedLocationDrag : GooglePlacesModel?=nil
    var selectedObject : DriverServicesM?
    var driverData : DriverServicesDM?

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
extension PickupLocationView {
    
    func commitInit() {
        Bundle.main.loadNibNamed("PickupLocationView", owner: self, options: nil)
        addSubview(viewContent)
        viewContent.frame = self.bounds
        viewContent.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}

//MARK:- Action
extension PickupLocationView {
    @IBAction func buttonActionSearch(_ sender: UIButton) {
        self.searchLocationDelegate?.searchLocation()
    }
    
    @IBAction func buttonActionPickup(_ sender: UIButton) {
        if isSearch {
            if selectedLocation == "pickup" {
                Singleton.shared.sourceFromDragMap = selectedLocationDrag
            }
            if selectedLocation == "drop" {
                Singleton.shared.destinationFromDragMap = selectedLocationDrag
            }
            self.pickUpDelegate?.pushToSearch(location: self.labelPickupLocation.text, selectedLocation: self.selectedLocation)
        } else {
            self.pickUpDelegate?.sendRequestRide(selectedObject: selectedObject, paymentMode: self.driverData?.default_payment_mode ?? "")
        }
    }
}

//


import UIKit
import GooglePlaces

protocol AddStopVCDelegate {
    func selectedStopLocation(sourceDestinationPlace: SourceDestinationDM?)
}

class AddStopVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var textFieldPickupLoction: UITextField!

    @IBOutlet weak var textFieldStop1: UITextField!
    @IBOutlet weak var textFieldStop2: UITextField!
    @IBOutlet weak var textFieldStop3: UITextField!
    
    @IBOutlet weak var buttonCrossStop1: UIButton!
    @IBOutlet weak var buttonCrossStop2: UIButton!
    
    @IBOutlet weak var viewStop1: UIView!
    @IBOutlet weak var viewStop2: UIView!
    @IBOutlet weak var viewStop3: UIView!
    
    @IBOutlet weak var stackViewStop: UIStackView!
    
    //MARK:- Variables
    var buttonLocationTag = -1
    var stopDelegate : AddStopVCDelegate?
    var placePickup: GooglePlacesModel?=nil
    var placeStop: [GooglePlacesModel?]=[]
    var placeDrop: GooglePlacesModel?=nil


    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        placeStop.append(nil)
        placeStop.append(nil)
        viewStop2.isHidden = true
        buttonCrossStop1.isHidden = false
        buttonCrossStop2.isHidden = true
        if LocationManagerH.sharedInstance.isLocationEnable {
            textFieldPickupLoction.text = LocationManagerH.sharedInstance.currentAddress
        }
    }
}

//MARK:- Action
extension AddStopVC {
    @IBAction func buttonActionBack(_ sender: UIButton) {
        popViewController()
    }
    
    @IBAction func buttonActionCross(_ sender: UIButton) {
        switch sender.tag {
        case 10:
            textFieldStop1.text = ""
            placeStop[0] = nil
            viewStop1.isHidden = true
            buttonCrossStop1.isHidden = true
            if !viewStop2.isHidden && !viewStop3.isHidden {
                if textFieldStop2.text != "" && textFieldStop3.text != "" {
                    placeStop[0] = placeStop[1]
                    placeStop[1] = placeDrop
                    placeDrop = nil
                    textFieldStop1.text = textFieldStop2.text
                    textFieldStop2.text = textFieldStop3.text
                    textFieldStop3.text = ""
                    viewStop1.isHidden = false
                    buttonCrossStop1.isHidden = false
                }
            }
            
            break
        case 20:
            textFieldStop2.text = ""
            placeStop[1] = nil
            viewStop2.isHidden = true
            buttonCrossStop2.isHidden = true
            if !viewStop1.isHidden && !viewStop3.isHidden {
                if textFieldStop1.text != "" && textFieldStop3.text != "" {
                    placeStop[1] = placeDrop
                    placeDrop = nil
                    textFieldStop2.text = textFieldStop3.text
                    textFieldStop3.text = ""
                    viewStop2.isHidden = false
                    buttonCrossStop2.isHidden = false
                }
            }
            
            break
        default:
            break
        }
        
        
    }

    @IBAction func buttonActionDone(_ sender: UIButton)  {
        if textFieldPickupLoction.text == "" {
            showWarningAlertWithTitle(title: "Alert", message: "Please enter pickup location.")
        }
       else if textFieldStop1.text == "" && textFieldStop2.text == "" && textFieldStop3.text == "" {
            showWarningAlertWithTitle(title: "Alert", message: "Please enter atleast one stop.")
        }
        else {
            pickupAndStopLocationSetup()
        }
    }
    
    @IBAction func buttonActionLocation(_ sender: UIButton) {
        buttonLocationTag = sender.tag
        DispatchQueue.main.async {
            self.presentVC(storyboard: .Dashboard, viewController: .SearchVC, animated: true) { (vc) in
                (vc as! SearchViewController).delegate = self
                 (vc as! SearchViewController).isHeartHide = true
            }
        }
    }
}

//MARK:- Custom Methods
extension AddStopVC {
    func pickupAndStopLocationSetup()  {
        if placePickup == nil {
            let address = LocationManagerH.sharedInstance.currentAddress
            let latitude = LocationManagerH.sharedInstance.latitude
            let longitude = LocationManagerH.sharedInstance.longitude
            self.placePickup = GooglePlacesModel(primaryPlace: address
                , secondaryPlace: "", fullAddress: "", placeID: "", latitude: latitude, longitude: longitude,titleHomeWork: "",iconName: "", locationId: "")
        }
        
        if !viewStop1.isHidden && !viewStop2.isHidden && textFieldStop3.text == "" {
            placeDrop = placeStop[1]
            placeStop[1] = nil
        }
        
        if !viewStop1.isHidden && viewStop2.isHidden && textFieldStop3.text == "" {
            placeDrop = placeStop[0]
            placeStop[0] = nil
        }
        
        let sourceDestination = SourceDestinationDM(sourceLocation: self.placePickup, destinationLocation: self.placeDrop, stopLocation: self.placeStop)
        stopDelegate?.selectedStopLocation(sourceDestinationPlace: sourceDestination)
    }
    
}

//MARK:- Search Location Delegate
extension AddStopVC:SearchVCDelegate {
    func selectedLocation(searchModel: GooglePlacesModel,selectedIndex:Int) {
        switch buttonLocationTag {
        case 11:
            textFieldPickupLoction.text  = searchModel.primaryPlace
            placePickup = searchModel
            break
        case 12:
            textFieldStop1.text  = searchModel.primaryPlace
            placeStop[0] = searchModel
            if viewStop2.isHidden {
                if textFieldStop3.text != "" {
                    placeStop[1] = placeDrop
                    placeDrop = nil
                    textFieldStop2.text = textFieldStop3.text
                    textFieldStop3.text = ""
                    viewStop2.isHidden = false
                    buttonCrossStop2.isHidden = false
                    buttonCrossStop1.isHidden = false
                }
            }
           
            break
        case 13:
            textFieldStop2.text  = searchModel.primaryPlace
            placeStop[1] = searchModel
            break
        case 14:
            textFieldStop3.text  = searchModel.primaryPlace
            placeDrop = searchModel
            if !viewStop1.isHidden && viewStop2.isHidden {
                if textFieldStop1.text == "" {
                    buttonCrossStop1.isHidden = true
                }
                else {
                    viewStop2.isHidden = false
                    textFieldStop2.text = searchModel.primaryPlace
                    placeStop[1] = searchModel
                    buttonCrossStop2.isHidden = false
                    textFieldStop3.text = ""
                    placeDrop = nil
                }
            }
            
            if viewStop1.isHidden && !viewStop2.isHidden {
                viewStop1.isHidden = false
                textFieldStop1.text = textFieldStop2.text
                textFieldStop2.text = searchModel.primaryPlace
                placeStop[0] = placeStop[1]
                placeStop[1] = searchModel
                buttonCrossStop1.isHidden = false
                buttonCrossStop2.isHidden = false
                textFieldStop3.text = ""
                placeDrop = nil
                
            }
            
            if viewStop1.isHidden && viewStop2.isHidden {
                viewStop1.isHidden = false
                textFieldStop1.text = searchModel.primaryPlace
                placeStop[0] = searchModel
                buttonCrossStop1.isHidden = false
                textFieldStop3.text = ""
                placeDrop = nil
            }
            
            break
        default:
            break
        }
    }
}

//


import UIKit
import Foundation
import CoreLocation

class PhoneVerifyViewController: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var btnSelectCountry: UIButton!
    @IBOutlet weak var btnGetOTP: UIButton!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var textBottomView: UIView!
    
    //MARK:- Variables
    var objPVerifyVModel: PhoneVerifyViewModel? = nil
    var code = String()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        hideNavigationBar()
        NotificationCenter.default.addObserver(self, selector:#selector(self.UpdateLocation(notification: )), name:Notification.Name(UPDATE_LOCATION), object:nil)
        objPVerifyVModel = PhoneVerifyViewModel(withPVerfiy: self)
        txtPhoneNumber.givingTextfieldLeftPadding(padding: 10)
        if let text = btnSelectCountry.titleLabel?.text {
            code = text
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        btnGetOTP.setStandardCornerRadius(radius: 5)
    }
    
    //MARK:- Touch Method
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtPhoneNumber.resignFirstResponder()
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OpenCountry" {
            guard let CountryVC = segue.destination as? CountryCodeViewController else { return }
            CountryVC.delegate = self
        }
    }
}

//MARK:- Action
extension PhoneVerifyViewController {
    //MARK: Update Current Country Details
    @objc private func UpdateLocation(notification: Notification) {
        guard let  countryDict = notification.object as? [String:String] else { return }
        let DialCode = countryDict["countrydialcode"]
        let CountryCode = countryDict["countrycode"]
        print(CountryCode!)
        btnSelectCountry.setTitle(DialCode, for: .normal)
        code = DialCode!
        NotificationCenter.default.removeObserver(self, name:Notification.Name(UPDATE_LOCATION), object:nil)
    }
    
    @IBAction func btnSelectCountry_Action(_ sender: UIButton) {
        guard let CountryVC = SB_COUNTRYCODE.instantiateViewController(withIdentifier: "kCountryCodeView") as? CountryCodeViewController else { return }
        CountryVC.delegate = self
        self.navigationController?.pushViewController(CountryVC, animated: true)
    }
    
    @IBAction func GetOTP(_ sender: Any) {
        objPVerifyVModel?.callWebserviceForPhoneNumberVerify(code: code, mobile: txtPhoneNumber.text ?? "")
    }
}

//MARK:- TextField Delegate
extension PhoneVerifyViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textBottomView.backgroundColor = UIColor.appLightGrayNewColor
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textBottomView.backgroundColor = UIColor.appYellowNewColor
        
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
        textBottomView.backgroundColor = UIColor.appYellowNewColor
        
        return true
    }
}

//MARK:- Web Service Delegate
extension PhoneVerifyViewController: PhoneVerifyViewModelDelegates {
    
    func navigateToOTPViewController(data: PhoneRegisterDM?) {
        if data?.data?.id != nil || data?.data?.id != 0 {
            self.pushVC(storyboard: .Landing, viewController: .OtpVerifyVC, animated: true) { (vc) in
                (vc as? OTPVerificationViewController)?.cCode = code
                (vc as? OTPVerificationViewController)?.phoneNumber = txtPhoneNumber.text ?? ""
            }
        } else {
           showWarningAlertWithTitle(title: "Alert!", message: "Your account is not approved yet.")
        }
    }
}

//MARK:- Country Code Delegate
extension PhoneVerifyViewController: CountryCodeDelegate {
    func didselectCounty(country: [String : String]) {
        _ = country["name"]
        let CCode = country["dial_code"]
        code = CCode!
        //image_CountryFlag.image = UIImage.init(named: country["code"] ?? "")
        btnSelectCountry.setTitle(CCode, for: .normal)
    }
    
}


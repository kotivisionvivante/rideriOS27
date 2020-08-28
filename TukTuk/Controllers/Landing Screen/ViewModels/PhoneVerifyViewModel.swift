//


protocol PhoneVerifyViewModelDelegates {
    func navigateToOTPViewController(data: PhoneRegisterDM?)
}

import UIKit
import ObjectMapper

class PhoneVerifyViewModel: NSObject {
    
    let delegate: PhoneVerifyViewModelDelegates?
    
    // MARK: Init
    init(withPVerfiy pverify: PhoneVerifyViewModelDelegates) {
        self.delegate = pverify
    }
    
    func callWebserviceForPhoneNumberVerify(code: String, mobile: String) {
      
        if mobile.isValidPhone {
            phoneResgisterApi(phoneNumber: "\(code)\(mobile)")
            
        } else {
            showWarningAlertWithTitle(title: "Alert!", message: "Please enter correct mobile number.")
        }
    }
}

//MARK:- Service Implementation
extension PhoneVerifyViewModel {
    
    func phoneResgisterApi(phoneNumber:String) {
         let postBody = ["device_type": DEVICE_TYPE, "device_token": APPDELEGATE.DeviceToken, "mobile": phoneNumber] as [String: Any]
        ActivityIndicator.shared.showActivityIndicator()
        APIManager.shared.requestWithoutHeader(url: kregister_mobile, method: .post, parameters: postBody, completionCallback: { (response) in
             ActivityIndicator.shared.hideActivityIndicator()
        }, success: { (jsonResponse) in
            let data = Mapper<PhoneRegisterDM>().map(JSONObject: jsonResponse)
                self.delegate?.navigateToOTPViewController(data: data)
                        
        }) { (error) in
            self.showWarningAlertWithTitle(title: "Alert!", message: error ?? "")
        }
    }
    
}

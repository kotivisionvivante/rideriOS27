//


protocol OTPVerificationViewModelDelegates {
    func navigateToDashboardViewController()
    func navigateToPopViewController()

}

import UIKit
import ObjectMapper

class OTPVerificationViewModel: NSObject {
    
    let delegate: OTPVerificationViewModelDelegates?
    
    // MARK: Init
    init(withOTPVerfiy otpverify: OTPVerificationViewModelDelegates) {
        self.delegate = otpverify
    }
    
    func callWebserviceForPhoneNumberVerify(otp: String, mobile: String) {
     
        if otp.count <= 3 {
            showWarningAlertWithTitle(title: "Alert!", message: "Please enter OTP you received on your registered mobile number.")
        } else {
            phoneNumberVerifyApi(phoneNumber: mobile, otp: otp)
        }
    }
    
    func callwebServiceForResendOTP(mobile: String) {
        resendApi(phoneNumber: mobile)
    }

}

//MARK:- Service Implementation
extension OTPVerificationViewModel {
    
    func phoneNumberVerifyApi(phoneNumber:String,otp:String) {
         let postBody = ["otp": otp, "device_token": APPDELEGATE.DeviceToken, "mobile": phoneNumber] as [String: Any]
           ActivityIndicator.shared.showActivityIndicator()
        APIManager.shared.requestWithoutHeader(url: kverify_otp_mobile, method: .post, parameters: postBody, completionCallback: { (response) in
             ActivityIndicator.shared.hideActivityIndicator()
        }, success: { (jsonResponse) in
            let data = Mapper<PhoneVerifyDM>().map(JSONObject: jsonResponse)
            UserDefaults.setUser(data!)
            print(GlobalUserDetail?.data?.access_token ?? "")
            k_UserDef.set(true, forKey: SKIP_TUTORIAL)
            k_UserDef.set(true, forKey: IS_USER_LOGGED_IN)
            k_UserDef.synchronize()
            self.delegate?.navigateToDashboardViewController()
            
        }) { (error) in
            self.showWarningAlertWithTitle(title: "Alert!", message: error ?? "")
        }
    }
    
    func resendApi(phoneNumber:String) {
         let postBody = ["device_type": DEVICE_TYPE, "device_token": APPDELEGATE.DeviceToken, "mobile": phoneNumber] as [String: Any]
        ActivityIndicator.shared.showActivityIndicator()
        APIManager.shared.requestWithoutHeader(url: kverify_otp_resend, method: .post, parameters: postBody, completionCallback: { (response) in
             ActivityIndicator.shared.hideActivityIndicator()
        }, success: { (jsonResponse) in
            let _ = Mapper<PhoneRegisterDM>().map(JSONObject: jsonResponse)            
        }) { (error) in
            self.showWarningAlertWithTitle(title: "Alert!", message: error ?? "")
        }
    }
    
}

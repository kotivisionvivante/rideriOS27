//

import Foundation
import ObjectMapper

protocol PaymentMethodVMDelegate {
    func getPaymentDetail(paymentModel:PaymentModel?)
}

class PaymentMethodVM:NSObject {
    
    //MARK:- Variables
    var paymentDelegate : PaymentMethodVMDelegate?
    //MARK:- Init
    
    init(delegate:PaymentMethodVMDelegate) {
        self.paymentDelegate = delegate
    }
    
}

//MARK:- Service Implementation
extension PaymentMethodVM {
    func getPaymentMethodsList() {

        ActivityIndicator.shared.showActivityIndicator()
        APIManager.shared.request(url: kpayment_methods, method: .get, parameters: nil, tryAgain: false, completionCallback: { (response) in
            ActivityIndicator.shared.hideActivityIndicator()
        }, success: { (jsonResponse) in
         let data = Mapper<PaymentModel>().map(JSONObject: jsonResponse)
         self.paymentDelegate?.getPaymentDetail(paymentModel: data)
            
        }) { (error) in
            self.showWarningAlertWithTitle(title: "Alert!", message: error ?? "")
        }
    }
    
    func setDefaultMethod(methodName:String,cardID:String) {
        
        var param = ["method":methodName] as [String : Any]
        
        if cardID != "" {
            param.updateValue(Int(cardID) ?? 0, forKey: "card_id")
        }

        ActivityIndicator.shared.showActivityIndicator()
        APIManager.shared.request(url: kdefault_method, method: .post, parameters: param, tryAgain: false, completionCallback: { (response) in
            ActivityIndicator.shared.hideActivityIndicator()
        }, success: { (jsonResponse) in
            
        }) { (error) in
            self.showWarningAlertWithTitle(title: "Alert!", message: error ?? "")
        }
    }
}

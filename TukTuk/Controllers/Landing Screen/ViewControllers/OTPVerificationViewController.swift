//


import UIKit
import SlideMenuControllerSwift

class OTPVerificationViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var lblResendCodeIn: UILabel!
    @IBOutlet weak var codeView: SwiftyCodeView!
    @IBOutlet weak var lblEnterOTP: UILabel!
    @IBOutlet weak var lblShowPhoneNumber: UILabel!
    @IBOutlet weak var lblLeftTiming: UILabel!
    @IBOutlet weak var btnLetsStart: UIButton!
    
    //MARK:- Variables
    var timer: Timer?
    var counter = 30
    var cCode = String()
    var phoneNumber = String()
    var verifyCode = String()
    var objVerifyOTPVModel: OTPVerificationViewModel? = nil
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        showNavigationBar()
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        objVerifyOTPVModel = OTPVerificationViewModel(withOTPVerfiy: self)
        let leftBarButton = UIBarButtonItem.itemWith(colorfulImage: UIImage(named: "BtnBack_ICON"), target: self, action: #selector(OTPVerificationViewController.myBarButtonItemTapped(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
        lblShowPhoneNumber.text = "\(cCode) \(phoneNumber)"
        lblLeftTiming.isUserInteractionEnabled = false
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        buttonStartDisable(isDisable: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        btnLetsStart.setStandardCornerRadius(radius: 5)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideNavigationBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        hideNavigationBar()
    }
}

//MARK:- Custom Methods
extension OTPVerificationViewController {
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func callResendApi() {
        objVerifyOTPVModel?.callwebServiceForResendOTP(mobile: "\(cCode)\(phoneNumber)")
    }
    
    func buttonStartDisable(isDisable:Bool) {
        if isDisable {
            btnLetsStart.backgroundColor = UIColor.appRedNewColor.withAlphaComponent(0.5)
            btnLetsStart.isEnabled = false
        }
        else {
            btnLetsStart.backgroundColor = UIColor.appRedNewColor.withAlphaComponent(1)
            btnLetsStart.isEnabled = true
        }
    }
}

//MARK:- Action
extension OTPVerificationViewController {
    
    @objc func updateCounter() {
        if counter != 0 {
            lblResendCodeIn.text = "Resend code in "
            lblLeftTiming.isUserInteractionEnabled = false
            self.lblLeftTiming.text = "\(self.timeFormatted(self.counter))"
            counter -= 1
            
        } else {
            lblLeftTiming.isUserInteractionEnabled = true
            lblResendCodeIn.text = ""
            self.lblLeftTiming.text = "Resend code"
            timer?.invalidate()
        }
    }
    @IBAction func ResendCodeTapped(_ sender: UITapGestureRecognizer) {
        //This functionality is pending
        timer?.invalidate()
        counter = 30
        lblLeftTiming.isUserInteractionEnabled = false
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        callResendApi()
    }
    @objc func myBarButtonItemTapped(_ sender: UIBarButtonItem) {
        timer?.invalidate()
        popViewController()
    }
    
    @IBAction func btnLetsStart_Action(_ sender: UIButton) {
        
        timer?.invalidate()
        //Singleton.shared.setHomeView()
        objVerifyOTPVModel?.callWebserviceForPhoneNumberVerify(otp: "123456", mobile: "\(cCode)\(phoneNumber)")
    }
}

extension OTPVerificationViewController: SwiftyCodeViewDelegate {
    func codeView(sender: SwiftyCodeView, didFinishInput code: String) -> Bool {
        verifyCode = code
        buttonStartDisable(isDisable: false)
        return true
    }
    
    func removeCode(sender: SwiftyCodeItemView, didFinishInput code: String) {
        buttonStartDisable(isDisable: true)
    }
}

extension OTPVerificationViewController: OTPVerificationViewModelDelegates {
    func navigateToDashboardViewController() {
        Singleton.shared.setHomeView()
    }
    
    func navigateToPopViewController() {
        self.popViewController()
    }
}

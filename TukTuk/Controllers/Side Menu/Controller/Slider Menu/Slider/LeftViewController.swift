//


import UIKit
import SlideMenuControllerSwift

enum Menu: Int {
    case Dashboard
    case Profile
    case MyWallet
    case Trips
    case Payment
    case AddSchedule
    case FreeRides
    case Settings
    case Help
}

class LeftViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var tblLeftMenu: UITableView!
    @IBOutlet weak var btnSignOut: UIButton!
    
    
    //MARK:- Variables
    var window: UIWindow?
    var arrayMenuList = ["Home", "Profile", "My Wallet", "Your Trips", "Payments", "Schedule", "Free Rides", "Settings", "Help"]
    var arrayMenuImageList = [UIImage(named: "Home_ICON"), UIImage(named: "Profile_ICON"), UIImage(named: "MyWallet_ICON"), UIImage(named: "YourTrip_ICON"), UIImage(named: "Payment_ICON"),UIImage(named: "calendar_icon"), UIImage(named: "FreeRides_ICON"), UIImage(named: "Setting_ICON"), UIImage(named: "Help_ICON")]
    var selectedIndex = 0
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tblLeftMenu.tableFooterView = UIView(frame: .zero)
       
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Helper Methods
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
}


//MARK:- Action
extension LeftViewController {
    @IBAction func btnSignOut_Action(_ sender: UIButton) {
        showAlertWithTitle(title: "Sign Out", message: "Are you sure, you want to logged out from application?", okButton: "OK", cancelButton: "CANCEL" , okSelectorName: #selector(logout)
        )
    }
    
    @objc func logout() {
        k_UserDef.removeObject(forKey: USER_DETAILS)
        k_UserDef.set(false, forKey: IS_USER_LOGGED_IN)
        moveToLogin()
        //       guard let LandingVC = SB_LANDING.instantiateViewController(withIdentifier: SBLANDING().PHONEVERIFY) as? PhoneVerifyViewController else { return }
        //       self.navigationController?.pushViewController(LandingVC, animated: false)
    }
}

//MARK:- Custom Methods
extension LeftViewController {
    func moveToLogin() {
        window = UIWindow(frame: UIScreen.main.bounds)
        UserDefaults.saveRecentSearch(arrayRecentSearch: [])
        if let LandingVC = SB_LANDING.instantiateViewController(withIdentifier: SBLANDING().PHONEVERIFY) as? PhoneVerifyViewController  {
            
            let navigationController = UINavigationController.init(rootViewController: LandingVC)
            navigationController.navigationBar.isHidden = true
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            appdelegate.window?.rootViewController = navigationController
            //k_UserDef.set(false, forKey: SKIP_TUTORIAL)
            //k_UserDef.synchronize()
            
        }
    }
    
    
    func changeViewController(_ menu: Menu) {
        
        switch menu {
        case .AddSchedule:
            self.changeSideController(storyBoard: .SideMenu, controller: .AddScheduleVC)
            break
        case .Dashboard:
             self.changeSideController(storyBoard: .Dashboard, controller: .DashboardVC)
            break
        case .Profile:        break
        case .MyWallet:        break
        case .Trips:        break
        case .Payment:
            self.changeSideController(storyBoard: .SideMenu, controller: .PaymentMethodsVC)
            break
        case .FreeRides:        break
        case .Settings:
            self.changeSideController(storyBoard: .SideMenu, controller: .LocationUpdateVC)
            break
        case .Help:        break
            
        }
    }
}


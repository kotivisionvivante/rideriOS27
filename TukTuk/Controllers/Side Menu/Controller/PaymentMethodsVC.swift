//

import UIKit

protocol PaymentMethodsVCDelegate {
    func getMethodName(methodName:String,cardID:String)
}

class PaymentMethodsVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var tableViewPaymentMethods: UITableView!
    @IBOutlet weak var buttonMenu: UIButton!
    @IBOutlet weak var buttomAddMethods: UIButton!
    
    //MARK:- Variables
    var selectedIndex = 0
    var isFromSideMenu = true
    var paymentMethod = String()
    var paymentMethodsVCDelegate : PaymentMethodsVCDelegate?
    var methodsVM : PaymentMethodVM? = nil
    var paymentModel: PaymentModel?
    var cardID = String()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isFromSideMenu {
            buttonMenu.setImage(UIImage(named: "BtnBack_ICON"), for: .normal)
        }
        else {
            globalSideMenuIndex = 4
        }
        tableViewPaymentMethods.register(UINib(nibName: "PaymentMethodsTVC", bundle: nil), forCellReuseIdentifier: "PaymentMethodsTVC")
        tableViewPaymentMethods.tableFooterView = UIView()
        methodsVM = PaymentMethodVM(delegate: self)
        methodsVM?.getPaymentMethodsList()
    }
}

//MARK:- Action
extension PaymentMethodsVC {
    @IBAction func buttonActionMenu(_ sender: UIButton) {
        if isFromSideMenu {
            slideMenuController()?.toggleLeft()
        }
        else {
            popViewController()
        }
    }
    
    @IBAction func buttonActionAddPaymentMethod(_ sender: UIButton) {
        if !isFromSideMenu {
            popViewController()
            paymentMethodsVCDelegate?.getMethodName(methodName: paymentMethod, cardID: cardID)
        }
        else {
            self.changeSideController(storyBoard: .Dashboard, controller: .DashboardVC)
        }
        
        methodsVM?.setDefaultMethod(methodName: paymentMethod, cardID: cardID)

        
    }
}

//MARK:- Payment Methods TVC Delegate
extension PaymentMethodsVC:PaymentMethodsTVCDelegate {
    func SelectedCard(selectedIndex: Int) {
          self.selectedIndex = selectedIndex
          tableViewPaymentMethods.reloadData()
    }
}

//MARK:- PaymentMethodsVM Delegate
extension PaymentMethodsVC:PaymentMethodVMDelegate {
    func getPaymentDetail(paymentModel: PaymentModel?) {
        self.paymentModel = paymentModel
        let methodName = self.paymentModel?.data?.defaultMethod ?? ""
        let count = (paymentModel?.data?.methods?.count ?? 0) +  (paymentModel?.data?.listOfCards?.count ?? 0)
        for i in 0..<count {
            let methodCount = paymentModel?.data?.methods?.count ?? 0
            if i  <  methodCount  {
                let object = paymentModel?.data?.methods?[i] ?? ""
                if methodName == object {
                    selectedIndex = i
                    break
                }
            }
            else {
                let cardMethod = paymentModel?.data?.listOfCards?[i - methodCount]
                if cardMethod?.is_default == 1 {
                    selectedIndex = i
                    break
                }
            }
        }
        tableViewPaymentMethods.reloadData()
    }
}

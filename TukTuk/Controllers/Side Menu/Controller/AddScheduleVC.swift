//

import UIKit
protocol AddScheduleVCDelegate {
    func skipSchedule()
}

class AddScheduleVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var textFieldTime: UITextField!
    @IBOutlet weak var textFieldDate: UITextField!
    @IBOutlet weak var buttonSkip: UIButton!
    @IBOutlet weak var buttonMenu: UIButton!
    
    //MARK:- Varibales
     var delegate:AddScheduleVCDelegate?
     var isFromSideMenu =  true
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addDatePicker(textfield: textFieldDate)
        addDatePicker(textfield: textFieldTime)
        buttonSkip.isHidden = true
        
        if !isFromSideMenu {
            buttonSkip.isHidden = false
            buttonMenu.isHidden = true
        }
        else {
            globalSideMenuIndex = 5
        }
    }
}

//MARK:- Action
extension AddScheduleVC {
    @IBAction func buttonActionSkip(_ sender: UIButton) {
        self.dismissViewController()
        delegate?.skipSchedule()
    }
    
    @IBAction func buttonActionBack(_ sender: UIButton) {
        slideMenuController()?.toggleLeft()
    }
    
    @IBAction func buttonActionDone(_ sender: UIButton) {
        if textFieldDate.text?.count == 0 {
            showWarningAlertWithTitle(title: "Alert", message: "Please select future date.")
        }
        else  if textFieldTime.text?.count == 0 {
            showWarningAlertWithTitle(title: "Alert", message: "Please select future time.")
        }
        else {
            UserDefaults.saveSchedule(date: textFieldDate.text ?? "", time: textFieldTime.text ?? "")
            self.changeSideController(storyBoard: .Dashboard, controller: .DashboardVC)
        }
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        if sender.tag == 10 {
            textFieldDate.text = self.view.convertDateFormatD(date: sender.date, toFormat: "yyyy-MM-dd ")
        }
        else if sender.tag == 20 {
            textFieldTime.text = self.view.convertDateFormatD(date: sender.date, toFormat: "HH:mm ")
        }
    }
    
//    @objc func donePressedDate() {
//
//    }
}

//MARK:- Date Picker Process

extension AddScheduleVC {
    
    func addDatePicker(textfield:UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = textfield.tag == 10 ? UIDatePicker.Mode.date :    UIDatePicker.Mode.time
        datePickerView.backgroundColor = UIColor.white
        datePickerView.tag = textfield.tag
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        datePickerView.minimumDate = Date()
        textfield.inputView = datePickerView
//        self.addToolBarAtKeyBoard(txtF: textfield)
    }
    
//    @objc func addToolBarAtKeyBoard( txtF: UITextField){
//        let toolBar = UIToolbar()
//        toolBar.barStyle = UIBarStyle.black
//        toolBar.tintColor = .white
//
//        toolBar.isTranslucent = true
//        var doneButton = UIBarButtonItem()
//
//        doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action:  #selector(donePressedDate))
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
//        toolBar.setItems([spaceButton,doneButton], animated: false)
//        toolBar.isUserInteractionEnabled = true
//        toolBar.sizeToFit()
//        txtF.inputAccessoryView = toolBar
//    }
}

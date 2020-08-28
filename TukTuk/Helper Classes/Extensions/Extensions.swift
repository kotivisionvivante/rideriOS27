//
//  Extensions.swift
//  TukTuk
//
//  Created by Harjot Harry on 2/18/20.
//  Copyright © 2020 TukTuk Inc. All rights reserved.
//

import UIKit
import Foundation
import Kingfisher
import GoogleMaps

// MARK: - Device Check
extension UIDevice {
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
    
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    enum ScreenType: String {
        case iPhone4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhoneX = "iPhone X"
        case iPad5Gen_Air_Pro9 = "iPad5Gen, Air, Air 2, Pro9"
        case iPadPro10 = "iPadPro10"
        case iPadPro12 = "iPadPro12.9"
        case unknown
    }
    
    var deviceType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4_4S
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436:
            return .iPhoneX
        case 2048:
            return .iPad5Gen_Air_Pro9
        case 2224:
            return .iPadPro10
        case 2732:
            return .iPadPro12
        default:
            return .unknown
        }
    }
    
    class func isIOS12OrHigher() -> Bool {
        var iosAvailable = false
        if #available(iOS 12.0, *) {
            // use iOS 12-only feature
            iosAvailable = true
        } else {
            // handle older versions
            iosAvailable = false
        }
        return iosAvailable
    }
}
//MARK:- Bar Button
extension UIBarButtonItem {
    class func itemWith(colorfulImage: UIImage?, target: AnyObject, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(colorfulImage, for: .normal)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0)
        button.addTarget(target, action: action, for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        return barButtonItem
    }
}
//MARK:- Button
extension UIButton {
    
    func setStandardCornerRadius(radius : CGFloat) {
        self.layer.cornerRadius = radius
    }
}


//MARK: //////    Change TF Placeholder Color  ////////
extension UITextField {
    
    func setPlaceHolderColorWith(strPH:String, color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: strPH, attributes: [NSAttributedString.Key.foregroundColor : color])
    }
    
    func givingTextfieldLeftPadding(padding: CGFloat) {
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.bounds.height))
        leftView = paddingView
        leftViewMode = .always
    }
    
    func setLeftIcon(_ icon: UIImage, padding: CGFloat, widthSize: CGFloat, heightSize: CGFloat) {
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: widthSize+padding, height: heightSize) )
        let iconView  = UIImageView(frame: CGRect(x: padding/2, y: 0, width: widthSize, height: heightSize))
        iconView.layer.cornerRadius = iconView.bounds.size.height / 2
        iconView.image = icon
        outerView.addSubview(iconView)
        leftView = outerView
        leftViewMode = .always
    }
    
    func setLeftImageForCurrencyIcon(urlString: String) {
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: 25+20, height: 25) )
        let iconView  = UIImageView(frame: CGRect(x: 10, y: 0, width: 25, height: 25))
        iconView.layer.cornerRadius = iconView.bounds.size.width / 2
        iconView.imageFromURL(urlString: urlString)
        outerView.addSubview(iconView)
        leftView = outerView
        leftViewMode = .always
    }
    
    func setRightIcon(_ icon: UIImage, padding: CGFloat, widthSize: CGFloat, heightSize: CGFloat) {
        let iconView  = UIImageView(frame: CGRect(x: padding, y: 0, width: widthSize, height: heightSize))
        iconView.image = icon
        rightView = iconView
        rightViewMode = .always
    }
    
}

//MARK:- String
extension String {
    
   var isValidEmail: Bool {
      let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
      let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
      return testEmail.evaluate(with: self)
   }
    
   var isValidPhone: Bool {
      let regularExpressionForPhone = "^\\d{3}\\d{3}\\d{4}$"
      let testPhone = NSPredicate(format:"SELF MATCHES %@", regularExpressionForPhone)
      return testPhone.evaluate(with: self)
   }
    
}

//MARK:- UIView Ext
extension UIView {
    func fourSideShadow(color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        let shadowSize : CGFloat = radius
        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                   y: -shadowSize / 2,
                                                   width: self.frame.size.width + shadowSize,
                                                   height: self.frame.size.height + shadowSize))
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 10
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowOpacity = opacity
        self.layer.shadowPath = shadowPath.cgPath
    }
    
    func convertDateFormat(fromFormat:String,date:String,toFormat:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        let date1 = dateFormatter.date(from: date)
        dateFormatter.dateFormat = toFormat
        if date1 != nil {
            return dateFormatter.string(from: date1!)
        }
        else {
            return date
        }
    }
    
//    func convertDateFormatD(date:Date,toFormat:String) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = toFormat
//        return  dateFormatter.string(from: date)
//    }
}


//MARK: //////    UIViewcontroller  ////////
extension UIViewController {
    
    func pushVC(storyboard:Storyboard,viewController:Controller,animated:Bool,completion:(Any) -> Void) {
        let story = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        let className = "\(viewController.rawValue)"
        let vc = story.instantiateViewController(withIdentifier: className)
        self.navigationController?.pushViewController(vc, animated: animated)
        completion(vc)
    }
    
    func presentVC(storyboard:Storyboard,viewController:Controller,
                   animated:Bool,style:UIModalPresentationStyle = .fullScreen,completion:(Any) -> Void) {
           let story = UIStoryboard(name: storyboard.rawValue, bundle: nil)
           let className = "\(viewController.rawValue)"
           let vc = story.instantiateViewController(withIdentifier: className)
           vc.modalPresentationStyle = style
            completion(vc)
           self.present(vc, animated: animated)
           
       }
    
    func changeSideController(storyBoard:Storyboard,controller:Controller) {
        let story = UIStoryboard(name: storyBoard.rawValue, bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: controller.rawValue)
        let navController = UINavigationController(rootViewController: vc)
        navController.isNavigationBarHidden = true
        self.slideMenuController()?.changeMainViewController(navController, close: true)
    }
    
    func showWarningAlertWithTitleOnVC(title: String, message: String) {
        DispatchQueue.main.async(execute: {
            let alert = CustomAlertController()
            alert.showCloseButton = true
            _ = alert.showWarning(title, subTitle: message)
        })
    }

    func showSuccessAlertWithTitleOnVC(title: String, message: String) {
        DispatchQueue.main.async(execute: {
            let alert = CustomAlertController()
            alert.showCloseButton = true
            _ = alert.showSuccess(title, subTitle: message)
        })
    }
    
    func dismissViewController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func popViewController(animate:Bool=true){
        self.navigationController?.popViewController(animated: animate)
    }
    
    func popViewControllerDashboard() {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: DashboardViewController.self) {
                _ =  self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    func hideNavigationBar(){
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func showNavigationBar(){
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func isValidPassword(password: String) -> Bool {
        //Minimum 6 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character:
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{6,}"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }
    
    func isValidEmail(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func showAlertWithTitle(title:String, message:String, okButton:String, cancelButton:String, okSelectorName:Selector?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if okSelectorName != nil {
            let OKAction = UIAlertAction(title: okButton, style: .default) { (action:UIAlertAction!) in
                self.perform(okSelectorName)
            }
            alertController.addAction(OKAction)
        } else {
            let OKAction = UIAlertAction(title: okButton, style: .default, handler: nil)
            alertController.addAction(OKAction)
        }
        
        if cancelButton != "" {
            let cancleAction = UIAlertAction(title: cancelButton, style: .destructive) { (action:UIAlertAction!) in
                print("cancel")
            }
            alertController.addAction(cancleAction)
        }
        self.present(alertController, animated: true, completion:nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK:- NSObject
extension NSObject {
    func showErrorAlertWithTitle(title: String, message: String) {
        DispatchQueue.main.async(execute: {
            let alert = CustomAlertController()
            alert.showCloseButton = true
            _ = alert.showError(title, subTitle: message)
        })
    }

    func showWarningAlertWithTitle(title: String, message: String) {
        DispatchQueue.main.async(execute: {
            let alert = CustomAlertController()
            alert.showCloseButton = true
            _ = alert.showWarning(title, subTitle: message)
        })
    }

    func showSuccessAlertWithTitle(title: String, message: String) {
        DispatchQueue.main.async(execute: {
            let alert = CustomAlertController()
            alert.showCloseButton = true
            _ = alert.showSuccess(title, subTitle: message)
        })
    }
    
    func showInfoAlertWithTitle(title: String, message: String, completionCallback: @escaping(Bool) -> Void) {
        DispatchQueue.main.async(execute: {
            let alert = CustomAlertController()
            alert.showCloseButton = true
           _ = alert.addButton("YES") {
                completionCallback(true)
            }
            _ = alert.showSuccess(title, subTitle: message, closeButtonTitle: "NO")
        })
    }
    
    func convertDateFormatD(date:Date,toFormat:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = toFormat
        return  dateFormatter.string(from: date)
    }
    
    class var className: String {
        return String(describing: self)
    }
}

//MARK:- ImageView
extension UIImageView {
    func downloadImageFromURL(urlString: String, placeHolder: UIImage) {
        let url = URL(string: urlString)
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url, placeholder: placeHolder)
    }
    
    func imageFromURL(urlString: String) {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        activityIndicator.startAnimating()
        self.addSubview(activityIndicator)
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                if image != nil{
                    self.image = image
                } else {
                    self.image = UIImage(named: "DemoFlag")
                }
                activityIndicator.removeFromSuperview()
            })
        }).resume()
    }
    
    func setImageColor(color: UIColor) {
       let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
       self.image = templateImage
       self.tintColor = color
     }
}

//MARK:- Color
extension UIColor {
    class var appGrayColor : UIColor {
        return UIColor(named: "TextGyarColor")!
    }
    
    class var appBlueColor : UIColor {
        return UIColor(named: "TextBlueColor")!
    }
    
    class var appBlueNewColor : UIColor {
        return UIColor(named: "BlueNewColor")!
    }
    
    class var appRedNewColor : UIColor {
        return UIColor(named: "BtnRedColor")!
    }
    class var appLightGrayNewColor : UIColor {
        return UIColor(named: "UnderLineGrayColor")!
    }
    class var appOrangeNewColor : UIColor {
        return UIColor(named: "AppOrangeColor")!
    }
    
    class var appYellowNewColor : UIColor {
        return UIColor(named: "AppYellowColor")!
    }
}
//MARK:- GMSCircle Extension
extension GMSCircle {
    func bounds () -> GMSCoordinateBounds {
        func locationMinMax(positive : Bool) -> CLLocationCoordinate2D {
            let sign:Double = positive ? 1 : -1
            let dx = sign * self.radius  / 6378000 * (180/Double.pi) //
            let lat = position.latitude + dx
            let lon = position.longitude + dx / cos(position.latitude * Double.pi/180)
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
        
        return GMSCoordinateBounds(coordinate: locationMinMax(positive: true),
                                   coordinate: locationMinMax(positive: false))
    }
}

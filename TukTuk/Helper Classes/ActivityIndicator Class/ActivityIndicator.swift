//
//  ActivityIndicator.swift
//  Flyority
//
//  Created by Harjot Bharti on 11/5/18.
//  Copyright © 2018 Mobile Programming LLC. All rights reserved.
//

import UIKit
import Foundation
import NVActivityIndicatorView

class ActivityIndicator : NSObject, NVActivityIndicatorViewable {
    
    static let shared = ActivityIndicator()
    static var activityData = ActivityData()
    
    var loaderVC: LoaderVC? = nil
    var isLoaderInUse: Bool = false
    
    func showActivityIndicator() {
        
        if isLoaderInUse {
            return
        }
        
        guard let vc = SB_LOADER.instantiateViewController(withIdentifier: SBLOADER().LOADER) as? LoaderVC else {
            return
        }
        self.isLoaderInUse = true
        loaderVC = vc
        vc.view.alpha = 0.0
        
        vc.activityIndicator.startAnimating()
        
        DispatchQueue.main.async {
            if let currentVC = UIApplication.getTopViewController() {
                currentVC.view.addSubview(vc.view)
            }
            
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.8, options: .transitionCrossDissolve, animations: {
                vc.view.alpha = 1.0
            }) { (success) in

            }
        }
        
        /*
        NVActivityIndicatorView.DEFAULT_TYPE = .lineSpinFadeLoader
        
        NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 50, height: 50)
        NVActivityIndicatorView.DEFAULT_COLOR = UIColor.white
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
         */
    }
    
    func showActivityIndicatorWithMessage(message: String) {
        /*
         NVActivityIndicatorView.DEFAULT_TYPE = .lineSpinFadeLoader
        NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 50, height: 50)
        NVActivityIndicatorView.DEFAULT_COLOR = UIColor.white
        NVActivityIndicatorView.DEFAULT_BLOCKER_MESSAGE_FONT = UIFont(name: "CenturyGothic", size: 16)!
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
        NVActivityIndicatorPresenter.sharedInstance.setMessage(message)
        */
 }
    
    func hideActivityIndicator() {
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.8, options: .transitionCrossDissolve, animations: {
            self.loaderVC?.view.alpha = 0.0
        }) { (success) in
            self.loaderVC?.view.removeFromSuperview()
            self.isLoaderInUse = false
            self.loaderVC = nil
        }
//        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }
    
    private override init() {}
}

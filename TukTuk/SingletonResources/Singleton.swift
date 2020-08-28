//
//  Singleton.swift
//  TukTuk
//
//  Created by Jaspreet Singh on 28/03/20.
//  Copyright © 2020 TukTuk Inc. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class Singleton {
    
    static let shared = Singleton()

    func setHomeView(){
        
        let appDelegate = UIApplication.shared.delegate
        guard let mainViewController = SB_DASHBOARD.instantiateViewController(withIdentifier: SBDASHBOARD().DASHBOARD_VIEW) as? DashboardViewController else {
            return
        }
        guard let leftViewController = SB_DASHBOARD.instantiateViewController(withIdentifier: SBDASHBOARD().SIDEMENU_VIEW) as? LeftViewController else {
            return
        }
        
        let navigationVC: UINavigationController = UINavigationController(rootViewController: mainViewController)
        let slideMenuController = SlideMenuController(mainViewController: navigationVC, leftMenuViewController: leftViewController)
        
        navigationVC.isNavigationBarHidden = true
        slideMenuController.delegate = mainViewController
        SlideMenuOptions.contentViewScale = 1
        
        appDelegate?.window??.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        appDelegate?.window??.rootViewController = slideMenuController
        appDelegate?.window??.makeKeyAndVisible()
    }

    var sourceFromDragMap : GooglePlacesModel? = nil
    var destinationFromDragMap : GooglePlacesModel? = nil
}

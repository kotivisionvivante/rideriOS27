//


import UIKit
import GoogleMaps
import GooglePlaces
import SlideMenuControllerSwift

class DashboardViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet weak var viewWhere: UIView!
    @IBOutlet weak var viewBookRide: UIView!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var viewTopHC: NSLayoutConstraint!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewBookRiderBC: NSLayoutConstraint!
    @IBOutlet weak var viewPickup: PickupLocationView!
    @IBOutlet weak var viewPickupBC: NSLayoutConstraint!
    @IBOutlet weak var imageViewDragMarker: UIImageView!
    
    //MARK:- PROPERTIES
    
    var isMapLoaded : Bool = false
    var timer: Timer?
    var polyline = GMSPolyline()
    var animationPolyline = GMSPolyline()
    var path = GMSPath()
    var animationPath = GMSMutablePath()
    var i: UInt = 0
    var dashboardVM : DashboardVM? = nil
    var viewRideNib : BookRideV?
    var selectedRouteLocation: SourceDestinationDM?
    var totalDistance = String()
    var addedPlaceModel : AddedPlacesM?
    var savedPlacesVM : ListSavedPlacesVM?=nil
    var isShowDropOff = false
    var isPickLocationFromDrop = false
    let sourceMarker = GMSMarker()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imageViewDragMarker.isHidden = true
        self.mapView?.isMyLocationEnabled = true
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 20)
        self.mapView.settings.consumesGesturesInView = false
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panHandler(_:)))
        self.mapView.addGestureRecognizer(panGesture)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("updateLocation"), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(DashboardViewController.updateLocation), name: Notification.Name("updateLocation"), object: nil)
         LocationManagerH.sharedInstance.initLocationManager()
        dashboardVM = DashboardVM(delegate: self)
        showOrHideBookRide(isDrawRoute: false)
        savedPlacesVM = ListSavedPlacesVM(delegate: self)
        savedPlacesVM?.callWebService()
        globalSideMenuIndex = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isMapLoaded {
            isMapLoaded = !isMapLoaded
        }
    }
    
    
    @IBOutlet weak var driverDetailsContainer: UIView!
      
      @IBAction func opendriverDetailsBTN(_ sender: UIButton) {
          
          self.view.bringSubviewToFront(driverDetailsContainer)
      }
    
}

//MARK:- Custom Methods
extension DashboardViewController {
    func showProvidersOnMap(serviceProviders: [ServiceProvidersM]?, currentLocation: CLLocationCoordinate2D) {
        let circle = GMSCircle(position: currentLocation, radius: 20000)
        for provider in serviceProviders ?? [] {
            let latitude = CLLocationDegrees(provider.latitude ?? "") ?? 0.00
            let longitude = CLLocationDegrees(provider.longitude ?? "") ?? 0.00
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            print("location: \(location)")
            let marker = GMSMarker()
            marker.icon = UIImage(named: "DummyCar_icon")!
            marker.position = location
            marker.map = mapView
        }
        let update = GMSCameraUpdate.fit(circle.bounds())
        mapView.moveCamera(update)
    }
    
    func addMarker(sourceDestinationM: SourceDestinationDM?) {
        let source = sourceDestinationM?.sourceLocation
        let destination = sourceDestinationM?.destinationLocation
        let stop = sourceDestinationM?.stopLocation
        
        //let sourceMarker = GMSMarker()
        sourceMarker.position =  CLLocationCoordinate2D(latitude: source?.latitude ?? 0.00, longitude: source?.longitude ?? 0.00)
        sourceMarker.icon = UIImage(named: "source_marker")!
        sourceMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        sourceMarker.map = mapView
        
        let destinationMarker = GMSMarker()
        destinationMarker.position = CLLocationCoordinate2D(latitude: destination?.latitude ?? 0.00, longitude: destination?.longitude ?? 0.00)
        destinationMarker.icon = UIImage(named: "destination_marker")!
        destinationMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        destinationMarker.map = mapView
        
     
        for i in 0..<(stop?.count ?? 0) {
            let stopObject = stop?[i]
            if stopObject == nil {
                continue
            }
            let stopMarker = GMSMarker()
            stopMarker.position = CLLocationCoordinate2D(latitude: stopObject?.latitude ?? 0.00, longitude: stopObject?.longitude ?? 0.00)
            stopMarker.icon = UIImage(named: "stop_marker")!
            stopMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            stopMarker.map = mapView
        }
         showOrHideBookRide(isDrawRoute: true)
    }
    
    func showOrHideBookRide(isDrawRoute:Bool) {
      
        if isDrawRoute {
            NSLayoutConstraint.activate([viewTopHC])
            viewBookRiderBC.constant = 0
            viewPickupBC.constant = -210
            imageViewDragMarker.isHidden = true
            slideMenuController()?.removeLeftGestures()
            viewTop.isHidden = isDrawRoute
            buttonBack.isHidden = !isDrawRoute
        }
        else {
            if viewPickupBC.constant == 0 {
                viewBookRiderBC.constant = 0
                viewPickupBC.constant = -210
                imageViewDragMarker.isHidden = true
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
                return
            }
            
            if isShowDropOff {
                isShowDropOff = false
                viewRideNib?.hideDropOffView()
                viewTop.isHidden = !isDrawRoute
                buttonBack.isHidden = isDrawRoute
            }
            else {
                NSLayoutConstraint.deactivate([viewTopHC])
                viewBookRiderBC.constant = -320
                clearMapWithPolyline()
                slideMenuController()?.addLeftGestures()
                viewTop.isHidden = isDrawRoute
                buttonBack.isHidden = !isDrawRoute
            }
        }
    }
    
    func clearMapWithPolyline() {
        self.timer?.invalidate()
        self.timer = nil
        self.polyline.map = nil
        self.animationPolyline.map = nil
        mapView.clear()
    }
    
    func getDragLocation() {
        let mapSize = self.mapView.frame.size
        let point = CGPoint(x: mapSize.width/2, y: mapSize.height/2)
        let newCoordinate = self.mapView.projection.coordinate(for: point)
        print(newCoordinate)
        //do task here
        LocationManagerH.sharedInstance.getAddressFromLatLonGeo(pdblLatitude: "\(newCoordinate.latitude )", withLongitude: "\(newCoordinate.longitude)") { (name,locality) in
            let address = "\(name),\(locality)"
            let location = GooglePlacesModel(primaryPlace: address, secondaryPlace: "", fullAddress: "", placeID: "", latitude: newCoordinate.latitude, longitude: newCoordinate.longitude, titleHomeWork: "", iconName: "", locationId: "")
            self.viewPickup.selectedLocationDrag = location
            self.viewPickup.labelPickupLocation.text = address
        }
    }
}

//MARK:- Action
extension DashboardViewController {
    
    @objc private func panHandler(_ pan : UIPanGestureRecognizer){
        
        if pan.state == .ended{
            getDragLocation()
        }
    }
    
    @objc func updateLocation(_ notification: NSNotification) {
        let latitude = notification.userInfo?["latitude"] as? CLLocationDegrees ?? 0.00
        let longitude = notification.userInfo?["longitude"] as? CLLocationDegrees ?? 0.00
        let currentLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        dashboardVM?.listServiceProvider(location: currentLocation)
    }

    @IBAction func buttonActionBack(_ sender: UIButton) {
        if isPickLocationFromDrop {
            isPickLocationFromDrop = false
            NSLayoutConstraint.deactivate([viewTopHC])
            viewPickupBC.constant = -210
            clearMapWithPolyline()
            slideMenuController()?.addLeftGestures()
            viewTop.isHidden = false
            buttonBack.isHidden = true
            imageViewDragMarker.isHidden = true
            return
        }
        showOrHideBookRide(isDrawRoute:false)
    }
    
    @IBAction func buttonActionWhereToGo(_ sender: UIButton) {
        //        self.presentVC(storyboard: .SideMenu, viewController: .AddScheduleVC,
        //                       animated: true) { (vc) in
        //              (vc as? AddScheduleVC)?.delegate = self
        //              (vc as? AddScheduleVC)?.isFromSideMenu = false
        //        }
        self.pushVC(storyboard: .Dashboard, viewController: .SetupLocationVC, animated: true) { (vc) in
            (vc as? SetupLocationVC)?.delegate = self
            (vc as? SetupLocationVC)?.addedPlaceModel = addedPlaceModel
            (vc as? SetupLocationVC)?.isMapSearch = false
        }
    }
    
    @IBAction func showMenuButtonAction(_ sender: Any) {
        slideMenuController()?.toggleLeft()
    }
    
    @objc func animatePolylinePath() {
        if (self.i < self.path.count()) {
            self.animationPath.add(self.path.coordinate(at: self.i))
            self.animationPolyline.path = self.animationPath
            self.animationPolyline.strokeColor = UIColor.black
            self.animationPolyline.strokeWidth = 3
            self.animationPolyline.map = self.mapView
            self.i += 1
        }
        else {
            self.timer?.invalidate()
            self.timer = nil
            self.i = 0
            self.animationPath = GMSMutablePath()
        }
    }
}

//MARK:- Dashboard VM Delegate
extension DashboardViewController:DashboardVMDelegate {
    func getAvailableServices(servicesData: DriverServicesDM?) {
        totalDistance = servicesData?.total_distance ?? ""
        self.viewRideNib?.removeFromSuperview()
        viewRideNib = BookRideV(frame: self.viewBookRide.bounds)
        viewRideNib?.reloadRideView(driverData: servicesData)
        viewRideNib?.rideDelegate = self
        self.viewBookRide.addSubview(viewRideNib!)
    }
    
    func setupLocationPoints(points: Any?, sourceDestinationM: SourceDestinationDM?) {
        DispatchQueue.main.async {
            self.path = GMSPath.init(fromEncodedPath: "\(points ?? "")")!
            self.polyline = GMSPolyline.init(path: self.path)
            self.polyline.strokeWidth = 3.0
            self.polyline.strokeColor = .black
            self.polyline.map = self.mapView
//            self.timer = Timer.scheduledTimer(timeInterval: 0.003, target: self, selector: #selector(self.animatePolylinePath), userInfo: nil, repeats: true)
            self.addMarker(sourceDestinationM: sourceDestinationM)
            let bounds = GMSCoordinateBounds(path: self.path)
            let cameraUpdate = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 40, left: 15, bottom: 50, right: 15))
            self.mapView.animate(with: cameraUpdate)
            self.isPickLocationFromDrop = false
        }
    }
    
    func getServiceProviders(serviceProviders: [ServiceProvidersM]?, currentLocation: CLLocationCoordinate2D) {
        showProvidersOnMap(serviceProviders: serviceProviders, currentLocation: currentLocation)
    }

}

//MARK:- Setup Location VC Delegare
extension DashboardViewController:SetupLocationVCDelegate {
    func updateSavedPlaces(addedPlaceModel: AddedPlacesM?) {
        self.addedPlaceModel = addedPlaceModel
    }
    
    func setupRoute(sourceDestinationM: SourceDestinationDM?, isSavedAndStop: Bool) {
        clearMapWithPolyline()
        selectedRouteLocation = sourceDestinationM
        dashboardVM?.drawRouteGoogleApi(sourceDestinationM: sourceDestinationM)
        if isSavedAndStop {
            popViewControllerDashboard()
        }
        else {
            popViewController()
        }
    }
    
    func addPickUpLocationThroughMap(selected: String?, isSearch: Bool) {
        clearMapWithPolyline()
        popViewController(animate: false)
        showPickupView()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        slideMenuController()?.removeLeftGestures()
        viewTop.isHidden = true
        NSLayoutConstraint.activate([viewTopHC])
        buttonBack.isHidden = false
        self.viewPickup.selectedLocation = selected
        self.viewPickup.isSearch = isSearch
        self.viewPickup.pickUpDelegate = self
        self.viewPickup.searchLocationDelegate = self
        isPickLocationFromDrop = true
        getDragLocation()
    }
}
//MARK:- Search Location Delegate
extension DashboardViewController: SearchLocationDelegate {
    func searchLocation() {
        DispatchQueue.main.async {
            self.presentVC(storyboard: .Dashboard, viewController: .SearchVC, animated: true) { (vc) in
                (vc as! SearchViewController).delegate = self
                (vc as! SearchViewController).isHeartHide = true
            }
        }
    }
}
//MARK:- Search Controller Delegate
extension DashboardViewController:SearchVCDelegate {
    func selectedLocation(searchModel: GooglePlacesModel,selectedIndex:Int) {
        self.viewPickup.labelPickupLocation.text = searchModel.primaryPlace
        self.selectedRouteLocation?.sourceLocation = searchModel
        self.mapView.camera = GMSCameraPosition(latitude: searchModel.latitude, longitude: searchModel.longitude, zoom: 10)
    }
}
//MARK:- PickUp Location Delegate
extension DashboardViewController:PickupLocationDelegate {
    func sendRequestRide(selectedObject: DriverServicesM?, paymentMode: String) {
        dashboardVM?.getServicesApi(sourceDestinationM: selectedRouteLocation, selectedObject: selectedObject, paymentMode: paymentMode,totalDistance: totalDistance)
    }
    
    func pushToSearch(location: String?, selectedLocation: String?) {
        self.pushVC(storyboard: .Dashboard, viewController: .SetupLocationVC, animated: true) { (vc) in
            (vc as? SetupLocationVC)?.delegate = self
            (vc as? SetupLocationVC)?.addedPlaceModel = addedPlaceModel
            (vc as? SetupLocationVC)?.isMapSearch = true
            (vc as? SetupLocationVC)?.stringLocation = location
            (vc as? SetupLocationVC)?.stringSelected = selectedLocation ?? ""
        }
    }
}

//MARK:- Book Ride Delegate
extension DashboardViewController:BookRideVDelegate {
//    func bookRide(selectedObject: DriverServicesM?, paymentMode: String) {
//        dashboardVM?.getServicesApi(sourceDestinationM: selectedRouteLocation, selectedObject: selectedObject, paymentMode: paymentMode,totalDistance: totalDistance)
//    }
    
    func selectPaymentMethod() {
        self.pushVC(storyboard: .SideMenu, viewController: .PaymentMethodsVC, animated: true) { (vc) in
            (vc as? PaymentMethodsVC)?.isFromSideMenu = false
            (vc as? PaymentMethodsVC)?.paymentMethodsVCDelegate = self
        }
    }
    
    func dropOffViewShow() {
        isShowDropOff = true
    }
    
    func showPickupView() {
        
        viewPickup.driverData = viewRideNib?.driverData
        viewPickup.selectedObject = viewRideNib?.selectedObject
        viewPickup.pickUpDelegate = self
        viewPickup.searchLocationDelegate = self
        viewBookRiderBC.constant = -320
        viewPickupBC.constant = 0
        self.viewPickup.isSearch = false
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        imageViewDragMarker.isHidden = false
        clearMapWithPolyline()
        //getDragLocation()
        // show pickup location
        let camera = GMSCameraPosition.camera(withLatitude: selectedRouteLocation?.sourceLocation?.latitude ?? 0, longitude: selectedRouteLocation?.sourceLocation?.longitude ?? 0, zoom: 10)
        mapView?.camera = camera
        mapView?.animate(to: camera)
    }
    
    func showFareDetails(fareDetail : [FareDetails]?) {
        self.presentVC(storyboard: .Dashboard, viewController: .FareDetailsVC, animated: true) { (vc) in
            (vc as? FareDetailsVC)?.fareDetailsData = fareDetail
        }
    }
}

//MARK:- PaymentMethodVC Delegate
extension DashboardViewController:PaymentMethodsVCDelegate {
    func getMethodName(methodName: String, cardID: String) {
        viewRideNib?.setPaymentMethodName(methodName: methodName)
    }
}

//MARK:- Add Schedule VC Delegate
extension DashboardViewController:AddScheduleVCDelegate {
    func skipSchedule() {
        self.pushVC(storyboard: .Dashboard, viewController: .SetupLocationVC, animated: true) { (vc) in
            (vc as? SetupLocationVC)?.delegate = self
            (vc as? SetupLocationVC)?.isMapSearch = false

        }
    }
}

//MARK:- List Saved Places VM Delegate
extension DashboardViewController:ListSavePlacesVMDelegate {
    func removePlace() {
    }
    
    func savedPlaces(savedPlacesData: AddedPlacesM?) {
        addedPlaceModel = savedPlacesData
    }
}
//MARK:- Map View Delegate and Datasources
extension DashboardViewController:GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        print("Drag")
    }
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
            print("Old Coordinate - \(marker.position)")
    }
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
            print("New Coordinate - \(marker.position)")
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let coordinate = mapView.projection.coordinate(for: mapView.center)
        print(coordinate)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if gesture {
            print("dragged")
        }
    }
}



//MARK:- SlideMenuControllerDelegate
extension DashboardViewController : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftDidOpen")
    }
    
    func leftWillClose() {
        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
        print("SlideMenuControllerDelegate: leftDidClose")
    }
    
    func rightWillOpen() {
        print("SlideMenuControllerDelegate: rightWillOpen")
    }
    
    func rightDidOpen() {
        print("SlideMenuControllerDelegate: rightDidOpen")
    }
    
    func rightWillClose() {
        print("SlideMenuControllerDelegate: rightWillClose")
    }
    
    func rightDidClose() {
        print("SlideMenuControllerDelegate: rightDidClose")
    }
    
}

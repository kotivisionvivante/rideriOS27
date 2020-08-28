//


import Foundation
import CoreLocation
import ObjectMapper

protocol DashboardVMDelegate {
    func setupLocationPoints(points:Any?,sourceDestinationM:SourceDestinationDM?)
    func getAvailableServices(servicesData:DriverServicesDM?)
    func getServiceProviders(serviceProviders:[ServiceProvidersM]?,currentLocation:CLLocationCoordinate2D)
}

class DashboardVM:NSObject {
    
    //MARK:- Variables
    var dashboardVMDelegate :DashboardVMDelegate?
    
    //MARK:- Init
    
    init(delegate:DashboardVMDelegate) {
        self.dashboardVMDelegate = delegate
    }
    
}

//MARK:- Service Implementation
extension DashboardVM {
    
    func drawRouteGoogleApi(sourceDestinationM:SourceDestinationDM?) {
        
        let source = sourceDestinationM?.sourceLocation
        let destination = sourceDestinationM?.destinationLocation
        let stop = sourceDestinationM?.stopLocation
        
        let sourceLat = "\(source?.latitude ?? 0.00)"
        let sourceLong = "\(source?.longitude ?? 0.00)"
        
        let destinationLat = "\(destination?.latitude ?? 0.00)"
        let destinationLong = "\(destination?.longitude ?? 0.00)"
        
        
        var apiUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=\(sourceLat),\(sourceLong)&destination=\(destinationLat),\(destinationLong)&key=\(GOOGLEAPIKEY)&mode=driving"
        
        let stopObject1 =  stop?[0]
        let stopObject2 =  stop?[1]
        if stopObject1 != nil && stopObject2 != nil {
            let stopLat = "\(stopObject1?.latitude ?? 0.00)"
            let stopLong = "\(stopObject1?.longitude ?? 0.00)"
            let stopLat1 = "\(stopObject2?.latitude ?? 0.00)"
            let stopLong1 = "\(stopObject2?.longitude ?? 0.00)"
            apiUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=\(sourceLat),\(sourceLong)&destination=\(destinationLat),\(destinationLong)&waypoints=\("\(stopLat)%2C\(stopLong)%7C\(stopLat1)%2C\(stopLong1)")&key=\(GOOGLEAPIKEY)&mode=driving"
        }
        else {
            let object = stopObject1 == nil ? stopObject2 : stopObject1
            if object != nil {
                let stopLat = "\(object?.latitude ?? 0.00)"
                let stopLong = "\(object?.longitude ?? 0.00)"
                apiUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=\(sourceLat),\(sourceLong)&destination=\(destinationLat),\(destinationLong)&waypoints=\("\(stopLat),\(stopLong)")&key=\(GOOGLEAPIKEY)&mode=driving"
            }
        }
        
        let url = NSURL(string:apiUrl)
        let task = URLSession.shared.dataTask(with: url! as URL) { (data, response, error) -> Void in
            
            do {
                if data != nil {
                    let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as!  [String:AnyObject]
                    
                    let status = dic["status"] as! String
                    if status == "OK" {
                        let routesArray = dic ["routes"] as! NSArray
                        let routeDict = routesArray[0] as! Dictionary<String, Any>
                        let routeOverviewPolyline = routeDict["overview_polyline"] as! Dictionary<String, Any>
                        let points = routeOverviewPolyline["points"]
                        self.dashboardVMDelegate?.setupLocationPoints(points: points,sourceDestinationM: sourceDestinationM)
                        self.getServicesApi(sourceDestinationM: sourceDestinationM)
                    }
                }
            } catch {
                print("Error")
            }
        }
        
        task.resume()
    }
    
    func getServicesApi(sourceDestinationM:SourceDestinationDM?,
                        selectedObject: DriverServicesM?=nil,paymentMode:String="",totalDistance:String="") {
        let source = sourceDestinationM?.sourceLocation
        let destination = sourceDestinationM?.destinationLocation
        let stop = sourceDestinationM?.stopLocation
        
        var param = ["s_latitude":source?.latitude ?? 0.00,
                     "s_longitude":source?.longitude ?? 0.00,
                     "s_address":source?.primaryPlace ?? "",
                     "d_latitude":destination?.latitude ?? 0.00,
                     "d_longitude":destination?.longitude ?? 0.00,
                     "d_address":destination?.primaryPlace ?? ""] as [String : Any]
        
        var arrayStopLocation = [[String:Any]]()
        for i in 0..<(stop?.count ?? 0) {
            let stopObject = stop?[i]
            if stopObject == nil {
                continue
            }
            let dict = ["stop_no":i + 1, "data":["latitude":stopObject?.latitude ?? 0.00, "longitude":stopObject?.longitude ?? 0.00, "address":stopObject?.primaryPlace ?? ""]] as [String : Any]
            arrayStopLocation.append(dict)
        }
        param.updateValue(arrayStopLocation.count, forKey: "no_of_stopage")
        param.updateValue("", forKey: "stopage_data")
        if arrayStopLocation.count > 0 {
            param.updateValue(arrayStopLocation, forKey: "stopage_data")
        }
        
        var url = kget_services
        if selectedObject != nil {
            param.updateValue(selectedObject?.id ?? 0, forKey: "service_type")
            param.updateValue(totalDistance, forKey: "distance")
            param.updateValue(selectedObject?.arrival_time ?? "", forKey: "driver_arrival_time")
            param.updateValue("\(selectedObject?.total_price as? CVarArg ?? "")", forKey: "total_price")
            param.updateValue(paymentMode.uppercased(), forKey: "payment_mode")
            url = kride_sendRequest
            
            let (date,time) = UserDefaults.getSavedSchedule()
            let isSchedule = date == "" ? "0" : "1"
            let scheduleDate = date == "" ? convertDateFormatD(date: Date(), toFormat: "yyyy-MM-dd")  : date
            let scheduleTime = date == "" ? convertDateFormatD(date: Date(), toFormat: "HH:mm")  : time
            
            if isSchedule == "1" {
                UserDefaults.saveSchedule(date: "", time: "")
            }
            
            param.updateValue(isSchedule, forKey: "is_schedule")
            param.updateValue(scheduleDate, forKey: "schedule_date")
            param.updateValue(scheduleTime, forKey: "schedule_time")
        }
        
        ActivityIndicator.shared.showActivityIndicator()
        APIManager.shared.request(url: url, method: .post, parameters: param, tryAgain: false, completionCallback: { (response) in
             if selectedObject != nil {
             }else{
                ActivityIndicator.shared.hideActivityIndicator()
            }
        }, success: { (jsonResponse) in
            print(jsonResponse)
            if selectedObject != nil {
                
            }
            else {
                let data = Mapper<DriverServicesDM>().map(JSONObject: jsonResponse)
                self.dashboardVMDelegate?.getAvailableServices(servicesData: data ?? nil)
            }
        }) { (error) in
            ActivityIndicator.shared.hideActivityIndicator()
            self.showWarningAlertWithTitle(title: "Alert!", message: error ?? "")
        }
    }
    
    func listServiceProvider(location:CLLocationCoordinate2D)  {
        let param = ["latitude":location.latitude ,
                     "longitude":location.longitude ]
        ActivityIndicator.shared.showActivityIndicator()
        APIManager.shared.request(url: kservice_provider, method: .post, parameters: param, tryAgain: false, completionCallback: { (response) in
            ActivityIndicator.shared.hideActivityIndicator()
        }, success: { (jsonResponse) in
            let data = Mapper<ServiceProvidersDM>().map(JSONObject: jsonResponse)
            self.dashboardVMDelegate?.getServiceProviders(serviceProviders: data?.data, currentLocation: location)
            
        }) { (error) in
            self.showWarningAlertWithTitle(title: "Alert!", message: error ?? "")
        }
    }
}

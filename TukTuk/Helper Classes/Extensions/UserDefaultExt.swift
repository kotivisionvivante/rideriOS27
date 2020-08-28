//
//  UserDefaultExt.swift
//  TukTuk
//
//  Created by Balkaran on 20/04/20.
//  Copyright © 2020 TukTuk Inc. All rights reserved.
//

import Foundation
import ObjectMapper

var GlobalUserDetail:PhoneVerifyDM? {
    get {
        let userDetail = UserDefaults.getUser()
        return userDetail
    }
    set(value) {
    }
}

private func getArchived(data:Any) -> Data {
    
    if let data = data as? String {
        do {
        let encodedData = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: true)
        return encodedData
        }
        catch {
            print("Something went Wrong")
        }
    }
    return Data()
}

private func getUnArchived(data:Data?) -> Any? {
    
    if data != nil {
        do {
            let decodedData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data ?? Data())
             return decodedData
        } catch  {
            print("Something went Wrong")
        }
    }
    return nil
}


extension UserDefaults {
    
    static func setUser(_ user: PhoneVerifyDM) {
        if let userJSON = Mapper<PhoneVerifyDM>().toJSONString(user) {
            standard.set(getArchived(data: userJSON), forKey: USER_DETAILS)
        }
    }
    
    static func getUser() -> PhoneVerifyDM? {
        if let userJSON =  getUnArchived(data: standard.value(forKey: USER_DETAILS) as? Data) as? String {
            return Mapper<PhoneVerifyDM>().map(JSONString: userJSON)
        }
        return nil
    }
    
   static func saveRecentSearch(arrayRecentSearch:[GooglePlacesModel]) {
        let encodedData = try! JSONEncoder().encode(arrayRecentSearch)
        standard.set(encodedData, forKey: "recentSearch")
        
    }
    
   static func getRecentSearch() -> [GooglePlacesModel] {
        guard let decoded  = standard.data(forKey: "recentSearch") else { return [GooglePlacesModel]()  }
        let decodedRecentSearch = try! JSONDecoder().decode([GooglePlacesModel].self, from: decoded)
        return decodedRecentSearch
    }
    
    static func saveSchedule(date:String,time:String) {
        
        let dict = ["date":date,
                      "time":time]
        standard.set(dict, forKey: "saveSchedule")
    }
    
    static func getSavedSchedule() -> (String,String) {
        
        let dict = standard.value(forKey: "saveSchedule") as? [String:String] ?? [:]
        return (dict["date"] ?? "",dict["time"] ?? "")
        
    }
}

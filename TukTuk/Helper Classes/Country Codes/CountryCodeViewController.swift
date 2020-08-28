//
//  CountryCodeViewController.swift
//  TukTuk
//
//  Created by Harjot Bharti on 18/02/20.
//  Copyright © 2020 TukTuk Inc. All rights reserved.
//


//MARK: Custom Delegate to pass selected Country Details

protocol CountryCodeDelegate:NSObjectProtocol {
    func didselectCounty(country: [String:String])
}

import UIKit
import Foundation

class CountryCodeViewController: UIViewController {
    
    private var CompleteArray = [[String:String]]()
    private var FilterDataArray = [[String:String]]()
    private var pathIndex: IndexPath?
    weak var delegate: CountryCodeDelegate?
    
    @IBOutlet var CountryTabel: UITableView!
    @IBOutlet var CodeSearch: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        showNavigationBar()
        let leftBarButton = UIBarButtonItem.itemWith(colorfulImage: UIImage(named: "BtnBack_ICON"), target: self, action: #selector(CountryCodeViewController.myBarButtonItemTapped(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
        //MARK: Change json file to Dict.
        if let path = Bundle.main.path(forResource: "countryCodes", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let totalArray = json as? [[String: String]] {
                    CompleteArray = totalArray
                    FilterDataArray = CompleteArray
                }
            } catch let error { print(error.localizedDescription) }
        }
    }
    
    @objc func myBarButtonItemTapped(_ sender: UIBarButtonItem) {
        popViewController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideNavigationBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        hideNavigationBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
}


extension CountryCodeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FilterDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CountryCodeCell = tableView.dequeueReusableCell(withIdentifier: "CountryCodeCell", for: indexPath) as! CountryCodeCell
        let data = FilterDataArray[indexPath.row]
        cell.countryNameLbl.text = data["name"]
        cell.countryCodeLbl.text = data["dial_code"]
        cell.countryImage.image = UIImage.init(named: data["code"] ?? "")
        cell.selectionStyle = .none
        return cell
    }
    
    //MARK: TabelView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pathIndex = indexPath
        if self.delegate != nil {
            self.delegate?.didselectCounty(country: FilterDataArray[indexPath.row])
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

extension CountryCodeViewController: UISearchBarDelegate {
    
    //MARK: SearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "\n" {
            searchBar.resignFirstResponder()
        } else {
            FilterDataArray = searchText.isEmpty ? CompleteArray : CompleteArray.filter({ (item:[String:String]) -> Bool in
                let data = String(describing: item)
                return data.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            })
            CountryTabel.reloadData()
        }
    }
    
}

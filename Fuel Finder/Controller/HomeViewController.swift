//
//  HomeViewController.swift
//  FuelFinder
//
//  Created by D M.
//

import UIKit
import CoreLocation
import MapKit
import Foundation
import Combine

class HomeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate {
   
    
    
    //MARK: Outlets
    //-------------
    @IBOutlet weak var fuelListView: UITableView!
    

    //MARK: Properties
    //----------------
    var locationMananger:CLLocationManager!
    private let gasPriceFetcher = GasPriceFetcher.getInstance()
    private var gasStationData: [GasPrice] = [GasPrice]()
    private var cancellables : Set<AnyCancellable> = []

    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        navigationItem.hidesBackButton = true
        tabBarController?.tabBar.isHidden = false
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fuelListView.delegate = self
        self.fuelListView.dataSource = self
        self.getGasPriceChange()
        self.gasPriceFetcher.priceDataRecivedFromAPI()
        self.fuelListView.reloadData()
        
      
    }
    
  
    
    
    private func getGasPriceChange(){
        self.gasPriceFetcher.$gasPriceData.receive(on: RunLoop.main).sink{(updatedLaunchObjects) in
            self.gasStationData.removeAll()
            self.gasStationData.append(contentsOf: updatedLaunchObjects)
            self.fuelListView.reloadData()
        }
        .store(in: &cancellables)
    }

    

    
    //MARK: Table view
    //----------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gasStationData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let gasDetailCell = fuelListView.dequeueReusableCell(withIdentifier: "gasStationView", for: indexPath)
   
        
        var viewSource = gasDetailCell.defaultContentConfiguration()
        viewSource.text = "\(gasStationData[indexPath.row].name)"
        viewSource.secondaryText = "Normal Gas: \(gasStationData[indexPath.row].normalGas) Premium Gas: \(gasStationData[indexPath.row].premiumGas)"
        
        gasDetailCell.contentConfiguration = viewSource
        return gasDetailCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let toGasStationDetailScreen = storyboard?.instantiateViewController(withIdentifier: "gasDetailsScreen") as? GasDetailsViewController else{
            print("Gas Detail view not found")
            return
        }
        navigationController?.pushViewController(toGasStationDetailScreen, animated: true)
        toGasStationDetailScreen.gasDetail = gasStationData[indexPath.row]
    }

}

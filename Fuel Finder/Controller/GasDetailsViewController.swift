//
//  GasDetailsViewController.swift
//  FuelFinder
//
//  Created by D M.
//

import UIKit


class GasDetailsViewController: UIViewController {
    
    //MARK: Outlets
    //----------------
    
    @IBOutlet weak var fuelLocationName: UILabel!
    @IBOutlet weak var fuelLocationAddress: UILabel!
    @IBOutlet weak var fuelLocationPhoneNo: UILabel!
    @IBOutlet weak var fuelLocationNormalPrice: UILabel!
    @IBOutlet weak var fuelLocationPremiumPrice: UILabel!
    
    
    //MARK: Properties
    //----------------
    var gasDetail:GasPrice? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        navigationItem.hidesBackButton = false
        tabBarController?.tabBar.isHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let gasDetail = gasDetail{
            fuelLocationName.text = gasDetail.name
            fuelLocationAddress.text = gasDetail.address
            fuelLocationNormalPrice.text = String(gasDetail.normalGas)
            fuelLocationPremiumPrice.text = String(gasDetail.premiumGas)
        }
        
    }
    

    
}

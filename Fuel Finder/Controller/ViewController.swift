//
//  ViewController.swift
//  FuelFinder
//
//  Created by D M.
//

import UIKit
import Foundation

class ViewController: UIViewController {

   

    //MARK: Properties
    //----------------
    var defaults:UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        navigationItem.hidesBackButton = true
        tabBarController?.tabBar.isHidden = false
    }
    
    
    func checkFirstLaunch(){
        let firstLaunchCheck:String? = self.defaults.string(forKey: "KEY_FIRST_LAUNCH")
            if (firstLaunchCheck != nil ){
                
                guard let toHomeScreen = storyboard?.instantiateViewController(withIdentifier: "tabViewScreen")else{
                    print("Home Screen not found")
                    return
                }
                self.navigationController?.pushViewController(toHomeScreen, animated: true)
                                    
            }
    }
    
    
    @IBAction func getStartedButton(_ sender: Any) {
        defaults.set("true", forKey: "KEY_FIRST_LAUNCH")
        
        guard let toHomeScreen = storyboard?.instantiateViewController(withIdentifier: "tabViewScreen")else{
            print("Home Screen not found")
            return
        }
        
        self.navigationController?.pushViewController(toHomeScreen, animated: true)
    
    }
    

}


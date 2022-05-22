//
//  ViewController.swift
//  Fuel Finder
//
//  Created by D M on 2022-05-19.
//

import UIKit

class ViewController: UIViewController {
    
    
    //MARK: Properties
    //----------------
    var defaults:UserDefaults = UserDefaults.standard
      
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       checkFirstLaunch()
       
    }
    
  
    func checkFirstLaunch(){
        let firstLaunchCheck:String? = self.defaults.string(forKey: "KEY_FIRST_LAUNCH")
            if (firstLaunchCheck != nil ){
                
                guard let toSignInScreen = storyboard?.instantiateViewController(withIdentifier: "signInScreen")else{
                    print("Signup Screen not found")
                    return
                }
                
                self.navigationController?.pushViewController(toSignInScreen, animated: true)
                        
            }
    }
    
    //MARK: Action
    //----------------

    
    @IBAction func getStartedBtn(_ sender: Any) {
 
                defaults.set("true", forKey: "KEY_FIRST_LAUNCH")
                
                guard let toSignInScreen = storyboard?.instantiateViewController(withIdentifier: "signInScreen")else{
                    print("Signup Screen not found")
                    return
                }
                
                self.navigationController?.pushViewController(toSignInScreen, animated: true)
            }
     
}


//
//  GasPriceFetcher.swift
//  FuelFinder
//
//  Created by D M.
//

import Foundation


class GasPriceFetcher : ObservableObject{
    var priceApiURL = "https://raw.githubusercontent.com/dharmikM/fuelFinderAPi/main/fuelPrice.json"
    
    
    @Published var gasPriceData = [GasPrice]()
    
    private static var sharedPrice : GasPriceFetcher?
    
    static func getInstance() -> GasPriceFetcher{
        if sharedPrice == nil{
            sharedPrice = GasPriceFetcher()
        }
        return sharedPrice!
    }
    
    
    func priceDataRecivedFromAPI(){
        
        guard let priceApiCheck = URL(string: priceApiURL) else{
            print("Unable to get URL from the string")
            return
        }
        
        URLSession.shared.dataTask(with: priceApiCheck){
            (priceData:Data?,responseFromURL : URLResponse?,issueError:Error?) in
            
            if let issueError = issueError {
                print("Error occued while loading \(issueError)")
                
            }
            else{
                
                if let httpResponse = responseFromURL as? HTTPURLResponse{
                    if httpResponse.statusCode == 200{
                       
                        DispatchQueue.global().async {
                            do{
                                if (priceData != nil){
                                    if let jsonDataFromGS = priceData{
                                        
                                        let decoder = JSONDecoder()
                                        
                                        let decodedGasStationDetails = try decoder.decode([GasPrice].self, from: jsonDataFromGS)
                                        
                                            DispatchQueue.main.async {
                                                self.gasPriceData = decodedGasStationDetails
                                                    }
                                        

                                    }
                                }
                            }catch let issueError {
                                print("error \(issueError)")
                            }
                        }
                    }
                    else{
                        print("Unsuccessful response from network call")
                    }
                }
            }
            
        }.resume()
    }
}

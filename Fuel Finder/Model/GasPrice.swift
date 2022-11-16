//
//  GasPrice.swift
//  FuelFinder
//
//  Created by D M.
//

import Foundation


struct GasPrice : Decodable{
    
    
    let id: String
    let name : String
    let normalGas: Double
    let premiumGas : Double
    let address :String
    
    enum gasPriceKeys: String,CodingKey{
        case id = "phoneNumber"
        case name = "name"
        case address = "Address"
        case normalGas = "NormalGas"
        case premiumGas = "PremiumGas"
        
    }
    
    
    init(from decoder: Decoder) throws {
        let priceContainer = try decoder.container(keyedBy: gasPriceKeys.self)
        
        self.id = try priceContainer.decodeIfPresent(String.self, forKey: .id) ?? "Not Available"
        self.name = try priceContainer.decodeIfPresent(String.self, forKey: .name) ?? "Not Available"
        self.address = try priceContainer.decodeIfPresent(String.self, forKey: .address) ?? "Not Available"
        self.normalGas = try priceContainer.decodeIfPresent(Double.self, forKey: .normalGas) ?? 0.00
        self.premiumGas = try priceContainer.decodeIfPresent(Double.self, forKey: .premiumGas) ?? 0.00
    
    }
    
}

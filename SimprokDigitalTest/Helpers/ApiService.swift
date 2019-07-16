//
//  ApiService.swift
//  SimprokDigitalTest
//
//  Created by md760 on 7/16/19.
//  Copyright © 2019 md760. All rights reserved.
//

import Foundation
import UIKit

final class Singleton {
    static let shared = Singleton()
    
    private init() {}
    
    enum DataError: String, Error, LocalizedError {
        case error = "Error"
        var errorDescription: String? { return rawValue }
    }
    
    
    func fetchRequest(urlString: String, complition: @escaping ([InstructorsModel]?, Error?) -> () ) {
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                complition(nil, error)
                return }
            
            guard let unwrappedData = data else {
                complition(nil, DataError.error)
                return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers)
                
                DispatchQueue.main.async {
                    complition(self.instructorsDataFromJson(json), nil)
                }
                
            } catch let jsonError {
                complition(nil, jsonError)
            }
            }.resume()
    }
    
    private func instructorsDataFromJson(_ json: Any?) -> [InstructorsModel] {
        
        var insModels = [InstructorsModel]()
        if let data = json as? [[String: Any]] {
            for dataDictionary in data  {
                
                if let id = dataDictionary["id"] as? Double,
                    let login = dataDictionary["login"] as? String,
                    let avatarUrl = dataDictionary["avatar_url"] as? String,
                    let type = dataDictionary["type"] as? String?,
                    let siteAdmin = dataDictionary["site_admin"] as? Bool?
                {
                    var insModel = InstructorsModel()
                    insModel.id = id
                    insModel.login = login
                    insModel.avatarUrl = avatarUrl
                    insModel.type = type
                    insModel.siteAdmin = siteAdmin
                    insModels.append(insModel)
                }
            }
        }
        return insModels
    }
}

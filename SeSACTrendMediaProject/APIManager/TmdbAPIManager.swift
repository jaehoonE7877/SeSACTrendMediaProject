//
//  TmdbAPIManager.swift
//  SeSACTrendMediaProject
//
//  Created by Seo Jae Hoon on 2022/08/08.
//

import Foundation

import Alamofire
import SwiftyJSON

class TmdbAPIManager {
    
    static let shared = TmdbAPIManager()
    
    private init() { }
    
    func requestData(type: Endpoint, startPage: Int, tvId: Int, completionHandler: @escaping (JSON) -> () ) {
        
        var url = ""
        
        if type == .trending {
            url = type.requestURL + "&page=\(startPage)"
        } else if type == .genre {
            url = type.requestURL
        } else if type == .cast {
            url = type.requestURL + "\(tvId)/credits?api_key=\(APIKey.key)&language=en-US"
        } else if type == .trailer {
            url = type.requestURL + "\(tvId)/videos?api_key=\(APIKey.key)&language=en-US"
        }
        
        AF.request(url, method: .get).validate().responseData { response in //앞쪽 접두어 AF로 바꿔야 함
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                completionHandler(json)
                
            case .failure(let error):
                print(error)
            }
        }
                
    }
    
}

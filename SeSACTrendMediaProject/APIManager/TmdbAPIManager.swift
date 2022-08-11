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
    
    let tvList = [("이상한 변호사 우영우", 197067),
                  ("이태원 클라스" , 96162),
                  ("워킹데드" , 1402),
                  ("오징어게임" , 93405),
                  ("지금 우리 학교는" , 99966)
    ]
    // movie로 선택하
    let movieList = [String]()
    
    
    func requestData(type: Endpoint, startPage: Int, tvId: Int, completionHandler: @escaping (JSON) -> () ) {
        
        var url = ""
        
        if type == .trending {
            url = type.requestURL + "&language=ko-KR&page=\(startPage)"
        } else if type == .genre {
            url = type.requestURL
        } else if type == .cast {
            url = type.requestURL + "\(tvId)/credits?api_key=\(APIKey.key)&language=ko-KR"
        } else if type == .trailer {
            url = type.requestURL + "\(tvId)/videos?api_key=\(APIKey.key)&language=ko-KR"
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
    
    func callTvRequest(query: Int, completionHandler: @escaping ([String]) -> () ) {
        
        let url = "https://api.themoviedb.org/3/tv/\(query)/recommendations?api_key=\(APIKey.key)&language=ko-KR"
        
        AF.request(url, method: .get).validate().responseData { response in //앞쪽 접두어 AF로 바꿔야 함
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                
                let data = json["results"].map { $0.1["poster_path"].stringValue }
                //dump(data)
                completionHandler(data)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func requestPoster(completionHandler: @escaping ([[String]]) -> ( ) ) {
        
        var posterImageList = [[String]]()
        
        TmdbAPIManager.shared.callTvRequest(query: tvList[0].1) { value in
            posterImageList.append(value)
            
            TmdbAPIManager.shared.callTvRequest(query: self.tvList[1].1) { value in
                posterImageList.append(value)
                
                TmdbAPIManager.shared.callTvRequest(query: self.tvList[2].1) { value in
                    posterImageList.append(value)
                    
                    TmdbAPIManager.shared.callTvRequest(query: self.tvList[3].1) { value in
                        posterImageList.append(value)
                        
                        TmdbAPIManager.shared.callTvRequest(query: self.tvList[4].1) { value in
                            posterImageList.append(value)
                            completionHandler(posterImageList)
                            
                        }
                    }
                }
            }
        }
    }
    
    
}

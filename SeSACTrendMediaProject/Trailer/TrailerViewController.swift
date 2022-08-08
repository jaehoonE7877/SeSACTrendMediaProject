//
//  TrailerViewController.swift
//  SeSACTrendMediaProject
//
//  Created by Seo Jae Hoon on 2022/08/08.
//

import UIKit
import WebKit

class TrailerViewController: UIViewController {
    
    static let identifier = "TrailerViewController"

    @IBOutlet weak var trailerView: WKWebView!
    
    var tvId: Int?
    var destinationURL: String = "https://www.youtube.com/watch?v="
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        requestTrailer()
    }
    
    func requestTrailer() {
        
        guard let tvId = tvId else { return }

        TmdbAPIManager.shared.requestData(type: .trailer, startPage: 0, tvId: tvId) { json in
            let trailerKey = json["results"][0]["key"].stringValue
        
            self.openWeb(key: trailerKey)
        }
        
    }
    
    func openWeb(key: String) {
        guard let url = URL(string: destinationURL+key) else {
            print("Invalid URl")
            return
        }
        let request = URLRequest(url: url)
        trailerView.load(request)
        
    }
    
}

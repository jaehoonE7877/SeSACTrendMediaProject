//
//  SearchTVViewController.swift
//  SeSACTrendMediaProject
//
//  Created by Seo Jae Hoon on 2022/08/03.
//

import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher

class SearchTVViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    

    @IBOutlet weak var searchTVCollectionView: UICollectionView!
    
    var tvList = [TVModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchTVCollectionView.delegate = self
        searchTVCollectionView.dataSource = self
        
        designCellLayout()
        requestData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tvList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = searchTVCollectionView.dequeueReusableCell(withReuseIdentifier: SearchTVCollectionViewCell.identifier, for: indexPath) as? SearchTVCollectionViewCell else { return UICollectionViewCell() }
        
        
        
        
        
        return cell
    }

    func designCellLayout() {
        
        let layout = UICollectionViewFlowLayout()
        
        let spacing: CGFloat = 16
        
        let width = UIScreen.main.bounds.width - (spacing * 2)
        
        layout.itemSize = CGSize(width: width , height: width * 1.2 )
        
        layout.scrollDirection = .vertical
        
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        searchTVCollectionView.collectionViewLayout = layout
        
    }

    func requestData() {
        
        let url = EndPoint.tmdbUrl + APIKey.key
        
        AF.request(url, method: .get).validate().responseJSON { response in //앞쪽 접두어 AF로 바꿔야 함
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                for item in json["result"].arrayValue {
                    
                    let tvNm = item["title"].stringValue
                    let firstDt = item["first_air_date"].stringValue
                    let tvGenre = item["genre_ids"].arrayObject as! [Int]
                    let imageUrl = item["poster_path"].stringValue
                    let tvGrade = item["vote_average"].doubleValue
                    
                    let data = TVModel(firstDate: firstDt, genre: tvGenre, tvName: tvNm, grade: tvGrade, imageURL: imageUrl)
                    
                    self.tvList.append(data)
                }
                
                self.searchTVCollectionView.reloadData()
                
            case .failure(let error):
                print(error)
                
            }
        }
        
    }
    
    func designNavibar() {
        
    }
}

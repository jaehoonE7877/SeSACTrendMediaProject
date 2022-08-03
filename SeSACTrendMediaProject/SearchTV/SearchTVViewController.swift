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

    
    var tvList : [TVModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchTVCollectionView.delegate = self
        searchTVCollectionView.dataSource = self
        
        
        designNavibar()
        designShadow()
        designCellLayout()
        requestData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tvList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = searchTVCollectionView.dequeueReusableCell(withReuseIdentifier: SearchTVCollectionViewCell.identifier, for: indexPath) as? SearchTVCollectionViewCell else { return UICollectionViewCell() }
        
        cell.firstDateLabel.text = tvList[indexPath.item].firstDate
        cell.tvNameLabel.text = tvList[indexPath.item].tvName
        let url = URL(string: EndPoint.tmdbImageUrl+tvList[indexPath.item].imageURL)
        cell.tvImageView.kf.setImage(with: url)
        cell.gradeLabel.text = tvList[indexPath.item].grade
        
        searchTVCollectionView.reloadData()
        
        return cell
    }

    func designCellLayout() {
        
        let layout = UICollectionViewFlowLayout()
        
        let spacing: CGFloat = 24
        
        let width = UIScreen.main.bounds.width - (spacing * 2)
        
        layout.itemSize = CGSize(width: width , height: width * 1.4 )
        
        layout.scrollDirection = .vertical
        
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        layout.minimumLineSpacing = spacing * 4
        layout.minimumInteritemSpacing = spacing * 4
        
        searchTVCollectionView.collectionViewLayout = layout
        
    }

    func requestData() {
        
        let url = EndPoint.tmdbUrl + APIKey.key
        
        AF.request(url, method: .get).validate().responseJSON { response in //앞쪽 접두어 AF로 바꿔야 함
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                for item in json["results"] {
                    
                    let first_air_date = item.1["first_air_date"].stringValue
                    let genre_ids = item.1["genre_ids"].arrayObject as! [Int]
                    let name = item.1["name"].stringValue
                    let vote_average = item.1["vote_average"].doubleValue
                    let poster_path = item.1["poster_path"].stringValue
                    
                    let data = TVModel(firstDate: first_air_date, genre: genre_ids, tvName: name, grade: "\(round(vote_average * 100) / 100.0)", imageURL: poster_path)
                    
                    self.tvList.append(data)
                }
                
                self.searchTVCollectionView.reloadData()
                
            case .failure(let error):
                print(error)
                
            }
        }
        
    }
    
    func designNavibar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.triangle"), style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: nil, action: nil)
    }
    
    func getGenres(){
        
        
    }
}

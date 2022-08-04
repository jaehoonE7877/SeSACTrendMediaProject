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
import JGProgressHUD

class SearchTVViewController: UIViewController {
   
    
    @IBOutlet weak var searchTVCollectionView: UICollectionView!

    let hud = JGProgressHUD()
    
    var tvList : [TVModel] = []
    var genreList : [Int:String] = [:]
    var totalPage = 0
    var startPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchTVCollectionView.delegate = self
        searchTVCollectionView.dataSource = self
        
        searchTVCollectionView.prefetchDataSource = self
        
        collectionViewLayout()
        designNavibar()
        requestData()
        
    }

    func requestData() {
        
        hud.show(in: view)
        
        let url = EndPoint.tmdbUrl + APIKey.key + "&page=\(startPage)"
        let genreURL = EndPoint.genreUrl + APIKey.key
        
        AF.request(url, method: .get).validate(statusCode: 200...400).responseJSON { response in //앞쪽 접두어 AF로 바꿔야 함
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //print("JSON: \(json)")
                self.totalPage = json["total_pages"].intValue
                
                for item in json["results"] {
                    
                    let first_air_date = item.1["first_air_date"].stringValue
                    let genre_ids = item.1["genre_ids"][0].intValue
                    let name = item.1["name"].stringValue
                    let vote_average = item.1["vote_average"].doubleValue
                    let poster_path = item.1["poster_path"].stringValue
                    let overview = item.1["overview"].stringValue
                    let tvId = item.1["id"].intValue
                    
                    let data = TVModel(firstDate: first_air_date, genre: genre_ids, tvName: name, grade: vote_average, imageURL: poster_path, overview: overview, tvID: tvId)
                    
                    
                    self.tvList.append(data)
                }
                
                self.hud.dismiss(animated: true)
                self.searchTVCollectionView.reloadData()
                
            case .failure(let error):
                self.hud.dismiss(animated: true)
                print(error)
                
            }
        }
        
        AF.request(genreURL, method: .get).validate(statusCode: 200...400).responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                            //print("JSON: \(json)")
                        
                        for tvGenre in json["genres"].arrayValue {
                             
                            self.genreList.updateValue(tvGenre["name"].stringValue, forKey: tvGenre["id"].intValue)
                        }
                        self.hud.dismiss(animated: true)
                        self.searchTVCollectionView.reloadData()
                        
                    case .failure(let error):
                        self.hud.dismiss(animated: true)
                        print(error)
                    }
                    
                }
        
    }
    
    func designNavibar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.triangle"), style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: nil, action: nil)
    }
    
    
    @IBAction func detailButtonTapped(_ sender: UIButton) {
        
        

    }
    
    
    
}
// cell layout
extension SearchTVViewController {
    
    func collectionViewLayout() {
        
        let layout = UICollectionViewFlowLayout()
        
        let spacing: CGFloat = 20
        
        let width = UIScreen.main.bounds.width - (spacing * 2)
        
        layout.itemSize = CGSize(width: width , height: width * 1.4 )
        
        layout.scrollDirection = .vertical
        
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        layout.minimumLineSpacing = spacing * 3
        layout.minimumInteritemSpacing = spacing * 3
        
        searchTVCollectionView.collectionViewLayout = layout
        
    }
}

//페이지 네이션
extension SearchTVViewController : UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if tvList.count - 1 == indexPath.item && tvList.count < totalPage {
                startPage += 1
                requestData()
                
            }
        }
    }
    // 취소하는 기능 구현해야 함
//    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
//        //print("===취소\(indexPaths)")
//    }
    
}

// CollectionView Delegate, DataSource
extension SearchTVViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tvList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = searchTVCollectionView.dequeueReusableCell(withReuseIdentifier: SearchTVCollectionViewCell.identifier, for: indexPath) as? SearchTVCollectionViewCell else { return UICollectionViewCell() }
        
        //cell.designBackground()
        
        
        cell.firstDateLabel.text = tvList[indexPath.item].firstDate
        cell.tvNameLabel.text = tvList[indexPath.item].tvName
        let url = URL(string: EndPoint.tmdbImageUrl+tvList[indexPath.item].imageURL)
        cell.tvImageView.kf.setImage(with: url)
        cell.gradeLabel.text = String(format: "%.1f", tvList[indexPath.item].grade)
        
        for (key, value) in genreList {
            if tvList[indexPath.row].genre == key {
                cell.genreLabel.text = "# \(value)"
            }
        }
        
        searchTVCollectionView.reloadData()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("===============================")
        let sb = UIStoryboard(name: "DetailTV", bundle: nil)

        let vc = sb.instantiateViewController(withIdentifier: DetailTVViewController.identifier) as! DetailTVViewController

        vc.tvId = tvList[indexPath.item].tvID
        vc.overview = tvList[indexPath.row].overview

        self.navigationController?.pushViewController(vc, animated: true)
    }

}
    


//
//  IntroViewController.swift
//  SeSACTrendMediaProject
//
//  Created by Seo Jae Hoon on 2022/08/05.
//

import UIKit
import MyUIFramework

import Alamofire
import JGProgressHUD
import Kingfisher
import SwiftyJSON

class IntroViewController: UIViewController {
    
    @IBOutlet weak var introCollectionView: UICollectionView!
    
    let hud = JGProgressHUD()
    
    var tvList: [TvModel] = []
    var genreList: [Int : String] = [:]
    var startPage = 1
    var totalPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        introCollectionView.delegate = self
        introCollectionView.dataSource = self
        
        introCollectionView.prefetchDataSource = self
        
        introCollectionView.register(UINib(nibName: IntroCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: IntroCollectionViewCell.reuseIdentifier)
        
        designNavibar()
        collectionViewLayout()
        searchTrend()
        
    }
    
    func designNavibar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.triangle"), style: .plain, target: self, action: #selector(listButtonTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: nil, action: nil)
    }
    
    func searchTrend() {
        
        hud.show(in: view)
        
        TmdbAPIManager.shared.requestData(type: .trending, startPage: startPage, tvId: 0) { json in
            
            self.totalPage = json["total_pages"].intValue
            
            for item in json["results"] {
                
                let first_air_date = item.1["first_air_date"].stringValue
                let genre_ids = item.1["genre_ids"][0].intValue
                let name = item.1["name"].stringValue
                let vote_average = item.1["vote_average"].doubleValue
                let poster_path = item.1["poster_path"].stringValue
                let backdrop_path = item.1["backdrop_path"].stringValue
                let overview = item.1["overview"].stringValue
                let tvId = item.1["id"].intValue
                
                let data = TvModel(firstDate: first_air_date, genre: genre_ids, tvName: name, grade: vote_average, posterImageURL: poster_path, backdropImageURL : backdrop_path, overview: overview, tvID: tvId)
                
                self.tvList.append(data)
                
            }
            
            self.searchGenre()
        }
    }
    
    func searchGenre() {
        
        TmdbAPIManager.shared.requestData(type: .genre, startPage: startPage, tvId: 0) { json in
            
            for tvGenre in json["genres"].arrayValue {
                self.genreList.updateValue(tvGenre["name"].stringValue, forKey: tvGenre["id"].intValue)
         
            }
            DispatchQueue.main.async {
                self.introCollectionView.reloadData()
            }
            self.hud.dismiss(animated: true)
        }
        
    }

}

// CollectionView Cell Layout
extension IntroViewController {
    
    func collectionViewLayout() {
        
        let layout = UICollectionViewFlowLayout()
        
        let spacing: CGFloat = 24
        
        let width = UIScreen.main.bounds.width - (spacing * 2)
        
        layout.itemSize = CGSize(width: width , height: width * 1.2 )
        
        layout.scrollDirection = .vertical
        
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        layout.minimumLineSpacing = spacing * 2
        layout.minimumInteritemSpacing = spacing * 2
        
        introCollectionView.collectionViewLayout = layout
    }
    
    @objc
    func listButtonTapped() {
        
        
        transitionViewController(storyboard: "Cinema", viewController: CinemaViewController(), transitionStyle: .push)
        
//        let sb = UIStoryboard(name: "Cinema", bundle: nil)
//
//        guard let vc = sb.instantiateViewController(withIdentifier: CinemaViewController.reuseIdentifier) as? CinemaViewController else { return }
//
//        self.navigationItem.title = "MY MEDIA"
//        
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
}

// CollectionView delegate, datasource protocol
extension IntroViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tvList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = introCollectionView.dequeueReusableCell(withReuseIdentifier: IntroCollectionViewCell.reuseIdentifier, for: indexPath) as? IntroCollectionViewCell else { return UICollectionViewCell() }
        
        cell.firstDayLabel.text = tvList[indexPath.item].firstDate
        cell.tvNameLabel.text = tvList[indexPath.item].tvName
        let url = URL(string: Endpoint.tmdbImageUrl+tvList[indexPath.item].posterImageURL)
        cell.tvImageView.kf.setImage(with: url)
        cell.gradeLabel.text = String(format: "%.1f", tvList[indexPath.item].grade)
        cell.overviewLabel.text = tvList[indexPath.item].overview
        
        cell.tvNameLabel.font = UIFont.boldSystemFont(ofSize: 25)
        cell.overviewLabel.font = UIFont.systemFont(ofSize: 14)
        cell.genreLabel.font = UIFont.boldSystemFont(ofSize: 20)
        cell.firstDayLabel.backgroundColor = .white
        cell.genreLabel.backgroundColor = .white
        
        
        for (key, value) in genreList {
            if tvList[indexPath.row].genre == key {
                cell.genreLabel.text = "#\(value)"
            }
        }
        
        cell.trailerButton.tag = indexPath.row
        cell.trailerButton.addTarget(self, action: #selector(trailerButtonTapped), for: .touchUpInside)
        
        cell.layer2Shadow()
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let sb = UIStoryboard(name: "DetailTV", bundle: nil)

        let vc = sb.instantiateViewController(withIdentifier: DetailTVViewController.reuseIdentifier) as! DetailTVViewController

        vc.tvId = tvList[indexPath.item].tvID
        vc.overview = tvList[indexPath.item].overview
        vc.tvTitle = tvList[indexPath.item].tvName
        vc.backdropURL = tvList[indexPath.item].backdropImageURL
        vc.posterURL = tvList[indexPath.item].posterImageURL
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    func trailerButtonTapped(_ sender: UIButton){
        
        
        
        let sb = UIStoryboard(name: "Trailer", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: TrailerViewController.reuseIdentifier) as? TrailerViewController else { return }
        
        vc.tvId = tvList[sender.tag].tvID
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}



//page nation
extension IntroViewController : UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        
        for indexPath in indexPaths {
            if tvList.count - 1 == indexPath.item && tvList.count < totalPage {
                startPage += 1
                searchTrend()
            }
        }
    }
}

//
//  RecommandViewController.swift
//  SeSACTrendMediaProject
//
//  Created by Seo Jae Hoon on 2022/08/09.
//

import UIKit
import MyUIFramework

import Kingfisher
class RecommandViewController: UIViewController {

    @IBOutlet weak var recommandTableView: UITableView!
    
    
    var recommandList = [[String]]()
    
    var top10List = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        recommandTableView.delegate = self
        recommandTableView.dataSource = self
        
        recommandTableView.register(UINib(nibName: RecommandTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: RecommandTableViewCell.reuseIdentifier)
        
        TmdbAPIManager.shared.requestPoster { posterList in
            //dump(posterList)
            //1. 네트워크 통신 2. 배열 생성 3. 배열에 요소 담기 4. 뷰 등에 표현 5. 뷰 갱신!(reloadData)
            //self.requestTop10()
            
            self.recommandList = posterList
            self.recommandTableView.reloadData()
            print("RecommandViewController", #function)
            
        }
    }
    //지금 뜨는 콘텐츠 넣을 방법 생각해보기
//    func requestTop10() {
//
//        TmdbAPIManager.shared.requestData(type: .trending, startPage: 1, tvId: 0) { json in
//
//            let data = json["results"].map { $0.1["poster_path"].stringValue }
//            self.top10List = data
//        }
//    }
    
}
//TableView
extension RecommandViewController: UITableViewDelegate, UITableViewDataSource {
    
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommandList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecommandTableViewCell.reuseIdentifier, for: indexPath) as? RecommandTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .black
        cell.titleLabel.text = "\(TmdbAPIManager.shared.tvList[indexPath.row].0)와 비슷한 콘텐츠"
        
        
        cell.recommandCollectionView.delegate = self
        cell.recommandCollectionView.dataSource = self
        
        cell.recommandCollectionView.register(UINib(nibName: RecommandCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: RecommandCollectionViewCell.reuseIdentifier)
        
        cell.recommandCollectionView.tag = indexPath.row
        cell.recommandCollectionView.backgroundColor = .black
        
        //⭐️table view에 종속된 collection view를 cellForRowAt에서 reloadData()해주면 인덱스 오류를 막는데 그 이유??
        print("RecommandTableView", #function)
        cell.recommandCollectionView.reloadData()
        
        return cell
    }
    
    //특정 tableView Cell의 collectionViewCell height 바꾸는 방법??
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
}

//CollectionView
extension RecommandViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommandList[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommandCollectionViewCell.reuseIdentifier, for: indexPath) as? RecommandCollectionViewCell else { return UICollectionViewCell()}
        
        cell.posterImageView.backgroundColor = .blue
        
        
            
        let url = URL(string: "\(Endpoint.tmdbImageUrl)\(recommandList[collectionView.tag][indexPath.item])")
        cell.posterImageView.kf.setImage(with: url)
        
        return cell
    }
    
}

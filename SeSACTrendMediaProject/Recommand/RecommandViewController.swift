//
//  RecommandViewController.swift
//  SeSACTrendMediaProject
//
//  Created by Seo Jae Hoon on 2022/08/09.
//

import UIKit

class RecommandViewController: UIViewController {

    @IBOutlet weak var recommandTableView: UITableView!
    
    let mainLabelText = ["오늘 대한민국의 TOP 10 시리즈", "다시보기 추천 콘텐츠", "지금 뜨는 콘텐츠", "오직 넷플릭스 에서", "이태원 클라쓰와 비슷한 콘텐츠", "한국 드라마", "몰아보기 추천 시리즈", "미국 TV 프로그램"]
    let numArr: [[Int]] = [
        [Int](1...6),
        [Int](7...15),
        [Int](16...24),
        [Int](25...33),
        [Int](34...46),
        [Int](47...62),
        [Int](63...80),
        [Int](80...100)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        recommandTableView.delegate = self
        recommandTableView.dataSource = self
        
        recommandTableView.register(UINib(nibName: RecommandTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RecommandTableViewCell.reuseIdentifier)
        
        
    }
    

    

}


extension RecommandViewController: UITableViewDelegate, UITableViewDataSource {
    
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecommandTableViewCell.identifier, for: indexPath) as? RecommandTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .black
        cell.titleLabel.text = mainLabelText[indexPath.row]
        
        cell.recommandCollectionView.delegate = self
        cell.recommandCollectionView.dataSource = self
        
        cell.recommandCollectionView.register(UINib(nibName: RecommandCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: RecommandCollectionViewCell.reuseIdentifier)
        
        cell.recommandCollectionView.tag = indexPath.row
        cell.recommandCollectionView.backgroundColor = .black
        
        //⭐️table view에 종속된 collection view를 cellForRowAt에서 reloadData()해주면 인덱스 오류를 막는데 그 이유??
        cell.recommandCollectionView.reloadData()
        
        return cell
    }
    
    //특정 tableView Cell의 collectionViewCell height 바꾸는 방법??
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 3 ? 400 : 200
    }
    
    
    
}

extension RecommandViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numArr[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommandCollectionViewCell.reuseIdentifier, for: indexPath) as? RecommandCollectionViewCell else { return UICollectionViewCell()}
        
        cell.imageView.backgroundColor = .blue
        cell.nameLabel.text = "\(numArr[collectionView.tag][indexPath.item])"
        
        return cell
    }
    
    
    
}

//
//  RecommandTableViewCell.swift
//  SeSACTrendMediaProject
//
//  Created by Seo Jae Hoon on 2022/08/09.
//

import UIKit

class RecommandTableViewCell: UITableViewCell {

    static let identifier = "RecommandTableViewCell"
    
    
    @IBOutlet weak var recommandCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var cellWidth = UIScreen.main.bounds.width / 3.6
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
                
        
        setupUI()
        
    }

    func setupUI() {
        
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.text = "다시보기 추천 콘텐츠"
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = .systemGray4
        
        recommandCollectionView.collectionViewLayout = collectionViewLayout()
    }
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: cellWidth , height: cellWidth * 1.33 )
        
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        
        return layout
    }
    
    
}

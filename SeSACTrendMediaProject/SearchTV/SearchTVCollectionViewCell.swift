//
//  SearchTVCollectionViewCell.swift
//  SeSACTrendMediaProject
//
//  Created by Seo Jae Hoon on 2022/08/03.
//

import UIKit



class SearchTVCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SearchTVCollectionViewCell"
    
    @IBOutlet weak var firstDateLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var tvImageView: UIImageView!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var tvNameLabel: UILabel!
    @IBOutlet weak var gradeTitleLabel: UILabel!
    
    @IBOutlet weak var getDetailLabel: UILabel!
    
    @IBOutlet weak var cuttingView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    
        
//    func designBackground() {
//        
//        shadowView.layer.borderWidth = 1
//        shadowView.layer.masksToBounds = false
//        shadowView.layer.shadowColor = UIColor.black.cgColor
//        shadowView.layer.shadowOffset = CGSize(width: 0, height: 20)
//        shadowView.layer.shadowOpacity = 0.8
//        shadowView.layer.shadowRadius = 20.0
//        
//        cuttingView.layer.borderWidth = 1
//        cuttingView.layer.cornerRadius = 15
//        
//    }
}


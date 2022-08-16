//
//  IntroCollectionViewCell.swift
//  SeSACTrendMediaProject
//
//  Created by Seo Jae Hoon on 2022/08/05.
//

import UIKit

class IntroCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var firstDayLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var tvImageView: UIImageView!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var tvNameLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var trailerButton: UIButton!
    
    
    
    // 다시 해보기
    func layer2Shadow() {
            //shadowView.layer.masksToBounds = false
            shadowView.layer.borderColor = UIColor.white.cgColor
            shadowView.layer.shadowColor = UIColor.black.cgColor
            shadowView.layer.shadowOpacity = 1
            shadowView.layer.shadowRadius = 15
            shadowView.layer.shadowOffset = CGSize(width: 15, height: 15)
            shadowView.backgroundColor = .clear
        }
}

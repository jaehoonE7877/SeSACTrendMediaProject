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
    
    
    
    
    @IBAction func searchDetailButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func clipButtonTapped(_ sender: UIButton) {
    }
}

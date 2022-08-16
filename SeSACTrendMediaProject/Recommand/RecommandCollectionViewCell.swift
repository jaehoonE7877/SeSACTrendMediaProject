//
//  RecommandCollectionViewCell.swift
//  SeSACTrendMediaProject
//
//  Created by Seo Jae Hoon on 2022/08/09.
//

import UIKit

class RecommandCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("RecommandCollectionViewCell", #function)
        setupUI()
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("RecommandCollectionViewCell", #function)
        posterImageView.backgroundColor = .lightGray
    }
    
    private func setupUI() {
        
        posterImageView.layer.cornerRadius = 8
        posterImageView.contentMode = .scaleToFill
        
    }
    
}

//
//  RecommandCollectionViewCell.swift
//  SeSACTrendMediaProject
//
//  Created by Seo Jae Hoon on 2022/08/09.
//

import UIKit

class RecommandCollectionViewCell: UICollectionViewCell {

    static let identifier = "RecommandCollectionViewCell"
    
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    func setupUI() {
        
        //imageView.backgroundColor = .tintColor
        imageView.layer.cornerRadius = 10

        
    }
    
}

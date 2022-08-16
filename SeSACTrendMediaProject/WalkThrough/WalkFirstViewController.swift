//
//  WalkFirstViewController.swift
//  SeSACTrendMediaProject
//
//  Created by Seo Jae Hoon on 2022/08/16.
//

import UIKit

class WalkFirstViewController: UIViewController {
    
    @IBOutlet weak var centerImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.backgroundColor
        
        centerImageView.contentMode = .scaleToFill
        centerImageView.image = UIImage(named: "tvImage.png")
        centerImageView.alpha = 0
        
        UIView.animate(withDuration: 2) {
            self.centerImageView.alpha = 1
        } completion: { _ in
            
        }

    }
    

    

}

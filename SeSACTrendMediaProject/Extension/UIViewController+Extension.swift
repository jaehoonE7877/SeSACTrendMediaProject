//
//  UIViewController+Extension.swift
//  SeSACTrendMediaProject
//
//  Created by Seo Jae Hoon on 2022/08/20.
//

import UIKit

enum TransitionStyle {
    case present
    case fullScreenPresent
    case push
}


extension UIViewController {
    
    func transitionViewController<T: UIViewController>(storyboard: String, viewController vc: T, transitionStyle: TransitionStyle) {
        
        let sb = UIStoryboard(name: storyboard, bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: T.reuseIdentifier) as? T else { return }
        
        switch transitionStyle {
        case .present:
            self.present(vc, animated: true)
        case .fullScreenPresent:
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        case .push:
            self.navigationController?.pushViewController(vc, animated: true)
        
        }
    }
    
}

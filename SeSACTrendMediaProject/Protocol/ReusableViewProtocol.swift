//
//  ReusableViewProtocol.swift
//  SeSACTrendMediaProject
//
//  Created by Seo Jae Hoon on 2022/08/04.
//

import UIKit

protocol ReusableViewProtocol {
    
    static var reuseIdentifier: String { get }
    
}

// Extension은 메모리에 저장 프로퍼티 사용 불가능하다.
extension UIViewController: ReusableViewProtocol {
    static var reuseIdentifier: String {
         return String(describing: self)
    }
}

extension UITableViewCell: ReusableViewProtocol {
    static var reuseIdentifier: String {
         return String(describing: self)
    }
}

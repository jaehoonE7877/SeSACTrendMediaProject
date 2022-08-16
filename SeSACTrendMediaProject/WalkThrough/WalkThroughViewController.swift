//
//  WalkThroughViewController.swift
//  SeSACTrendMediaProject
//
//  Created by Seo Jae Hoon on 2022/08/16.
//

import UIKit

class WalkThroughViewController: UIPageViewController {
    
    //뷰컨을 넣을 배열 생성
    var pageViewControllerList: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.backgroundColor
        
        createPageViewController()
        configurePageViewController()
    }
    //배열에 뷰컨 추가
    func createPageViewController(){
        
        let sb = UIStoryboard(name: "WalkThrough", bundle: nil)
        let vc1 = sb.instantiateViewController(withIdentifier: WalkFirstViewController.reuseIdentifier) as! WalkFirstViewController
        let vc2 = sb.instantiateViewController(withIdentifier: WalkSecondViewController.reuseIdentifier) as! WalkSecondViewController
        let vc3 = sb.instantiateViewController(withIdentifier: WalkThirdViewController.reuseIdentifier) as! WalkThirdViewController
        
        pageViewControllerList = [vc1, vc2, vc3]
    }
    
    //delegate, datasource 프로토콜 연결
    func configurePageViewController() {
        delegate = self
        dataSource = self
        
        //display
        guard let first = pageViewControllerList.first else { return }
        setViewControllers([first], direction: .forward, animated: true)
    }
    
}

extension WalkThroughViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pageViewControllerList.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        return previousIndex < 0 ? nil : pageViewControllerList[previousIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
       
        guard let viewControllerIndex = pageViewControllerList.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        return nextIndex >= pageViewControllerList.count ? nil : pageViewControllerList[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageViewControllerList.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let first = viewControllers?.first, let index = pageViewControllerList.firstIndex(of: first) else { return 0 }
        
        return index
    }
    
}


//
//  WalkThirdViewController.swift
//  SeSACTrendMediaProject
//
//  Created by Seo Jae Hoon on 2022/08/16.
//

import UIKit

class WalkThirdViewController: UIViewController {

    @IBOutlet weak var walkthroughThirdStartButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.backgroundColor
        
        walkthroughThirdStartButton.setTitle("시작", for: .normal)
        //walkthroughThirdStartButton.setTitle("시작합니다!", for: .highlighted)
    }
    
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        
        UserDefaults.standard.set(true, forKey: "First")
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        let sb = UIStoryboard(name: "Intro", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: IntroViewController.reuseIdentifier) as? IntroViewController else { return }
        let nav = UINavigationController(rootViewController: vc)
        
        sceneDelegate?.window?.rootViewController = nav
        sceneDelegate?.window?.makeKeyAndVisible()
        
    }
    

}

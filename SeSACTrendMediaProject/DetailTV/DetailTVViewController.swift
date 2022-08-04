//
//  DetailTVViewController.swift
//  SeSACTrendMediaProject
//
//  Created by Seo Jae Hoon on 2022/08/04.
//

import UIKit

import Alamofire
import JGProgressHUD
import Kingfisher
import SwiftyJSON

class DetailTVViewController: UIViewController {
    
    static let identifier = "DetailTVViewController"
    
    let hud = JGProgressHUD()
    
    var tvId: Int?
    var overview: String?
    var tvTitle: String?
    var backdropURL: String?
    var posterURL: String?
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var tvTitleLabel: UILabel!
    
    @IBOutlet weak var detailTvTableView: UITableView!
    
    var detailTvList: [CastModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        detailTvTableView.delegate = self
        detailTvTableView.dataSource = self
        
        detailTvTableView.register(UINib(nibName: TVOverviewTableViewCell.reuseIdentifier , bundle: nil), forCellReuseIdentifier: TVOverviewTableViewCell.reuseIdentifier)
        
        detailTvTableView.register(UINib(nibName: TVCastTableViewCell.reuseIdentifier , bundle: nil), forCellReuseIdentifier: TVCastTableViewCell.reuseIdentifier)
        
        designImageView()
        requestData()
        
    }
    
    
    
    func requestData() {
        
        hud.show(in: view)
        
        guard let tvId = tvId else { return }
        
        let url = EndPoint.detailUrl + "\(tvId)/credits?api_key=\(APIKey.key)&language=en-US"
        let imageUrl =  EndPoint.detailUrl + "\(tvId)/images?api_key=\(APIKey.key)"
        
        AF.request(url, method: .get).validate().responseJSON { response in //앞쪽 접두어 AF로 바꿔야 함
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //print("JSON: \(json)")
                
                for item in json["cast"] {
                    
                    let actorImage = item.1["profile_path"].stringValue
                    let actorName = item.1["character"].stringValue
                    let actorRealName = item.1["name"].stringValue
                    
                    let data = CastModel(actorImage: actorImage, actorName: actorName, actorRealName: actorRealName)
                    
                    self.detailTvList.append(data)
                }
                self.hud.dismiss(animated: true)
                self.detailTvTableView.reloadData()
                
                
            case .failure(let error):
                self.hud.dismiss(animated: true)
                print(error)
            }
        }
    }
    
    
}

extension DetailTVViewController {
    
    func designImageView() {
        tvTitleLabel.text = tvTitle
        tvTitleLabel.textColor = .white
        tvTitleLabel.font = .boldSystemFont(ofSize: 23)
        
        guard let backdropURL = backdropURL else { return }
        guard let posterURL = posterURL else { return }
        
        
        let backImageUrl = URL(string: EndPoint.tmdbImageUrl+backdropURL)
        mainImageView.kf.setImage(with: backImageUrl)
        let posterImageUrl = URL(string: EndPoint.tmdbImageUrl+posterURL)
        posterImageView.kf.setImage(with: posterImageUrl)
        
    }
    
}


extension DetailTVViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 150
        } else {
            return 96
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "OverView"
        } else {
            return "Cast"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return detailTvList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let overview = overview else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            
            guard let cell = detailTvTableView.dequeueReusableCell(withIdentifier: CellIdentifier.detailTvOverviewCell, for: indexPath) as? TVOverviewTableViewCell else { return UITableViewCell() }
            cell.overviewLabel.numberOfLines = 0
            cell.overviewLabel.text = overview
            
            return cell
            
        } else {
            
            guard let cell = detailTvTableView.dequeueReusableCell(withIdentifier: CellIdentifier.detailTvCastCell, for: indexPath) as? TVCastTableViewCell else { return UITableViewCell() }
                
            cell.actorRealNameLabel.text = detailTvList[indexPath.item].actorRealName
            cell.actingNameLabel.font = UIFont.boldSystemFont(ofSize: 17)
            cell.actingNameLabel.text = detailTvList[indexPath.item].actorName
            cell.actingNameLabel.textColor = UIColor.systemGray4
            let imageUrl = URL(string: EndPoint.tmdbImageUrl+detailTvList[indexPath.item].actorImage)
            cell.actorImageView.kf.setImage(with: imageUrl)
            cell.actorImageView.layer.cornerRadius = 12
                
            return cell
        }
        
    }
}




//
//  InformationDetailViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 8/2/2565 BE.
//

import UIKit

class InformationDetailViewController: UIViewController {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var descText: UILabel!
    
    @IBOutlet weak var bgBadge: UIView!
    @IBOutlet weak var titleBadge: UILabel!
    var imgPoster = ""
    public var informationItem: InformationItem? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupValue()

    }
    
    func setupUI()  {
        self.bgBadge.setRounded(rounded: self.bgBadge.frame.height/2)
        titleText.font = .bodyBold
        titleBadge.font = .extraSmallText
        
        descText.font = .smallText
        descText.textColor = .baseTextGray
        descText.numberOfLines = 0
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        posterImage.isUserInteractionEnabled = true
        posterImage.addGestureRecognizer(singleTap)
        
    }
    

    
    
    @objc func tapDetected(){
        
        
        let img = [imgPoster]
//        if self.listImage.count > 0 {
            NavigationManager.instance.pushVC(to: .imageListFullScreen(listImage: img, index: 0), presentation: .Present(withNav: true, modalTransitionStyle: .crossDissolve, modalPresentationStyle: .overFullScreen))
//        }
        
    }
    
    
    
    func setupValue()  {
        
        titleText.text = informationItem?.title ?? ""
        descText.text = informationItem?.desc ?? ""
        
        if let updateDate = informationItem?.updatedDate {
            titleBadge.isHidden = false
            bgBadge.isHidden = false
            titleBadge.text = updateDate.convertToDate()?.getFormattedDate(format: "MMM dd, HH:mm")
        } else {
            titleBadge.isHidden = true
            bgBadge.isHidden = true
        }
        
        if let poster = informationItem?.image, let urlImage = URL(string: "https://api.chargeloma.com/\(poster)") {
            posterImage.kf.setImageDefault(with: urlImage)
            imgPoster = poster
        }
    }
}

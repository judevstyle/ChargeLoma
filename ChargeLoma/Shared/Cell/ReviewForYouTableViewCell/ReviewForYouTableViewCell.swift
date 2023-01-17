//
//  ReviewForYouTableViewCell.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 2/2/2565 BE.
//

import UIKit

class ReviewForYouTableViewCell: UITableViewCell {

    static let identifier = "ReviewForYouTableViewCell"
    
    @IBOutlet weak var posterReview: UIImageView!
    @IBOutlet weak var titleReview: UILabel!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var commentText: UILabel!
    @IBOutlet weak var addressText: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    public var listImage: [String] = []
    
    var data: ReviewData? {
        didSet {
            setupValue()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.collectionViewLayout = layout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.registerCell(identifier: ImageListCollectionViewCell.identifier)
        collectionView.isUserInteractionEnabled = false
    }
    
    func setupUI() {
        posterReview.setRounded(rounded: posterReview.frame.width/2)
        posterReview.setPlaceholderImageView()
        titleReview.font = .h3Bold
        commentText.font = .h3Text
        dateText.font = .extraSmallText
        addressText.font = .bodyText
    }
     
    func setupValue() {
        titleReview.text = data?.User?.displayName ?? ""
        dateText.text = data?.createdDate?.convertToDate()?.getFormattedDate(format: "MMM dd, HH:mm")
        commentText.text = data?.comment ?? ""
        addressText.text = data?.station?.stationName ?? ""
        
        
        
        if (data?.User?.avatar?.length()) != nil {
            if (data?.User?.avatar?.length())! < 40 {
                if let logo = data?.User?.avatar, let urlImage = URL(string: "https://api.chargeloma.com/\(logo)") {
                    posterReview.kf.setImageDefault(with: urlImage)
                }
            }else{
                if let logo = data?.User?.avatar, let urlImage = URL(string: "\(logo)") {
                    posterReview.kf.setImageDefault(with: urlImage)
                }
                
            }
            
            
        }
        
//        if let posterUser = data?.User?.avatar, let urlImage = URL(string: "https://api.chargeloma.com/\(posterUser)") {
//            posterReview.kf.setImageDefault(with: urlImage)
//        }
        
        var listStrImage: [String] = []
        data?.ReviewImg?.forEach({ item in
            if let pathImage = item.imgPath {
                listStrImage.append(pathImage)
            }
        })
        self.listImage = listStrImage
        self.collectionView.reloadData()
    }
    
    public func setupCollectionHeight(_ height: CGFloat) {
        collectionViewHeight.constant = height
    }
}

extension ReviewForYouTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

extension ReviewForYouTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageListCollectionViewCell.identifier, for: indexPath) as! ImageListCollectionViewCell
        cell.imageUrl = self.listImage[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listImage.count > 0 ? 1 : 0
    }
}

extension ReviewForYouTableViewCell: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: Double = collectionView.frame.width
        return CGSize(width: width, height: collectionView.frame.height)
    }
}

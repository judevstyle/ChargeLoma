//
//  ReviewTableViewCell.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 22/1/2565 BE.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    static let identifier = "ReviewTableViewCell"
    
    @IBOutlet weak var posterReview: UIImageView!
    @IBOutlet weak var titleReview: UILabel!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var powerText: UILabel!
    @IBOutlet weak var plugTitleText: UILabel!
    @IBOutlet weak var commentText: UILabel!
    @IBOutlet weak var carName: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var statusImage: UIImageView!
    
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
    }
    
    func setupUI() {
        posterReview.setRounded(rounded: posterReview.frame.width/2)
        posterReview.setPlaceholderImageView()
        
        titleReview.font = .bodyBold
        plugTitleText.font = .h3Text
        commentText.font = .h3Text
        
        dateText.font = .extraSmallText
        powerText.font = .extraSmallText
        powerText.textColor = .baseTextGray
        
        carName.font = .smallText
        carName.textColor = .baseTextGray
        
        statusImage.backgroundColor = .clear
        statusImage.setPlaceholderImageView()
        statusImage.contentMode = .scaleAspectFill
    }
     
    func setupValue() {
        titleReview.text = data?.User?.displayName ?? ""
        dateText.text = data?.createdDate?.convertToDate()?.getFormattedDate(format: "MMM dd, HH:mm")
        powerText.text = "\(data?.power ?? 0) kW"
        carName.text = "\(data?.User?.car ?? "")"
        
        plugTitleText.text = data?.PlugTypeMaster?.pTitle ?? ""
        commentText.text = data?.comment ?? ""
        
        if let posterUser = data?.User?.avatar, let urlImage = URL(string: "\(posterUser)") {
            posterReview.kf.setImageDefault(with: urlImage)
        }
        
        
        switch data?.isCharge {
        case true:
            statusImage.image = UIImage(named: "yes")?.withRenderingMode(.alwaysOriginal)
            statusImage.tintColor = .green
            plugTitleText.isHidden = false
        case false:
            statusImage.image = UIImage(named: "no")?.withRenderingMode(.alwaysOriginal)
            statusImage.tintColor = .red
            plugTitleText.isHidden = false
        default:
            statusImage.image = UIImage(named: "comment")?.withRenderingMode(.alwaysOriginal)
            statusImage.tintColor = .basePrimary
            plugTitleText.text = ""
            plugTitleText.isHidden = true
        }

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

extension ReviewTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.listImage.count > 0 {
            NavigationManager.instance.pushVC(to: .imageListFullScreen(listImage: self.listImage, index: indexPath.row), presentation: .Present(withNav: true, modalTransitionStyle: .crossDissolve, modalPresentationStyle: .overFullScreen))
        }
    }
}

extension ReviewTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageListCollectionViewCell.identifier, for: indexPath) as! ImageListCollectionViewCell
        cell.imageUrl = self.listImage[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listImage.count
    }
}

extension ReviewTableViewCell: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: Double = ((collectionView.frame.width - 16) / 3.0)
        return CGSize(width: width, height: width)
    }
}

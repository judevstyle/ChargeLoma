//
//  ForYouViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 29/12/2564 BE.
//

import UIKit
import HMSegmentedControl

class ForYouViewController: UIViewController {

    //Segment
    @IBOutlet weak var topNav: UIView!
    let segmentedControl = HMSegmentedControl()
    var currentPage: Int = 0
    
    @IBOutlet var pageCollectionView: UICollectionView!
    
    
    // ViewModel
    lazy var viewModel: ForYouProtocol = {
        let vm = ForYouViewModel(vc: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTopnav()
        setupPageCollectionView()
    }
    
    func configure(_ interface: ForYouProtocol) {
        self.viewModel = interface
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setBarTintColor(color: .basePrimary)
        pageCollectionView.reloadData()
    }

}

// MARK: - Binding
extension ForYouViewController {
    func bindToViewModel() {
    }
}

extension ForYouViewController {
    
    func setupUI() {
    }
    
    private func setupTopnav() {

        segmentedControl.sectionTitles = [
            Wording.ForYou.ForYou_Head_Favorite.localized,
            Wording.ForYou.ForYou_Head_Recently.localized,
            Wording.ForYou.ForYou_Head_Information.localized
        ]
        
        segmentedControl.frame = CGRect(x: 0, y: 12, width: topNav.frame.width, height: 38)
        segmentedControl.selectionIndicatorLocation = .bottom
        segmentedControl.selectionIndicatorColor = .basePrimary
        segmentedControl.autoresizingMask = [.flexibleRightMargin, .flexibleWidth]
        segmentedControl.selectionStyle = .fullWidthStripe
        segmentedControl.contentVerticalAlignment = .center
        segmentedControl.enlargeEdgeInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        segmentedControl.segmentEdgeInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        segmentedControl.selectionIndicatorHeight = 2
        segmentedControl.selectedTitleTextAttributes = [NSAttributedString.Key.font: UIFont.h3Text, NSAttributedString.Key.foregroundColor: UIColor.basePrimary]
        segmentedControl.titleTextAttributes = [NSAttributedString.Key.font: UIFont.h3Text, NSAttributedString.Key.foregroundColor: UIColor.baseTextGray]
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlChangedValue(segmentedControl:)), for: .valueChanged)
        view.addSubview(segmentedControl)
        topNav.addSubview(segmentedControl)
    }
    
    @objc func segmentedControlChangedValue(segmentedControl: HMSegmentedControl) {
        let selectedSegmentIndex = segmentedControl.selectedSegmentIndex
        let selectedIndexPath = IndexPath(item: Int(selectedSegmentIndex), section: 0)
        pageCollectionView.scrollToItem(at: selectedIndexPath, at: .bottom, animated: true)
    }
}

//MARK:- PageCollectionView
extension ForYouViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func setupPageCollectionView() {

        pageCollectionView.delegate = self
        pageCollectionView.dataSource = self
        pageCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        pageCollectionView.showsHorizontalScrollIndicator = false
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        layout.sectionInsetReference = .fromSafeArea
        pageCollectionView.collectionViewLayout = layout
        pageCollectionView.contentInsetAdjustmentBehavior = .always
        pageCollectionView.isPagingEnabled = true
        pageCollectionView.backgroundColor = .clear

        pageCollectionView.registerCell(identifier: ForYouRecentlyCollectionViewCell.identifier)
        pageCollectionView.registerCell(identifier: ForYouLastedCollectionViewCell.identifier)
        pageCollectionView.registerCell(identifier:
                                                ForYouInfoCollectionViewCell.identifier)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.output.getNumberOfItemsInSection(collectionView, section: section)
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return viewModel.output.getCellForItemAt(collectionView, indexPath: indexPath)
    }



    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: pageCollectionView.frame.width, height: pageCollectionView.frame.height)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = view.frame.width
        let currentPage = UInt(pageCollectionView.contentOffset.x/pageWidth)
        segmentedControl.setSelectedSegmentIndex(currentPage, animated: true)
    }
}

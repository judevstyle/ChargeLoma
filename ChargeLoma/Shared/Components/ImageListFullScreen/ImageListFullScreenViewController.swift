//
//  ImageListFullScreenViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 22/1/2565 BE.
//

import UIKit

class ImageListFullScreenViewController: UIViewController {

    @IBOutlet var closeBtn: UIBarButtonItem!
    
    @IBOutlet var collectionView: UICollectionView!
    
    var currentPage: Int = 1
    
    @IBOutlet var allPageText: UILabel!
    @IBOutlet var currentPageText: UILabel!
    
    public var initialScrollDone: Bool = false
    
    // ViewModel
    lazy var viewModel: ImageListFullScreenProtocol = {
        let vm = ImageListFullScreenViewModel(ImageListFullScreenViewController: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupPageCollectionView()
        
        viewModel.input.fetchListImage()
    }
    
    func configure(_ interface: ImageListFullScreenProtocol) {
        self.viewModel = interface
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .darkContent
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if (!self.initialScrollDone) {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.initialScrollDone = true
                let index = self.viewModel.output.getSelectedIndex()
                let currentPage = index + 1
                self.currentPageText.text = "\(currentPage)"
                self.collectionView.layoutIfNeeded()
//
//                let rect = self.collectionView.layoutAttributesForItem(at:IndexPath(row: index, section: 0))?.frame
//                self.collectionView.scrollRectToVisible(rect!, animated: false)
                
                self.collectionView.isPagingEnabled = false
                self.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .left, animated: false)
                self.collectionView.isPagingEnabled = true
            }
        }
    }
}

// MARK: - Binding
extension ImageListFullScreenViewController {
    func bindToViewModel() {
        viewModel.output.didFetchListImageSuccess = didFetchListImageSuccess()
    }
    
    func didFetchListImageSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.collectionView.reloadData()

        }
    }
}

//MARK:- PageCollectionView
extension ImageListFullScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func setupPageCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.showsHorizontalScrollIndicator = false
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        layout.sectionInsetReference = .fromSafeArea
        collectionView.collectionViewLayout = layout
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        
        collectionView.registerCell(identifier: ImageFullScreenCollectionViewCell.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel.output.getNumberOfItemsInSection()
        allPageText.text = "\(count)"
        return count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return viewModel.output.getCellForItemAt(collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = view.frame.width
        let currentPage = UInt(collectionView.contentOffset.x/pageWidth) + 1
        currentPageText.text = "\(currentPage)"
    }
    
}

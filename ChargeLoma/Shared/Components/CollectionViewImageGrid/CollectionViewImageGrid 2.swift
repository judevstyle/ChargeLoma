//
//  CollectionViewImageGrid.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 6/15/21.
//

import UIKit

protocol CollectionViewImageGridDelegate: class {
    func didSelectItem(indexPath: IndexPath)
    func imageListChangeAction(listBase64: [String]?)
}

class CollectionViewImageGrid: UIView {
    
    let nibName = "CollectionViewImageGrid"
    var contentView:UIView?
    
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // ViewModel
    lazy var viewModel: CollectionViewImageGridProtocol = {
        let vm = CollectionViewImageGridViewModel()
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupUI()
    }
    
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func configure(_ interface: CollectionViewImageGridProtocol) {
        self.viewModel = interface
    }
}

// MARK: - Binding
extension CollectionViewImageGrid {
    
    func bindToViewModel() {
        viewModel.output.didSetMenuSuccess = didSetMenuSuccess()
    }
    
    func didSetMenuSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.collectionView.reloadData()
        }
    }
}

extension CollectionViewImageGrid {
    func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        registerCell()
    }
    
    fileprivate func registerCell() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.showsVerticalScrollIndicator = false
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let screenWidth = ((collectionView.frame.width - 40) / 4) - 16
        layout.itemSize = CGSize(width: screenWidth, height: screenWidth)
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .horizontal
        collectionView!.collectionViewLayout = layout
        collectionView.registerCell(identifier: Image1x1ChooseCollectionViewCell.identifier)
        collectionView.registerCell(identifier: Image1x1CollectionViewCell.identifier)
    }
    
}


extension CollectionViewImageGrid: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.input.didSelectItem(indexPath: indexPath)
    }
    
}

extension CollectionViewImageGrid: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.output.getNumberOfCollection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return viewModel.output.getItemViewCell(collectionView, indexPath: indexPath)
    }
}

// MARK: - Public Area

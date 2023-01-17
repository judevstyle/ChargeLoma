//
//  GalleryPhotoViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 16/1/2565 BE.
//

import UIKit

class GalleryPhotoViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    public var listImageStation: [String] = []
    
    lazy var viewModel: GalleryPhotoProtocol = {
        let vm = GalleryPhotoViewModel(vc: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func configure(_ interface: GalleryPhotoProtocol) {
        self.viewModel = interface
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    func setupUI() {
        setupCloseViewButton()
        setupCollectionView()
    }
    
    private func setupCloseViewButton() {
        var closeButton: UIBarButtonItem = UIBarButtonItem(image: UIImage.init(systemName: "xmark"), style: .plain, target: self, action: #selector(handleCloseViewButton))
        closeButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = closeButton
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.collectionViewLayout = layout
        collectionView.registerCell(identifier: ImageListCollectionViewCell.identifier)
    }
    
    @objc func handleCloseViewButton() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Binding
extension GalleryPhotoViewController {
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

extension GalleryPhotoViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let listImage = self.listImageStation
        if listImage.count > 0 {
            NavigationManager.instance.pushVC(to: .imageListFullScreen(listImage: listImage, index: indexPath.row), presentation: .Present(withNav: true, modalTransitionStyle: .crossDissolve, modalPresentationStyle: .overFullScreen))
        }
    }
}

extension GalleryPhotoViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageListCollectionViewCell.identifier, for: indexPath) as! ImageListCollectionViewCell
        cell.imageUrl = self.listImageStation[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        debugPrint(self.listImageStation.count)
        return self.listImageStation.count
    }
}

extension GalleryPhotoViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: Double = ((collectionView.frame.width - 16 - 16) / 3.0)
        return CGSize(width: width, height: width)
    }
}

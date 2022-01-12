//
//  MapFilterViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 9/1/2565 BE.
//

import UIKit

class MapFilterViewController: UIViewController {
    
    
    @IBOutlet weak var dcCollectionView: UICollectionView!
    
    private var isSelectedACAll: Bool = true
    private var isSelectedDCAll: Bool = true
    @IBOutlet weak var checkboxAcAll: CheckBoxView!
    @IBOutlet weak var checkboxDcAll: CheckBoxView!
    
    @IBOutlet weak var acCollection: UICollectionView!
    
    lazy var viewModel: MapFilterProtocol = {
        let vm = MapFilterViewModel(vc: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerACCollection()
        registerDCCollection()
        viewModel.input.getMapFilter()
    }
    
    func configure(_ interface: MapFilterProtocol) {
        self.viewModel = interface
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.setBarTintColor(color: .basePrimary)
    }
    
    private func setupUI() {
        checkboxAcAll.delegate = self
        checkboxDcAll.delegate = self
        checkboxAcAll.isSelectedBtn = true
        checkboxDcAll.isSelectedBtn = true
        checkboxAcAll.onClickCheckBox()
        checkboxDcAll.onClickCheckBox()
    }
    
    fileprivate func registerACCollection() {
  
        acCollection.delegate = self
        acCollection.dataSource = self
        acCollection.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        acCollection.collectionViewLayout = layout
        acCollection.registerCell(identifier: FilterItemCollectionViewCell.identifier)

    }
    
    fileprivate func registerDCCollection() {
        dcCollectionView.delegate = self
        dcCollectionView.dataSource = self
        dcCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        dcCollectionView.collectionViewLayout = layout
        dcCollectionView.registerCell(identifier: FilterItemCollectionViewCell.identifier)
        dcCollectionView.reloadData()
    }
}

// MARK: - Binding
extension MapFilterViewController {
    
    func bindToViewModel() {
        viewModel.output.didGetACPlugTypeSuccess = didGetACPlugTypeSuccess()
        viewModel.output.didGetDCPlugTypeSuccess = didGetDCPlugTypeSuccess()
    }
    
    func didGetACPlugTypeSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.acCollection.reloadData()
        }
    }
    
    func didGetDCPlugTypeSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.dcCollectionView.reloadData()
        }
    }
    
}

extension MapFilterViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

extension MapFilterViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterItemCollectionViewCell.identifier, for: indexPath) as! FilterItemCollectionViewCell
        cell.setIndex(indexPath.item)
        cell.delegate = self
        switch collectionView {
        case acCollection:
            cell.vc = acCollection
            cell.item = self.viewModel.output.getListAC().0[indexPath.item]
            cell.checkbox.isSelectedBtn = self.viewModel.output.getListAC().1[indexPath.item]
            cell.checkbox.onClickCheckBox()
        case dcCollectionView:
            cell.vc = dcCollectionView
            cell.item = self.viewModel.output.getListDC().0[indexPath.item]
            cell.checkbox.isSelectedBtn = self.viewModel.output.getListDC().1[indexPath.item]
            cell.checkbox.onClickCheckBox()
        default:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case acCollection:
            return self.viewModel.output.getListAC().0.count
        case dcCollectionView:
            return  self.viewModel.output.getListDC().0.count
        default:
            return 0
        }
    }
}

extension MapFilterViewController: UICollectionViewDelegateFlowLayout{
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
        return CGSize(width: 125, height: 95)
    }
}

extension MapFilterViewController: CheckBoxViewDelegate {
    func didSelected(view: CheckBoxView, isSelectedBtn: Bool, index: Int) {
        switch view {
        case checkboxAcAll:
            if isSelectedBtn {
                viewModel.input.setSelectedACAll(selected: true)
            } else {
                viewModel.input.setSelectedACAll(selected: false)
            }
            acCollection.reloadData()
        case checkboxDcAll:
            if isSelectedBtn {
                viewModel.input.setSelectedDCAll(selected: true)
            } else {
                viewModel.input.setSelectedDCAll(selected: false)
            }
            dcCollectionView.reloadData()
        default:
            break
        }
    }
}

extension MapFilterViewController: FilterItemCollectionViewCellDelegate {
    func didSelectedCheckMark(vc: UICollectionView, view: CheckBoxView, isSelectedBtn: Bool, index: Int) {
        switch vc {
        case acCollection:
            viewModel.input.setSelectedACIndex(index: index, selected: isSelectedBtn)
            checkACAll()
        case dcCollectionView:
            viewModel.input.setSelectedDCIndex(index: index, selected: isSelectedBtn)
            checkDCAll()
        default:
            break
        }
    }

    func checkACAll() {
        var isFalse: Bool = false
        self.viewModel.getListAC().1.forEach({ item in
            if item == false {
                isFalse = true
            }
        })
        
        if isFalse == true {
            checkboxAcAll.isSelectedBtn = false
            checkboxAcAll.onClickCheckBox()
        } else {
            checkboxAcAll.isSelectedBtn = true
            checkboxAcAll.onClickCheckBox()
        }
//        acCollection.reloadData()
    }
    
    func checkDCAll() {
        var isFalse: Bool = false
        self.viewModel.getListDC().1.forEach({ item in
            if item == false {
                isFalse = true
            }
        })
        
        if isFalse == true {
            checkboxDcAll.isSelectedBtn = false
            checkboxDcAll.onClickCheckBox()
        } else {
            checkboxDcAll.isSelectedBtn = true
            checkboxDcAll.onClickCheckBox()
        }
//        dcCollectionView.reloadData()
    }
    
}

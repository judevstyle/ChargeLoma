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

    @IBOutlet weak var providerCollection: UICollectionView!
    
    @IBOutlet weak var providerCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var statusCollection: UICollectionView!
    
    private var isSelectedProviderAll: Bool = true
    private var isSelectedStatusAll: Bool = true
    
    @IBOutlet weak var checkboxProviderAll: CheckBoxView!
    
    @IBOutlet var headPlug: UILabel!
    @IBOutlet var headProviders: UILabel!
    @IBOutlet var headStatus: UILabel!
    @IBOutlet var headCheclBoxAll: UILabel!
    
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
        registerProviderCollection()
        registerStatusFilterCollection()
        
        
        viewModel.input.getPlugTypeMaster()
        viewModel.input.getProviderMaster()
        viewModel.input.getStatusFilter()

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
        checkboxAcAll.isSelectedBtn = true
        checkboxAcAll.onClickCheckBox()
        
        checkboxDcAll.delegate = self
        checkboxDcAll.isSelectedBtn = true
        checkboxDcAll.onClickCheckBox()
        
        checkboxProviderAll.delegate = self
        checkboxProviderAll.isSelectedBtn = true
        checkboxProviderAll.onClickCheckBox()
        
        headPlug.text = Wording.MapFilter.MapFilter_Head_Connectors.localized
        headProviders.text = Wording.MapFilter.MapFilter_Head_Providers.localized
        headStatus.text = Wording.MapFilter.MapFilter_Head_Status.localized
        headCheclBoxAll.text = Wording.MapFilter.MapFilter_Head_All.localized
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
    
    fileprivate func registerProviderCollection() {
        providerCollection.delegate = self
        providerCollection.dataSource = self
        providerCollection.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        providerCollection.collectionViewLayout = layout
        providerCollection.registerCell(identifier: FilterItemCollectionViewCell.identifier)
        providerCollection.reloadData()
    }
    
    fileprivate func registerStatusFilterCollection() {
        statusCollection.delegate = self
        statusCollection.dataSource = self
        statusCollection.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        statusCollection.collectionViewLayout = layout
        statusCollection.registerCell(identifier: FilterItemTextCollectionViewCell.identifier)
        statusCollection.reloadData()
    }
}

// MARK: - Binding
extension MapFilterViewController {
    
    func bindToViewModel() {
        viewModel.output.didGetACPlugTypeSuccess = didGetACPlugTypeSuccess()
        viewModel.output.didGetDCPlugTypeSuccess = didGetDCPlugTypeSuccess()
        viewModel.output.didGetProviderMasterSuccess = didGetProviderMasterSuccess()
        viewModel.output.didGetStatusFilterSuccess = didGetStatusFilterSuccess()
    }
    
    func didGetACPlugTypeSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.acCollection.reloadData()
            weakSelf.checkACAll()
        }
    }
    
    func didGetDCPlugTypeSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.dcCollectionView.reloadData()
            weakSelf.checkDCAll()
        }
    }
    
    func didGetProviderMasterSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.providerCollection.reloadData()
            weakSelf.checkProviderAll()
        }
    }
    
    func didGetStatusFilterSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.statusCollection.reloadData()
        }
    }
    
}

extension MapFilterViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

extension MapFilterViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case acCollection:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterItemCollectionViewCell.identifier, for: indexPath) as! FilterItemCollectionViewCell
            cell.setIndex(indexPath.item)
            cell.delegate = self
            cell.vc = acCollection
            let item = self.viewModel.output.getListAC().0[indexPath.item]
            cell.title = item.pTitle
            cell.logoImage = item.pIcon
            cell.checkbox.isSelectedBtn = self.viewModel.output.getListAC().1[indexPath.item]
            cell.checkbox.onClickCheckBox()
            cell.titleText.isHidden = false
            return cell
        case dcCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterItemCollectionViewCell.identifier, for: indexPath) as! FilterItemCollectionViewCell
            cell.setIndex(indexPath.item)
            cell.delegate = self
            cell.vc = dcCollectionView
            let item = self.viewModel.output.getListDC().0[indexPath.item]
            cell.title = item.pTitle
            cell.logoImage = item.pIcon
            cell.checkbox.isSelectedBtn = self.viewModel.output.getListDC().1[indexPath.item]
            cell.checkbox.onClickCheckBox()
            cell.titleText.isHidden = false
            return cell
        case providerCollection:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterItemCollectionViewCell.identifier, for: indexPath) as! FilterItemCollectionViewCell
            cell.setIndex(indexPath.item)
            cell.delegate = self
            cell.vc = providerCollection
            let item = self.viewModel.output.getListProviderMaster().0[indexPath.item]
            cell.title = item.name
            cell.logoImage = item.icon
            cell.checkbox.isSelectedBtn = self.viewModel.output.getListProviderMaster().1[indexPath.item]
            cell.checkbox.onClickCheckBox()
            cell.titleText.isHidden = true
            return cell
        case statusCollection:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterItemTextCollectionViewCell.identifier, for: indexPath) as! FilterItemTextCollectionViewCell
            cell.setIndex(indexPath.item)
            cell.delegate = self
            cell.vc = statusCollection
            let title = self.viewModel.output.getListStatusFilter().1[indexPath.item]
            cell.title = title
            cell.checkbox.isSelectedBtn = self.viewModel.output.getListStatusFilter().2[indexPath.item]
            cell.checkbox.onClickCheckBox()
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case acCollection:
            return self.viewModel.output.getListAC().0.count
        case dcCollectionView:
            return  self.viewModel.output.getListDC().0.count
        case providerCollection:
            let count = self.viewModel.output.getListProviderMaster().0.count
            self.providerCollectionHeight.constant = ((CGFloat(count / 2)+CGFloat(count%2)) * 70)
            return count
        case statusCollection:
            return self.viewModel.output.getListStatusFilter().0.count
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
        switch collectionView {
        case providerCollection:
            return CGSize(width: 125, height: 70)
        case statusCollection:
            return CGSize(width: 125, height: 50)
        default:
            return CGSize(width: 150, height: 95)
        }
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
        case checkboxProviderAll:
            if isSelectedBtn {
                viewModel.input.setSelectedProviderMasterAll(selected: true)
            } else {
                viewModel.input.setSelectedProviderMasterAll(selected: false)
            }
            providerCollection.reloadData()
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
        case providerCollection:
            viewModel.input.setSelectedProviderMasterIndex(index: index, selected: isSelectedBtn)
            checkProviderAll()
        case statusCollection:
            viewModel.input.setSelectedStatusFilterIndex(index: index, selected: isSelectedBtn)
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
    }
    
    func checkProviderAll() {
        var isFalse: Bool = false
        self.viewModel.getListProviderMaster().1.forEach({ item in
            if item == false {
                isFalse = true
            }
        })
        
        if isFalse == true {
            checkboxProviderAll.isSelectedBtn = false
            checkboxProviderAll.onClickCheckBox()
        } else {
            checkboxProviderAll.isSelectedBtn = true
            checkboxProviderAll.onClickCheckBox()
        }
    }
    
}

extension MapFilterViewController: FilterItemTextCollectionViewCellDelegate {
    
}

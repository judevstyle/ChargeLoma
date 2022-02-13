//
//  ForYouInfoCollectionViewCell.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 15/1/2565 BE.
//

import UIKit

class ForYouInfoCollectionViewCell: UICollectionViewCell {

    static let identifier = "ForYouInfoCollectionViewCell"

    @IBOutlet var tableView: UITableView!
    
    // ViewModel
    lazy var viewModel: ForYouInfoProtocol = {
        let vm = ForYouInfoViewModel()
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
        setupTableView()
        viewModel.input.getInformation()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.registerCell(identifier: ContentTableViewCell.identifier)
    }
    
    func setupUI() {

    }

    func configure(_ interface: ForYouInfoProtocol) {
        self.viewModel = interface
    }

}

// MARK: - Binding
extension ForYouInfoCollectionViewCell {
    
    func bindToViewModel() {
        viewModel.output.didGetInformationSuccess = didGetInformationSuccess()
    }
    
    func didGetInformationSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.tableView.reloadData()
        }
    }
}

extension ForYouInfoCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.output.getItemInfo(indexPath: indexPath)
        NavigationManager.instance.pushVC(to: .informationDetail(item: item))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.getNumberOfRowsInSection(tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.output.getItemViewCell(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.output.getItemViewCellHeight()
    }
}

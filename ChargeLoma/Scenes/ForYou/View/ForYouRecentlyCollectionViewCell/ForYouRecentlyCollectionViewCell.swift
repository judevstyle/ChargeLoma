//
//  ForYouRecentlyCollectionViewCell.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 15/1/2565 BE.
//

import UIKit

class ForYouRecentlyCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ForYouRecentlyCollectionViewCell"

    @IBOutlet weak var tableView: UITableView!
    
    // ViewModel
    lazy var viewModel: ForYouRecentlyProtocol = {
        let vm = ForYouRecentlyViewModel()
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
        setupTableView()
        viewModel.input.getStationFavorite()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.registerCell(identifier: FavoriteTableViewCell.identifier)
    }
    
    func setupUI() {

    }

    func configure(_ interface: ForYouRecentlyProtocol) {
        self.viewModel = interface
    }

}

// MARK: - Binding
extension ForYouRecentlyCollectionViewCell {
    
    func bindToViewModel() {
        viewModel.output.didGetStationFavoriteSuccess = didGetStationFavoriteSuccess()
    }
    
    func didGetStationFavoriteSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.tableView.reloadData()
        }
    }
}

extension ForYouRecentlyCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

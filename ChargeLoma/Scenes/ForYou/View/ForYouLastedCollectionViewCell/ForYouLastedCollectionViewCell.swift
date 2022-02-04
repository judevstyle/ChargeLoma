//
//  ForYouLastedCollectionViewCell.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 15/1/2565 BE.
//

import UIKit

class ForYouLastedCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ForYouLastedCollectionViewCell"

    @IBOutlet weak var tableView: UITableView!
    
    // ViewModel
    lazy var viewModel: ForYouLastedProtocol = {
        let vm = ForYouLastedViewModel()
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
        setupTableView()
        viewModel.input.getRecentlyReview()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerCell(identifier: ReviewForYouTableViewCell.identifier)
    }
    
    func setupUI() {

    }

    func configure(_ interface: ForYouLastedProtocol) {
        self.viewModel = interface
    }

}

// MARK: - Binding
extension ForYouLastedCollectionViewCell {
    
    func bindToViewModel() {
        viewModel.output.didGetRecentlyReviewSuccess = didGetRecentlyReviewSuccess()
    }
    
    func didGetRecentlyReviewSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.tableView.reloadData()
        }
    }
}

extension ForYouLastedCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.output.getItemReviewData(tableView, indexPath: indexPath)
        if let stId = item?.station?.stId {
            NavigationManager.instance.pushVC(to: .stationDetail("\(stId)", isFromPushNavigation: true), presentation: .PushStationDetail)
        }
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

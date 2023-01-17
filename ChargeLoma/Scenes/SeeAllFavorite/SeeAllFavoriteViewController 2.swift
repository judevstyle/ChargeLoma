//
//  SeeAllFavoriteViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 13/2/2565 BE.
//

import UIKit

class SeeAllFavoriteViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var viewModel: SeeAllFavoriteProtocol = {
        let vm = SeeAllFavoriteViewModel(vc: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel.input.getStationFavorite()
    }

    func configure(_ interface: SeeAllFavoriteProtocol) {
        self.viewModel = interface
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setBarTintColor(color: .basePrimary, complete: nil)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerCell(identifier: FavoriteTableViewCell.identifier)
    }

}

// MARK: - Binding
extension SeeAllFavoriteViewController {
    
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

extension SeeAllFavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.output.getItemStationData(tableView, indexPath: indexPath)
        if let stId = item?.station?.stId {
            NavigationManager.instance.pushVC(to: .stationDetail("\(stId)", isFromPushNavigation: true), presentation: .PushStationDetail)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.getNumberOfRowsInSection(tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = viewModel.output.getItemViewCell(tableView, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.output.getItemViewCellHeight()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
}


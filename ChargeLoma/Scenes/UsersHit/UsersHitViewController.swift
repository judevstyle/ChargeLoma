//
//  UsersHitViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 16/2/2565 BE.
//

import UIKit

class UsersHitViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    lazy var viewModel: UsersHitProtocol = {
        let vm = UsersHitViewModel(vc: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel.input.getTopReview()
    }

    func configure(_ interface: UsersHitProtocol) {
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
        tableView.registerCell(identifier: TopReviewTableViewCell.identifier)
    }

}

// MARK: - Binding
extension UsersHitViewController {
    
    func bindToViewModel() {
        viewModel.output.didGetTopReviewSuccess = didGetTopReviewSuccess()
    }
    
    func didGetTopReviewSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.tableView.reloadData()
        }
    }
}

extension UsersHitViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.getItemData(tableView, indexPath: indexPath)
        if let uid = item?.User?.uid {
            NavigationManager.instance.pushVC(to: .seeAllReview(uid: uid))
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
        return viewModel.output.getItemViewCellHeight()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
}


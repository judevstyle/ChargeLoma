//
//  SeeAllReviewViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 6/2/2565 BE.
//

import UIKit

class SeeAllReviewViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    lazy var viewModel: SeeAllReviewProtocol = {
        let vm = SeeAllReviewViewModel(vc: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        viewModel.input.getReview()
    }
    
    func configure(_ interface: SeeAllReviewProtocol) {
        self.viewModel = interface
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setBarTintColor(color: .basePrimary)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setBarTintColor(color: .clear)
    }
    
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerCell(identifier: ReviewTableViewCell.identifier)
    }
}

// MARK: - Binding
extension SeeAllReviewViewController {
    
    func bindToViewModel() {
        viewModel.output.didGetReviewSuccess = didGetReviewSuccess()
    }
    
    func didGetReviewSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.tableView.reloadData()
        }
    }
}

extension SeeAllReviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

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

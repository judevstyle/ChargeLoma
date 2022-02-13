//
//  ChooseProviderViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 9/2/2565 BE.
//

import UIKit

class ChooseProviderViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var viewModel: ChooseProviderProtocol = {
        let vm = ChooseProviderViewModel(vc: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        
        viewModel.input.getProviderMaster()
    }
    
    func configure(_ interface: ChooseProviderProtocol) {
        self.viewModel = interface
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        NavigationManager.instance.setupWithNavigationController(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    func setupUI() {
        
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.registerCell(identifier: ProviderTableViewCell.identifier)
    }

}

// MARK: - Binding
extension ChooseProviderViewController {
    
    func bindToViewModel() {
        viewModel.output.didGetProviderMasterSuccess = didGetProviderMasterSuccess()
    }
    
    func didGetProviderMasterSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.tableView.reloadData()
        }
    }
}

extension ChooseProviderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.output.getItemViewCellHeight()
    }
}

extension ChooseProviderViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.getNumberOfRowsInSection(tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.output.getItemViewCell(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.input.didSelectRowAt(tableView, indexPath: indexPath)
    }
}

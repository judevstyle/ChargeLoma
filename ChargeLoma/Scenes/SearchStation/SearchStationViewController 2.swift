//
//  SearchStationViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 7/1/2565 BE.
//

import UIKit

class SearchStationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    lazy var viewModel: SearchStationProtocol = {
        let vm = SearchStationViewModel(vc: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    var searchBar: UISearchBar!
    var closeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.shouldRemoveShadow(true)
        UIApplication.shared.statusBarStyle = .darkContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    @objc func handleCloseView() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func configure(_ interface: SearchStationProtocol) {
        self.viewModel = interface
    }
    
    func setupUI() {
        closeBtn = UIButton(type: .system)
        closeBtn.setTitle("ยกเลิก", for: .normal)
        closeBtn.tintColor = .black
        closeBtn.titleLabel?.font = .bodyText
        closeBtn.addTarget(self, action: #selector(handleCloseView), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeBtn)
        
        setupTableView()
        setupSearchBar()
    }
    
    func setupTableView() {
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(nibCellClassName: SearchResultTableViewCell.identifier)
    }
    
    func setupSearchBar() {
        //searchBar
        let customFrame = CGRect(x: 0, y: 0, width: view.frame.width - 95, height: 44)
        let titleSearchView = UIView(frame: customFrame)
        searchBar = UISearchBar(frame: customFrame)
        searchBar.delegate = self
        searchBar.placeholder = ""
        searchBar.searchBarStyle = .minimal
        searchBar.compatibleSearchTextField.textColor = UIColor.gray
        searchBar.compatibleSearchTextField.backgroundColor = UIColor.systemGray6
        searchBar.searchTextField.isEnabled = true
        searchBar.tintColor = .gray
        searchBar.searchTextField.textColor = .gray
        searchBar.searchTextField.tintColor = .gray
        searchBar.searchTextField.clearButtonMode = .always
        searchBar.setImage(UIImage(), for: .search, state: .normal)
        
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "ค้นหาสถานที่...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.bodyText])
        
        searchBar.searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont.bodyText
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont.bodyText
        
        titleSearchView.addSubview(searchBar)
        self.navigationItem.titleView = titleSearchView
    }
}

extension SearchStationViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let count = viewModel.output.getListResultPlace().count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier) as! SearchResultTableViewCell
        let place = viewModel.output.getListResultPlace()[indexPath.item]
        cell.place = place
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = viewModel.output.getListResultPlace()[indexPath.item]
        viewModel.input.didSelectPlace(item: place)
    }
}

// MARK: - Binding
extension SearchStationViewController {
    
    func bindToViewModel() {
        
        viewModel.output.didGetPlaceAutoCompleteSuccess = didGetPlaceAutoCompleteSuccess()
    }
    
    
    func didGetPlaceAutoCompleteSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.tableView.reloadData()
        }
    }
}

extension SearchStationViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        NavigationManager.instance.pushVC(to: .profile)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            var request: GetPlaceAutoCompleteRequest = GetPlaceAutoCompleteRequest()
            request.input = text
            viewModel.input.getAutoComplete(request: request)
        }
    }
}

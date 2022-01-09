//
//  SearchStationViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 7/1/2565 BE.
//

import UIKit

class SearchStationViewController: UIViewController {
    
    let data = ["Station 1", "Station 2", "Station 3","Station 4", "Station 5", "Station 1"]

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        let logoutBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeView))
        self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.shouldRemoveShadow(true)
    }
    
    @objc func closeView() {
        self.navigationController?.dismiss(animated: true, completion: nil)
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
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellStation")! as UITableViewCell

        cell.textLabel?.text = data[indexPath.row]

        return cell
    }
    
}

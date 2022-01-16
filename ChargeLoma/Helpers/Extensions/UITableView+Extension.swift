//
//  UITableView+Extension.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 15/1/2565 BE.
//

import Foundation
import UIKit

extension UITableView {
    func registerCell(identifier: String) {
        self.register(UINib.init(nibName: identifier, bundle: Bundle.main), forCellReuseIdentifier: identifier)
    }
}

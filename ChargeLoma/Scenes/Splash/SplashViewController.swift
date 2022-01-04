//
//  SplashViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 29/12/2564 BE.
//

import UIKit

class SplashViewController: UIViewController {
    
    lazy var viewModel: SplashProtocol = {
        let vm = SplashViewModel(vc: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.input.prepareFetchData()
    }
    
    func configure(_ interface: SplashProtocol) {
        self.viewModel = interface
    }
}

// MARK: - Binding
extension SplashViewController {
    
    func bindToViewModel() {
        viewModel.output.didFetchDataSuccess = didFetchDataSuccess()
        viewModel.output.didFetchDataError = didFetchDataError()
    }
    
    func didFetchDataSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            NavigationManager.instance.setRootViewController(rootView: .main, withNav: false, isTranslucent: true)
        }
    }
    
    func didFetchDataError() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
        }
    }
}

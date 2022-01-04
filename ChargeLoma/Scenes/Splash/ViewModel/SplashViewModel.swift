//
//  SplashViewModel.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 30/12/2564 BE.
//

import Foundation
import UIKit
import Combine

protocol SplashProtocolInput {
    func prepareFetchData()
}

protocol SplashProtocolOutput: class {
    var didFetchDataSuccess: (() -> Void)? { get set }
    var didFetchDataError: (() -> Void)? { get set }
    
}

protocol SplashProtocol: SplashProtocolInput, SplashProtocolOutput {
    var input: SplashProtocolInput { get }
    var output: SplashProtocolOutput { get }
}

class SplashViewModel: SplashProtocol, SplashProtocolOutput {
    var input: SplashProtocolInput { return self }
    var output: SplashProtocolOutput { return self }
    
    // MARK: - UseCase
    private var getFindAllProviderMasterUseCase: GetFindAllProviderMasterUseCase
    private var getFindAllPlugTypeMasterUseCase: GetFindAllPlugTypeMasterUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: SplashViewController
    
    init(
        vc: SplashViewController,
        getFindAllProviderMasterUseCase: GetFindAllProviderMasterUseCase = GetFindAllProviderMasterUseCaseImpl(),
        getFindAllPlugTypeMasterUseCase: GetFindAllPlugTypeMasterUseCase = GetFindAllPlugTypeMasterUseCaseImpl()
    ) {
        self.vc = vc
        self.getFindAllProviderMasterUseCase = getFindAllProviderMasterUseCase
        self.getFindAllPlugTypeMasterUseCase = getFindAllPlugTypeMasterUseCase
    }
    
    // MARK - Data-binding OutPut
    var didFetchDataSuccess: (() -> Void)?
    var didFetchDataError: (() -> Void)?
    
    func prepareFetchData() {
        self.vc.startLoding()
        self.getFindAllProviderMasterUseCase.execute().sink { completion in
            debugPrint("getFindAllProviderMasterUseCase \(completion)")
            self.vc.stopLoding()
        } receiveValue: { respProvider in
            self.vc.startLoding()
            self.getFindAllPlugTypeMasterUseCase.execute().sink { completion in
                debugPrint("getFindAllPlugTypeMasterUseCase \(completion)")
                self.vc.stopLoding()
            } receiveValue: { respPlug in
                DataManager.instance.setProviderMaster(items: respProvider ?? [])
                DataManager.instance.setPlugTypeMaster(items: respPlug ?? [])
                self.didFetchDataSuccess?()
            }.store(in: &self.anyCancellable)
        }.store(in: &self.anyCancellable)
    }
}


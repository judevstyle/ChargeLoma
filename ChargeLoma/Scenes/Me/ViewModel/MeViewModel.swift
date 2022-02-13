//
//  MeViewModel.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 13/2/2565 BE.
//

import Foundation
import Combine

protocol MeProtocolInput {
    func getUserMe()
}

protocol MeProtocolOutput: class {
    var didGetUserMeSuccess: (() -> Void)? { get set }
}

protocol MeProtocol: MeProtocolInput, MeProtocolOutput {
    var input: MeProtocolInput { get }
    var output: MeProtocolOutput { get }
}

class MeViewModel: MeProtocol, MeProtocolOutput {
    var input: MeProtocolInput { return self }
    var output: MeProtocolOutput { return self }
    
    // MARK: - UseCase
    private var getUserProfileUseCase: GetUserProfileUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: MeViewController
    
    public var dataUserMe: UserProfileData?
    
    init(
        vc: MeViewController,
        getUserProfileUseCase: GetUserProfileUseCase = GetUserProfileUseCaseImpl()
    ) {
        self.vc = vc
        self.getUserProfileUseCase = getUserProfileUseCase
    }
    
    // MARK - Data-binding OutPut
    var didGetUserMeSuccess: (() -> Void)?

    func getUserMe() {
        self.vc.startLoding()
        self.getUserProfileUseCase.execute().sink { completion in
            debugPrint("getUserProfileUseCase \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if let item = resp {
                AppDelegate.shareDelegate.userProfileData = item
                self.didGetUserMeSuccess?()
            }
        }.store(in: &self.anyCancellable)
    }
}

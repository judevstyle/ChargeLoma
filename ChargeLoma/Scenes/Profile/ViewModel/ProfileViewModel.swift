//
//  ProfileViewModel.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 21/1/2565 BE.
//

import Foundation
import Combine

protocol ProfileProtocolInput {
    func getUserProfile()
}

protocol ProfileProtocolOutput: class {
    var didGetUserProfileSuccess: (() -> Void)? { get set }
}

protocol ProfileProtocol: ProfileProtocolInput, ProfileProtocolOutput {
    var input: ProfileProtocolInput { get }
    var output: ProfileProtocolOutput { get }
}

class ProfileViewModel: ProfileProtocol, ProfileProtocolOutput {
    var input: ProfileProtocolInput { return self }
    var output: ProfileProtocolOutput { return self }
    
    // MARK: - UseCase
    private var getUserProfileUseCase: GetUserProfileUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: ProfileViewController
    
    public var dataUserProfile: UserProfileData?
    
    init(
        vc: ProfileViewController,
        getUserProfileUseCase: GetUserProfileUseCase = GetUserProfileUseCaseImpl()
    ) {
        self.vc = vc
        self.getUserProfileUseCase = getUserProfileUseCase
    }
    
    // MARK - Data-binding OutPut
    var didGetUserProfileSuccess: (() -> Void)?

    func getUserProfile() {
        self.vc.startLoding()
        self.getUserProfileUseCase.execute().sink { completion in
            debugPrint("getUserProfileUseCase \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if let item = resp {
                AppDelegate.shareDelegate.userProfileData = item
                self.didGetUserProfileSuccess?()
            }
        }.store(in: &self.anyCancellable)
    }
}

//
//  EditProfileViewModel.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 19/2/2565 BE.
//

import Foundation
import UIKit
import Combine

protocol EditProfileProtocolInput {
    func getUserProfile()
    func updateUserProfile(displayName: String?, email: String?, tel: String?, car: String?, avatar: String?)
    func registerUserProfile(uid: String?, displayName: String?, tel: String?, email: String?, pass: String?, cfpass: String?, avatar: String?)
}

protocol EditProfileProtocolOutput: class {
    var didUpdateUserSuccess: (() -> Void)? { get set }
    var didGetUserProfileSuccess: (() -> Void)? { get set }
}

protocol EditProfileProtocol: EditProfileProtocolInput, EditProfileProtocolOutput {
    var input: EditProfileProtocolInput { get }
    var output: EditProfileProtocolOutput { get }
}

class EditProfileViewModel: EditProfileProtocol, EditProfileProtocolOutput {
    var input: EditProfileProtocolInput { return self }
    var output: EditProfileProtocolOutput { return self }
    
    // MARK: - UseCase
    private var getUserProfileUseCase: GetUserProfileUseCase
    private var putUserProfileUseCase: PutUserProfileUseCase
    private var postUserRegisterUseCase: PostUserRegisterUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: UIViewController? = nil
    
    init(
        vc: EditProfileViewController,
        getUserProfileUseCase: GetUserProfileUseCase = GetUserProfileUseCaseImpl(),
        putUserProfileUseCase: PutUserProfileUseCase = PutUserProfileUseCaseImpl(),
        postUserRegisterUseCase: PostUserRegisterUseCase = PostUserRegisterUseCaseImpl()
    ) {
        self.vc = vc
        self.putUserProfileUseCase = putUserProfileUseCase
        self.getUserProfileUseCase = getUserProfileUseCase
        self.postUserRegisterUseCase = postUserRegisterUseCase
    }
    
    // MARK - Data-binding OutPut
    var didGetUserProfileSuccess: (() -> Void)?
    var didUpdateUserSuccess: (() -> Void)?
    
    func getUserProfile() {
        self.vc?.startLoding()
        self.getUserProfileUseCase.execute().sink { completion in
            debugPrint("getUserProfileUseCase \(completion)")
            self.vc?.stopLoding()
        } receiveValue: { resp in
            if let item = resp {
                AppDelegate.shareDelegate.userProfileData = item
                self.didGetUserProfileSuccess?()
            }
        }.store(in: &self.anyCancellable)
    }
    
    func updateUserProfile(displayName: String?, email: String?, tel: String?, car: String?, avatar: String?) {
        if let user = AppDelegate.shareDelegate.userProfileData {
            var request = PostUpdateUserRequest()
            request.uid = user.uid
            request.displayName = displayName
            request.email = email
            request.tel = tel
            request.car = car
            request.avatar = avatar
            self.vc?.startLoding()
            self.putUserProfileUseCase.execute(request: request).sink { completion in
                debugPrint("putUserProfileUseCase \(completion)")
                self.vc?.stopLoding()
            } receiveValue: { resp in
                if let item = resp {
                    AppDelegate.shareDelegate.userProfileData = item
                    self.didUpdateUserSuccess?()
                }
            }.store(in: &self.anyCancellable)
        }
    }
    
    func registerUserProfile(uid: String?, displayName: String?, tel: String?, email: String?, pass: String?, cfpass: String?, avatar: String?) {
        var request = PostUpdateUserRequest()
        request.uid = uid
        request.displayName = displayName
        request.email = email
        request.tel = tel
        request.avatar = avatar
        self.vc?.startLoding()
        self.postUserRegisterUseCase.execute(request: request).sink { completion in
            debugPrint("postUserRegisterUseCase \(completion)")
            self.vc?.stopLoding()
        } receiveValue: { resp in
            if let item = resp {
                AppDelegate.shareDelegate.userProfileData = item.user
                UserDefaultsKey.AccessToken.set(value: item.token)
                UserDefaultsKey.TokenType.set(value: item.tokenType)
                self.didUpdateUserSuccess?()
            }
        }.store(in: &self.anyCancellable)
    }

}

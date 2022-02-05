//
//  LoginViewModel.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 21/1/2565 BE.
//

import Foundation
import UIKit
import Combine
import FirebaseAuth

protocol LoginProtocolInput {
    func userRegister(user: AuthDataResult)
    func userAuth()
}

protocol LoginProtocolOutput: class {
    var didPostUserRegisterSuccess: (() -> Void)? { get set }
}

protocol LoginProtocol: LoginProtocolInput, LoginProtocolOutput {
    var input: LoginProtocolInput { get }
    var output: LoginProtocolOutput { get }
}

class LoginViewModel: LoginProtocol, LoginProtocolOutput {
    var input: LoginProtocolInput { return self }
    var output: LoginProtocolOutput { return self }
    
    // MARK: - UseCase
    private var postUserRegisterUseCase: PostUserRegisterUseCase
    private var postUserAuthUseCase: PostUserAuthUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: LoginViewController
    
    public var dataUserProfile: UserProfileData?
    
    init(
        vc: LoginViewController,
        postUserRegisterUseCase: PostUserRegisterUseCase = PostUserRegisterUseCaseImpl(),
        postUserAuthUseCase: PostUserAuthUseCase = PostUserAuthUseCaseImpl()
    ) {
        self.vc = vc
        self.postUserRegisterUseCase = postUserRegisterUseCase
        self.postUserAuthUseCase = postUserAuthUseCase
    }
    
    // MARK - Data-binding OutPut
    var didPostUserRegisterSuccess: (() -> Void)?

    func userRegister(user: AuthDataResult) {
        self.vc.startLoding()
        let userData = user.user
        var request = PostUserRegisterRequest()
        request.displayName = userData.displayName ?? ""
        request.tel = userData.phoneNumber ?? ""
        request.car = ""
        let email = user.additionalUserInfo?.profile?["email"] as? String
        request.email = email ?? ""
        let avatar = userData.photoURL != nil ? "\(userData.photoURL!)" : ""
        request.avatar = avatar
        request.uid = userData.uid
        self.postUserRegisterUseCase.execute(request: request).sink { completion in
            debugPrint("postUserRegisterUseCase \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if let item = resp {
                AppDelegate.shareDelegate.userProfileData = item.user
                UserDefaultsKey.AccessToken.set(value: item.token)
                UserDefaultsKey.TokenType.set(value: item.tokenType)
                self.didPostUserRegisterSuccess?()
            }
        }.store(in: &self.anyCancellable)
    }
    
    func userAuth() {
        self.vc.startLoding()
        var request = PostUserAuthRequest()
        request.uid = UserDefaultsKey.UID.string ?? ""
        self.postUserAuthUseCase.execute(request: request).sink { completion in
            debugPrint("postUserAuthUseCase \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if let item = resp {
                AppDelegate.shareDelegate.userProfileData = item.user
                UserDefaultsKey.AccessToken.set(value: item.token)
                UserDefaultsKey.TokenType.set(value: item.tokenType)
                self.didPostUserRegisterSuccess?()
            }
        }.store(in: &self.anyCancellable)
    }
}

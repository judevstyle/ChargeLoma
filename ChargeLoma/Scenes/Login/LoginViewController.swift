//
//  LoginViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 9/1/2565 BE.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

import AuthenticationServices

public protocol LoginDelegate {
    func didLoginSuccess(actionType: LoginActionType)
}

public enum LoginActionType {
    case unknown
    case writeReview
    case favorite
}

class LoginViewController: UIViewController {

    @IBOutlet weak var inputUsername: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var titleLogo: UILabel!
    
    @IBOutlet weak var btnRegister: UIButton!
    
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!

    @IBOutlet weak var btnApple: UIButton!
    public var delegate: LoginDelegate? = nil
    
    public var actionType: LoginActionType = .unknown
    
    @IBOutlet var orLabel: UILabel!
    lazy var viewModel: LoginProtocol = {
        let vm = LoginViewModel(vc: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationManager.instance.setupWithNavigationController(self)
        setupUI()
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    func configure(_ interface: LoginProtocol) {
        self.viewModel = interface
    }
    
    private func setupUI() {
        inputUsername.setRounded(rounded: 8)
        inputUsername.backgroundColor = UIColor.baseBG
        inputUsername.font = .h3Text
        inputUsername.textColor = .baseTextGray
        
        inputPassword.setRounded(rounded: 8)
        inputPassword.font = .h3Text
        inputPassword.backgroundColor = UIColor.baseBG
        inputPassword.isSecureTextEntry = true
        inputPassword.textColor = .baseTextGray
        
        let attributedUsername = NSAttributedString(
            string: Wording.Login.Login_Email.localized,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.basePrimary, NSAttributedString.Key.font: UIFont.h3Text]
        )
        
        let attributedPassword = NSAttributedString(
            string: Wording.Login.Login_Password.localized,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.basePrimary, NSAttributedString.Key.font: UIFont.h3Text]
        )
        inputUsername.attributedPlaceholder = attributedUsername
        inputPassword.attributedPlaceholder = attributedPassword
        inputUsername.textAlignment = .center
        inputPassword.textAlignment = .center
        
        self.titleLogo.text = "Charge Loma"
        self.titleLogo.font = .header1
        self.titleLogo.textColor = .baseSecondary
        
        self.btnRegister.setTitle(Wording.Login.Login_Register.localized, for: .normal)
        self.btnRegister.titleLabel?.font = .h3Text
        self.btnRegister.titleLabel?.textColor = .basePrimary
        
        self.btnLogin.setTitle(Wording.Login.Login_Login.localized, for: .normal)
        self.btnLogin.titleLabel?.font = .h3Text
        
        self.btnLogin.setRounded(rounded: 8.0)
        
        orLabel.text = Wording.Login.Login_Or.localized
        
        self.btnLogin.addTarget(self, action: #selector(handleSignin), for: .touchUpInside)
        self.btnFacebook.addTarget(self, action: #selector(handleFacebookSignin), for: .touchUpInside)
        self.btnGoogle.addTarget(self, action: #selector(handleGoogleSignin), for: .touchUpInside)
        self.btnRegister.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        self.btnApple.addTarget(self, action: #selector(handleApple), for: .touchUpInside)
    }

}

// MARK: - Binding
extension LoginViewController {
    
    func bindToViewModel() {
        viewModel.output.didPostUserRegisterSuccess = didPostUserRegisterSuccess()
    }
    
    func didPostUserRegisterSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let self = self else { return }
            self.stopLoding()
            self.dismiss(animated: true, completion: {
                self.delegate?.didLoginSuccess(actionType: self.actionType)
            })
        }
    }
    
}

extension LoginViewController {
    @objc func handleSignin() {
        guard let email = inputUsername.text, email != "", let password = inputPassword.text, password != "" else {
            ToastMsg(msg: "กรอกข้อมูลให้ครบถ้วน")
            return
        }
        
        self.startLodingCircle()
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            guard let self = self else { return }
            self.stopLoding()
            if let error = error {
                debugPrint("Signin with Email Error : \(error.localizedDescription)")
            }else {
                guard let user = user else {
                    return
                }
                self.checkNewAuth(user: user)
            }
        }
    }
    
    @objc func handleGoogleSignin() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @objc func handleFacebookSignin() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], viewController: self, completion: didReceiveFacebookLoginResult)
    }
    
    @objc func handleSignup() {
        NavigationManager.instance.pushVC(to: .editProfile(isRegister: true, delegate: self), presentation: .Present(withNav: false))
    }
    
    @objc func handleApple() {
        performSignInAppleID()
    }
}

//MARK: - Check Auth NewUser
extension LoginViewController {
    
    func checkNewAuth(user: AuthDataResult) {
        guard let isNewUser = user.additionalUserInfo?.isNewUser, isNewUser == true else {
            viewModel.input.userAuth()
            return
        }
        viewModel.input.userRegister(user: user)
    }
}

// MARK: - Google Auth
extension LoginViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        self.startLoding()
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential, completion: { [self] (user, error) in
            self.stopLoding()
            if let error = error {
                debugPrint("Signin Google Error : \(error.localizedDescription)")
            }else {
                guard let user = user else {
                    return
                }
                self.checkNewAuth(user: user)
            }
        })
    }
}

// MARK: - Facebook Auth
extension LoginViewController {
    private func didReceiveFacebookLoginResult(loginResult: LoginResult) {
        switch loginResult {
        case .success:
            didLoginWithFacebook()
        case .failed(_):
            break
        default: break
        }
    }
    
    fileprivate func didLoginWithFacebook() {
        // Successful log in with Facebook
        if let accessToken = AccessToken.current {
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            self.startLoding()
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                self.stopLoding()
                if let error = error {
                    debugPrint("Signin Facebook Error : \(error.localizedDescription)")
                }else {
                    guard let user = user else {
                        return
                    }
                    self.checkNewAuth(user: user)
                }
            })
            
        }
    }
}

//Callback Register Success
extension LoginViewController: EditProfileViewControllerDelegate {
    func didEditUserSuccess() {
        self.dismiss(animated: true, completion: {
            self.delegate?.didLoginSuccess(actionType: self.actionType)
        })
    }
}


//MARK: - Apple Auth
extension LoginViewController : ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate{
    func performSignInAppleID() {
        let request = createAppleIDRequest()
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func createAppleIDRequest() -> ASAuthorizationAppleIDRequest {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        currentNonce = nonce
        
        return request
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCreadential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received. but no login request was sent")
            }
            guard let appleIDToken = appleIDCreadential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to to serialize token string from date: \(appleIDToken.debugDescription)")
                return
            }
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            self.startLoding()
            
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                self.startLoding()
                if let error = error {
                    print("Login Error : \(error.localizedDescription)")
                    self.stopLoding()
                }else {
                    guard let user = user else {
                        return
                    }
                    self.checkNewAuth(user: user)
                }
            })
        }
    }
}

private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    
    while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
            }
            return random
        }
        
        randoms.forEach { random in
            if remainingLength == 0 {
                return
            }
            
            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }
    
    return result
}

import CryptoKit

fileprivate var currentNonce: String?

@available(iOS 13, *)
private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
    }.joined()
    
    return hashString
}

//
//  EditProfileViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 18/2/2565 BE.
//

import UIKit
import Firebase
import GoogleSignIn

public protocol EditProfileViewControllerDelegate {
    func didEditUserSuccess()
}

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet var btnChooseImage: UIButton!
    
    @IBOutlet weak var headDisplayName: UILabel!
    
    @IBOutlet var inputDisplayName: UnderlinedTextField!
    
    @IBOutlet weak var headEmail: UILabel!
    @IBOutlet weak var inputEmail: UnderlinedTextField!
    
    @IBOutlet weak var headTel: UILabel!
    @IBOutlet weak var inputTel: UnderlinedTextField!
    
    @IBOutlet weak var headCar: UILabel!
    @IBOutlet weak var inputCar: UnderlinedTextField!
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    
    @IBOutlet weak var bgEmailEditView: UIView!
    @IBOutlet weak var bgCarEditView: UIView!
    @IBOutlet weak var bgSaveView: UIView!
    
    @IBOutlet weak var headEmailRegister: UILabel!
    @IBOutlet weak var inputEmailRegister: UnderlinedTextField!
    
    @IBOutlet weak var headPassword: UILabel!
    @IBOutlet weak var inputPassword: UnderlinedTextField!
    
    @IBOutlet weak var headConfirmPassword: UILabel!
    @IBOutlet weak var inputConfirmPassword: UnderlinedTextField!
    
    @IBOutlet weak var bgRegisterView: UIView!
    @IBOutlet weak var bgEmailRegisterView: UIView!
    @IBOutlet weak var bgPassRegisterView: UIView!
    @IBOutlet weak var bgCfPassRegisterView: UIView!
    
    var imagePicker: ImagePicker!
    fileprivate var imageAttachFilesBase64: String?
    
    public var isRegister: Bool = false
    
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!
    
    public var delegate: EditProfileViewControllerDelegate? = nil
    
    lazy var viewModel: EditProfileProtocol = {
        let vm = EditProfileViewModel(vc: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyboardObserver()
        
        setupUI()
    }
    
    deinit {
       removeObserver()
    }
    
    func configure(_ interface: EditProfileProtocol) {
        self.viewModel = interface
    }
    
    private func setupUI() {
        userImage.setRounded(rounded: userImage.frame.width/2)
        
        btnChooseImage.setRounded(rounded: btnChooseImage.frame.width/2)
        btnChooseImage.imageView?.contentMode = .scaleAspectFit
        btnChooseImage.addTarget(self, action: #selector(didChooseImage), for: .touchUpInside)
        
        setupHeadLabel(lb: headDisplayName, title: Wording.EditProfile.EditProfile_DisplayName.localized)
        setupHeadLabel(lb: headEmail, title: Wording.EditProfile.EditProfile_Email.localized)
        setupHeadLabel(lb: headTel, title: Wording.EditProfile.EditProfile_Tel.localized)
        setupHeadLabel(lb: headCar, title: Wording.EditProfile.EditProfile_Car.localized)
        
        btnSave.setRounded(rounded: 5)
        btnSave.titleLabel?.font = .h3Text
        btnSave.tintColor = .white
        btnSave.backgroundColor = .basePrimary
        btnSave.setTitle(Wording.EditProfile.EditProfile_Save.localized, for: .normal)
        btnSave.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        
        
        setupHeadLabel(lb: headEmailRegister, title: Wording.EditProfile.EditProfile_Email.localized)
        setupHeadLabel(lb: headPassword, title: Wording.EditProfile.EditProfile_Password.localized)
        setupHeadLabel(lb: headConfirmPassword, title: Wording.EditProfile.EditProfile_ConfirmPassword.localized)
      
        
        btnRegister.setRounded(rounded: 5)
        btnRegister.titleLabel?.font = .h3Text
        btnRegister.tintColor = .white
        btnRegister.backgroundColor = .basePrimary
        btnRegister.setTitle(Wording.EditProfile.EditProfile_Register.localized, for: .normal)
        btnRegister.addTarget(self, action: #selector(handleRegisterButton), for: .touchUpInside)
        
        bgEmailEditView.isHidden = isRegister
        bgCarEditView.isHidden = isRegister
        bgEmailRegisterView.isHidden = !isRegister
        bgPassRegisterView.isHidden = !isRegister
        bgCfPassRegisterView.isHidden = !isRegister
        bgSaveView.isHidden = isRegister
        bgRegisterView.isHidden = !isRegister
        
        setupUITextFields(tf: inputDisplayName)
        setupUITextFields(tf: inputEmail, keyboardType: .emailAddress)
        setupUITextFields(tf: inputTel, keyboardType: .phonePad)
        setupUITextFields(tf: inputCar)
        setupUITextFields(tf: inputEmailRegister, keyboardType: .emailAddress)
        setupUITextFields(tf: inputPassword, keyboardType: .default, isSecureTextEntry: true)
        setupUITextFields(tf: inputConfirmPassword, keyboardType: .default, isSecureTextEntry: true)
        
        if !isRegister {
            viewModel.input.getUserProfile()
        }
    }
    
    private func setupValue() {
        if let user = AppDelegate.shareDelegate.userProfileData {
            inputDisplayName.text = user.displayName ?? ""
            if let logoImageUrl = user.avatar, let urlImage = URL(string: "\(logoImageUrl)") {
                userImage.kf.setImageDefault(with: urlImage)
            }
            inputEmail.text = user.email ?? ""
            inputTel.text = user.tel ?? ""
            inputCar.text = user.car ?? ""
        } else {
            inputDisplayName.text = ""
            inputEmail.text = ""
            inputTel.text = ""
            inputCar.text = ""
        }
    }
    
    func setupUITextFields(tf: UITextField, placeholder: String = "", keyboardType: UIKeyboardType = .default, isSecureTextEntry: Bool = false) {
        tf.font = .h3Text
        tf.textColor = .baseTextGray
        tf.placeholder = placeholder
        tf.isSecureTextEntry = isSecureTextEntry
        tf.keyboardType = keyboardType
    }
    
    func setupHeadLabel(lb: UILabel, title: String) {
        lb.font = .h3Text
        lb.textColor = .baseTextGray
        lb.text = title
    }
    
    @objc func handleSaveButton() {
        guard let displayName = inputDisplayName.getText,
        let email = inputEmail.getText else { return }
        viewModel.input.updateUserProfile(displayName: displayName, email: email, tel: inputTel.getText, car: inputCar.getText, avatar: imageAttachFilesBase64)
    }
    
    @objc func didChooseImage() {
        imagePicker = ImagePicker(presentationController: self, sourceType: [.camera, .photoLibrary], delegate: self)
        imagePicker.present(from: self.view)
    }
    
    
    @objc func handleRegisterButton() {
        
        guard let displayName = inputDisplayName.getText,
        let email = inputEmailRegister.getText,
        let password = inputPassword.getText,
        let cfpassword = inputConfirmPassword.getText,
        password == cfpassword else { return }
        
        self.startLoding()
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if error != nil {
                self.ToastMsg(msg: "\(error?.localizedDescription ?? "")")
                self.stopLoding()
                return
            } else {
                guard let user = user else {
                    self.stopLoding()
                    return
                }
                self.stopLoding()
                self.addNewUser(user: user)
            }
        }
    }
    
    func addNewUser(user: AuthDataResult) {
        let userData = user.user
        guard let displayName = inputDisplayName.getText,
        let password = inputPassword.getText,
        let cfpassword = inputConfirmPassword.getText,
        password == cfpassword else { return }
        
        viewModel.input.registerUserProfile(uid: userData.uid, displayName: displayName, tel: inputTel.getText, email: userData.email, pass: password, cfpass: cfpassword, avatar: imageAttachFilesBase64)
    }
    
}

extension EditProfileViewController: ImagePickerDelegate {
    func didSelectImage(image: UIImage?, imagePicker: ImagePicker, base64: String) {
        userImage.image = image
        imageAttachFilesBase64 = base64
    }
}

extension EditProfileViewController : KeyboardListener {
    func keyboardDidUpdate(keyboardHeight: CGFloat) {
        bottomHeight.constant = keyboardHeight
    }
}

// MARK: - Binding
extension EditProfileViewController {
    func bindToViewModel() {
        viewModel.output.didGetUserProfileSuccess = didGetUserProfileSuccess()
        viewModel.output.didUpdateUserSuccess = didUpdateUserSuccess()
    }
    
    func didGetUserProfileSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.setupValue()
        }
    }
    
    func didUpdateUserSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            self?.dismiss(animated: true, completion: nil)
            self?.navigationController?.popViewController(animated: true)
            self?.delegate?.didEditUserSuccess()
        }
    }
}

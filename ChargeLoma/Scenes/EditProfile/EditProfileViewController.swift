//
//  EditProfileViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 18/2/2565 BE.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyboardObserver()
        
        setupUI()
        setupValue()
        
        imagePicker = ImagePicker(presentationController: self, sourceType: [.camera, .photoLibrary], delegate: self)
    }
    
    deinit {
       removeObserver()
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
        setupHeadLabel(lb: headPassword, title: Wording.EditProfile.EditProfile_Car.localized)
        setupHeadLabel(lb: headConfirmPassword, title: Wording.EditProfile.EditProfile_Car.localized)
      
        
        btnRegister.setRounded(rounded: 5)
        btnRegister.titleLabel?.font = .h3Text
        btnRegister.tintColor = .white
        btnRegister.backgroundColor = .basePrimary
        btnRegister.setTitle(Wording.EditProfile.EditProfile_Save.localized, for: .normal)
        btnRegister.addTarget(self, action: #selector(handleRegisterButton), for: .touchUpInside)
        
        bgEmailEditView.isHidden = isRegister
        bgCarEditView.isHidden = isRegister
        bgEmailRegisterView.isHidden = !isRegister
        bgPassRegisterView.isHidden = !isRegister
        bgCfPassRegisterView.isHidden = !isRegister
        bgSaveView.isHidden = isRegister
        bgRegisterView.isHidden = !isRegister
        
        setupUITextFields(tf: inputDisplayName)
        setupUITextFields(tf: inputEmail)
        setupUITextFields(tf: inputTel)
        setupUITextFields(tf: inputCar)
        setupUITextFields(tf: inputEmailRegister)
        setupUITextFields(tf: inputPassword)
        setupUITextFields(tf: inputConfirmPassword)
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
    
    func setupUITextFields(tf: UITextField, placeholder: String = "") {
        tf.font = .h3Text
        tf.textColor = .baseTextGray
        tf.placeholder = placeholder
    }
    
    func setupHeadLabel(lb: UILabel, title: String) {
        lb.font = .h3Text
        lb.textColor = .baseTextGray
        lb.text = title
    }
    
    @objc func handleSaveButton() {
        
    }
    
    @objc func didChooseImage() {
        imagePicker.present(from: self.view)
    }
    
    
    @objc func handleRegisterButton() {
        
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

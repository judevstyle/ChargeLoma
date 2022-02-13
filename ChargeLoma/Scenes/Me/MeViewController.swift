//
//  MeViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 29/12/2564 BE.
//

import UIKit

class MeViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var btnEditImage: UIButton!
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var emailText: UILabel!
    @IBOutlet weak var telText: UILabel!
    @IBOutlet weak var carText: UILabel!
    
    lazy var viewModel: MeProtocol = {
        let vm = MeViewModel(vc: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationManager.instance.setupWithNavigationController(self)
        setupUI()
        viewModel.input.getUserMe()
    }
    
    func configure(_ interface: MeProtocol) {
        self.viewModel = interface
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setBarTintColor(color: .clear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setBarTintColor(color: .basePrimary)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard UserDefaultsKey.UID.string != nil, UserDefaultsKey.isLoggedIn.bool == true else {
            NavigationManager.instance.pushVC(to: .preLogin, presentation: .PushInTabbar, animated: false)
            return
        }
    }
    
    private func setupUI() {
        userImage.setRounded(rounded: userImage.frame.width/2)
        
        btnEditImage.setRounded(rounded: btnEditImage.frame.width/2)
        btnEditImage.contentHorizontalAlignment = .fill
        btnEditImage.contentVerticalAlignment = .fill
        btnEditImage.addTarget(self, action: #selector(didEditImage), for: .touchUpInside)
        
        titleName.textColor = .white
        titleName.font = .h3Bold
        
        emailText.textColor = .baseTextGray
        telText.textColor = .baseTextGray
        carText.textColor = .baseTextGray
        
        emailText.font = .bodyText
        telText.font = .bodyText
        carText.font = .bodyText
    }
    
    @objc func didEditImage() {
        debugPrint("didEditImage")
    }
    
    private func setupValue() {
        if let user = AppDelegate.shareDelegate.userProfileData {
            titleName.text = user.displayName ?? "-"
            if let logoImageUrl = user.avatar, let urlImage = URL(string: "\(logoImageUrl)") {
                userImage.kf.setImageDefault(with: urlImage)
            }
            emailText.text = user.email ?? "-"
            telText.text = user.tel ?? "-"
            carText.text = user.car ?? "-"
        } else {
            emailText.text = "-"
            telText.text = "-"
            carText.text = "-"
        }
    }
}

// MARK: - Binding
extension MeViewController {
    func bindToViewModel() {
        viewModel.output.didGetUserMeSuccess = didGetUserMeSuccess()
    }
    
    func didGetUserMeSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.setupValue()
        }
    }
}

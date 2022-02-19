//
//  ProfileViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 8/1/2565 BE.
//

import UIKit
import GoogleSignIn
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var descText: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var logoImage: UIImageView!
    
    lazy var viewModel: ProfileProtocol = {
        let vm = ProfileViewModel(vc: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeObserver()
        registerNotification(name: .LanguageDidChange, selector: #selector(languageDidChange))
        setupUI()
        reloadDataView()
        viewModel.input.getUserProfile()
    }
    
    func configure(_ interface: ProfileProtocol) {
        self.viewModel = interface
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.setBarTintColor(color: .basePrimary)
    }
    
    func setupUI() {
        setupTableView()
        
        titleText.textColor = .white
        descText.textColor = .white
        
        titleText.font = .bodyBold
        descText.font = .smallText
        
        titleText.text = "Charge Loma"
        descText.text = "join me"
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.registerCell(identifier: ProfileTableViewCell.identifier)
        tableView.reloadData()
    }
    
    func reloadDataView() {
        if let user = AppDelegate.shareDelegate.userProfileData {
            titleText.text = user.displayName ?? ""
            if let logoImageUrl = user.avatar, let urlImage = URL(string: "\(logoImageUrl)") {
                logoImage.setRounded(rounded: logoImage.frame.width/2)
                logoImage.kf.setImageDefault(with: urlImage)
            }
        } else {
            titleText.text = "Charge Loma"
            logoImage.setRounded(rounded: 0)
            logoImage.image = UIImage(named: "logo")?.withRenderingMode(.alwaysOriginal)
        }
        self.tableView.reloadData()
    }
    
    @objc func languageDidChange() {
        debugPrint("languageDidChange")
        reloadDataView()
    }
}

// MARK: - Binding
extension ProfileViewController {
    func bindToViewModel() {
        viewModel.output.didGetUserProfileSuccess = didGetUserProfileSuccess()
    }
    
    func didGetUserProfileSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.reloadDataView()
        }
    }
}

// MARK: - event
extension ProfileViewController {
    func didSignOut()  {
        do {
            try Auth.auth().signOut()
            self.startLoding()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.stopLoding()
                self.reloadDataView()
            }
        } catch(let error){
            print(error)
        }
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard UserDefaultsKey.UID.string != nil, UserDefaultsKey.isLoggedIn.bool == true else {
            return 4
        }
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier) as! ProfileTableViewCell
        cell.flagImageView.isHidden = true
        guard UserDefaultsKey.UID.string != nil, UserDefaultsKey.isLoggedIn.bool == true else {
            switch indexPath.row {
            case 0:
                cell.titleText.text = Wording.Profile.TopReview.localized
            case 1:
                cell.titleText.text = Wording.Profile.Language.localized
                cell.flagImageView.isHidden = false
                cell.checkLanguage()
            case 2:
                cell.titleText.text = Wording.Profile.About.localized
            case 3:
                cell.titleText.text = Wording.Profile.Login.localized
            default:
                break
            }
            return cell
        }
        
        switch indexPath.row {
        case 0:
            cell.titleText.text = Wording.Profile.Profile.localized
        case 1:
            cell.titleText.text = Wording.Profile.Favorite.localized
        case 2:
            cell.titleText.text = Wording.Profile.TopReview.localized
        case 3:
            cell.titleText.text = Wording.Profile.Language.localized
            cell.flagImageView.isHidden = false
            cell.checkLanguage()
        case 4:
            cell.titleText.text = Wording.Profile.About.localized
        case 5:
            cell.titleText.text = Wording.Profile.Logout.localized
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard UserDefaultsKey.UID.string != nil, UserDefaultsKey.isLoggedIn.bool == true else {
            switch indexPath.row {
            case 0:
                NavigationManager.instance.pushVC(to: .usersHit)
            case 1:
                NavigationManager.instance.pushVC(to: .switchLanguage, presentation: .presentModelHeight(completion: nil, height: 150))
            case 2:
                NavigationManager.instance.pushVC(to: .about)
            case 3:
                NavigationManager.instance.pushVC(to: .login(self, actionType: .unknown), presentation: .Present(withNav: false))
            default:
                break
            }
            return
        }
        
        switch indexPath.row {
        case 0:
            NavigationManager.instance.pushVC(to: .me)
        case 1:
            NavigationManager.instance.pushVC(to: .seeAllFavorite)
        case 2:
            NavigationManager.instance.pushVC(to: .usersHit)
        case 3:
            NavigationManager.instance.pushVC(to: .switchLanguage, presentation: .presentModelHeight(completion: nil, height: 150))
        case 4:
            NavigationManager.instance.pushVC(to: .about)
        case 5:
            didSignOut()
        default:
            break
        }
    }
}

extension ProfileViewController: LoginDelegate {
    func didLoginSuccess(actionType: LoginActionType) {
        reloadDataView()
    }
}

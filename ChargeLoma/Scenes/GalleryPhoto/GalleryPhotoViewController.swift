//
//  GalleryPhotoViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 16/1/2565 BE.
//

import UIKit

class GalleryPhotoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .darkContent
    }
    
    func setupUI() {
        setupCloseViewButton()
    }
    
    private func setupCloseViewButton() {
        var closeButton: UIBarButtonItem = UIBarButtonItem(image: UIImage.init(systemName: "xmark"), style: .plain, target: self, action: #selector(handleCloseViewButton))
        closeButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc func handleCloseViewButton() {
        self.dismiss(animated: true, completion: nil)
    }
}

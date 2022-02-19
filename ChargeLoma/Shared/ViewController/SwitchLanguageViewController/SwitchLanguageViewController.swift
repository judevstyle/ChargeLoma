//
//  SwitchLanguageViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 16/2/2565 BE.
//

import UIKit

class SwitchLanguageViewController: UIViewController {

    @IBOutlet weak var stackTh: UIStackView!
    @IBOutlet weak var stackEn: UIStackView!
    
    
    @IBOutlet weak var cmTh: UIImageView!
    @IBOutlet weak var cmEn: UIImageView!
    
    @IBOutlet weak var titleTh: UILabel!
    @IBOutlet weak var titleEn: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        titleEn.font = .bodyText
        titleEn.textColor = .baseTextGray
        titleEn.text = "English"
        
        titleTh.font = .bodyText
        titleTh.textColor = .baseTextGray
        titleTh.text = "ไทย"
        
        let tapTh: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapTh))
        stackTh.isUserInteractionEnabled = true
        stackTh.addGestureRecognizer(tapTh)
        
        let tapEn: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapEn))
        stackEn.isUserInteractionEnabled = true
        stackEn.addGestureRecognizer(tapEn)
        
        if Language.current == .thai {
            cmTh.isHidden = false
            cmEn.isHidden = true
        } else {
            cmTh.isHidden = true
            cmEn.isHidden = false
        }
    }
    
    @objc func handleTapTh() {
        Language.current = .thai
        self.dismiss(animated: true, completion: nil)
    }

    @objc func handleTapEn() {
        Language.current = .english
        self.dismiss(animated: true, completion: nil)
    }
}

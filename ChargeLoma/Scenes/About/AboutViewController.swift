//
//  AboutViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 17/2/2565 BE.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    
    
    @IBOutlet weak var headVersion: UILabel!
    @IBOutlet weak var valueVersion: UILabel!
    
    @IBOutlet weak var headUpdate: UILabel!
    @IBOutlet weak var valueUpdate: UILabel!
    
    @IBOutlet weak var headDeveloper: UILabel!
    @IBOutlet weak var valueDeveloper: UILabel!
    
    @IBOutlet weak var headContact: UILabel!
    @IBOutlet weak var valueContact: UILabel!
    
    @IBOutlet weak var headThankYou: UILabel!
    @IBOutlet weak var valueThankYou: UILabel!
    
    @IBOutlet weak var headCopyright: UILabel!
    @IBOutlet weak var valueCopyright: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        setupLabel(label: textLabel, value: Wording.About.AboutDesc.localized)
        setupLabel(label: headVersion, value: Wording.About.AboutHeadVersion.localized)
        let releaseVersion = Bundle.main.releaseVersionNumber ?? ""
        let buildNumber = Bundle.main.buildVersionNumber ?? ""
        setupLabel(label: valueVersion, value: "\(releaseVersion)")
        
        setupLabel(label: headUpdate, value: Wording.About.AboutHeadUpdate.localized)
        setupLabel(label: valueUpdate, value: "23/06/2022")
        
        setupLabel(label: headDeveloper, value: Wording.About.AboutHeadDeveloper.localized)
        setupLabel(label: valueDeveloper, value: "")
        
        setupLabel(label: headContact, value: Wording.About.AboutHeadContact.localized)
        setupLabel(label: valueContact, value: "Chargeloma@gmail.com\nChargeloma")
        
        setupLabel(label: headThankYou, value: Wording.About.AboutHeadThankYou.localized)
        setupLabel(label: valueThankYou, value: "Piyamate Wisanuvej\n\(Wording.About.About_Head_ThankYou1.localized)\n\nCaptain DIY\n\(Wording.About.About_Head_ThankYou2.localized)")
        
        setupLabel(label: headCopyright, value: "© Copyright")
        setupLabel(label: valueCopyright, value: "2022 ChargeLoma.com")
    }
    
    private func setupLabel(label: UILabel, value: String? = "") {
        label.font = .h2Text
        label.textColor = .baseTextGray
        label.numberOfLines = 0
        label.text = value
        label.font = label.font.withSize(16)

        
    }

}

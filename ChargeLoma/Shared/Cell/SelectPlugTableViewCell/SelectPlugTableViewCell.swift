//
//  SelectPlugTableViewCell.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 13/2/2565 BE.
//

import UIKit

class SelectPlugTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imageSelectPlug: UIImageView!
    
    @IBOutlet weak var titleSelectPlug: UILabel!
    static let identifier = "SelectPlugTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupUI() {
        titleSelectPlug.font = .bodyText
        titleSelectPlug.textColor = .baseTextGray
        titleSelectPlug.text = "เพิ่มหัวจ่าย"
        
        imageSelectPlug.setRounded(rounded: imageSelectPlug.frame.width/2)
    }
    
    func setupValue() {

    }
}

//
//  AddReviewViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 23/1/2565 BE.
//

import UIKit

class AddReviewViewController: UIViewController {

    @IBOutlet weak var btnChargeOn: UIButton!
    @IBOutlet weak var btnChargeOff: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    
    @IBOutlet weak var titleChargeOn: UILabel!
    @IBOutlet weak var titleChargeOff: UILabel!
    @IBOutlet weak var titleComment: UILabel!
    
    
    @IBOutlet weak var headComment: UILabel!
    @IBOutlet weak var textComment: UITextView!
    
    @IBOutlet weak var headPlugType: UILabel!
    @IBOutlet weak var inputPlugType: UITextField!
    
    
    let pickerPlugTypeView = ToolbarPickerView()
    var plugList: [String] = ["test 01", "test 02"]
    var selectedPlug : String?
    
    
    @IBOutlet weak var headIssue: UILabel!
    
    @IBOutlet weak var headPower: UILabel!
    @IBOutlet weak var inputPower: UITextField!
    
    //BG
    @IBOutlet weak var bgCommentView: UIView!
    @IBOutlet weak var bgPlugView: UIView!
    @IBOutlet weak var bgIssueView: UIView!
    @IBOutlet weak var bgPowerView: UIView!
    @IBOutlet weak var bgListImageView: UIView!
    
    @IBOutlet weak var btnAddPlug: UIButton!
    @IBOutlet weak var plugTableView: UITableView!
    @IBOutlet weak var plugTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var imageCollectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnSaveReview: UIButton!
    lazy var viewModel: AddReviewProtocol = {
        let vm = AddReviewViewModel(vc: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvent()
        setupTableView()
    }
    
    func configure(_ interface: AddReviewProtocol) {
        self.viewModel = interface
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        NavigationManager.instance.setupWithNavigationController(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .darkContent
    }
    
    func setupUI() {
        setupCloseViewButton()
        
        titleChargeOn.font = .smallText
        titleChargeOff.font = .smallText
        titleComment.font = .smallText
        
        titleChargeOn.text = "ชาร์จได้"
        titleChargeOff.text = "ชาร์จไม่ได้"
        titleComment.text = "แสดงความคิดเห็น"
        
        btnChargeOn.contentVerticalAlignment = .fill
        btnChargeOn.contentHorizontalAlignment = .fill
        btnChargeOn.imageView?.contentMode = .scaleAspectFit
        
        btnChargeOff.contentVerticalAlignment = .fill
        btnChargeOff.contentHorizontalAlignment = .fill
        btnChargeOff.imageView?.contentMode = .scaleAspectFit
        
        btnComment.contentVerticalAlignment = .fill
        btnComment.contentHorizontalAlignment = .fill
        btnComment.imageView?.contentMode = .scaleAspectFit
        
        selectedCategory(index: 0)
        
        headComment.font = .h3Text
        headComment.textColor = .baseTextGray
        headComment.text = "ความคิดเห็น"
        textComment.setRounded(rounded: 5)
        
        textComment.font = .bodyText
        
        
        headIssue.font = .h3Text
        headIssue.textColor = .baseTextGray
        headIssue.text = "สาเหตุที่ใช้ไม่ได้"
        
        setupDelegatesPlugPickerView()
        
        headPower.font = .h3Text
        headPower.textColor = .baseTextGray
        headPower.text = "กำลังไฟฟ้า"
        
        inputPower.font = .bodyText
        inputPower.setRounded(rounded: 5)
        inputPower.setPaddingLeft(padding: 8)
        inputPower.setPaddingRight(padding: 8)
        
        headPlugType.font = .h3Text
        headPlugType.textColor = .baseTextGray
        headPlugType.text = "หัวจ่าย"
        
        inputPlugType.font = .bodyText
        
        btnAddPlug.setTitle("เลือกหัวชาร์จ", for: .normal)
        btnAddPlug.titleLabel?.font = .h3Text
        btnAddPlug.tintColor = .baseTextGray
        btnAddPlug.titleLabel?.textColor = .baseTextGray
        btnAddPlug.setRounded(rounded: 5)
        
        
        btnSaveReview.setTitle("รีวิว", for: .normal)
        btnSaveReview.titleLabel?.font = .h3Text
        btnSaveReview.setRounded(rounded: 8.0)
        btnSaveReview.backgroundColor = .basePrimary
        btnSaveReview.titleLabel?.textColor = .white
        btnSaveReview.tintColor = .white
        btnSaveReview.addTarget(self, action: #selector(handleBtnSaveReview), for: .touchUpInside)
        
    }
    
    func setupDelegatesPlugPickerView() {
        
        inputPlugType.setRounded(rounded: 5)
        inputPlugType.setPaddingLeft(padding: 8)
        inputPlugType.setPaddingRight(padding: 8)
        inputPlugType.delegate = self
        inputPlugType.inputView = pickerPlugTypeView
        inputPlugType.inputAccessoryView = pickerPlugTypeView.toolbar
        
        pickerPlugTypeView.dataSource = self
        pickerPlugTypeView.delegate = self
        pickerPlugTypeView.toolbarDelegate = self
        
        inputPlugType.text = plugList[0]
        self.selectedPlug =  plugList[0]
    }
    
    private func setupCloseViewButton() {
        var closeButton: UIBarButtonItem = UIBarButtonItem(image: UIImage.init(systemName: "xmark"), style: .plain, target: self, action: #selector(handleCloseViewButton))
        closeButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = closeButton
    }
    
    func setupEvent() {
        self.btnAddPlug.addTarget(self, action: #selector(handleBtnAddPlug), for: .touchUpInside)
    }
    
    func setupTableView() {
        plugTableView.delegate = self
        plugTableView.dataSource = self
        plugTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        plugTableView.registerCell(identifier: PlugTableViewCell.identifier)
        plugTableView.separatorStyle = .none
        plugTableViewHeight.constant = 0
    }
    
    @IBAction func handleSelectCategory(_ sender: UIButton) {
        selectedCategory(index: sender.tag)
    }
    
    func selectedCategory(index: Int) {
        switch index {
        case 0:
            btnChargeOn.tintColor = .green
            btnChargeOff.tintColor = .lightGray
            btnComment.tintColor = .lightGray
        case 1:
            btnChargeOn.tintColor = .lightGray
            btnChargeOff.tintColor = .red
            btnComment.tintColor = .lightGray
        case 2:
            btnChargeOn.tintColor = .lightGray
            btnChargeOff.tintColor = .lightGray
            btnComment.tintColor = .basePrimary
        default:
            break
        }
        checkBGView(index: index)
    }
    
    func checkBGView(index: Int) {
        switch index {
        case 0:
            bgPlugView.isHidden = false
            bgIssueView.isHidden = true
            bgPowerView.isHidden = false
            bgListImageView.isHidden = false
        case 1:
            bgPlugView.isHidden = false
            bgIssueView.isHidden = false
            bgPowerView.isHidden = true
            bgListImageView.isHidden = false
        case 2:
            bgPlugView.isHidden = true
            bgIssueView.isHidden = true
            bgPowerView.isHidden = true
            bgListImageView.isHidden = false
        default:
            break
        }
    }
    
    
    @objc func handleBtnAddPlug() {
        if let stId = viewModel.output.getStId() {
            NavigationManager.instance.pushVC(to: .choosePlug(stId, delegate: self))
        }
    }
    
    @objc func handleCloseViewButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleBtnSaveReview() {
        
    }
    
}

// MARK: - Binding
extension AddReviewViewController {
    
    func bindToViewModel() {
        viewModel.output.didGetPlugStationSuccess = didGetPlugStationSuccess()
    }
    
    func didGetPlugStationSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.plugTableView.reloadData()
        }
    }
}

extension AddReviewViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.plugList.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.plugList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedPlug = self.plugList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.bodyText
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = self.plugList[row]
        return pickerLabel!
    }
}

extension AddReviewViewController: ToolbarPickerViewDelegate {
    
    func didTapDone() {
        self.inputPlugType.text = self.selectedPlug ?? ""
        self.view.endEditing(true)
    }
    
    func didTapCancel() {
        self.view.endEditing(true)
    }
}

extension AddReviewViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
}

extension AddReviewViewController: ChoosePlugViewModelDelegate {
    func didSelectedPlug(_ item: PlugStationData) {
        viewModel.input.setListPlug(items: [item])
    }
}

extension AddReviewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.output.getItemViewCellHeight()
    }
}

extension AddReviewViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.output.getNumberOfRowsInSection(tableView, section: section)
        plugTableViewHeight.constant = (CGFloat(count) * viewModel.output.getItemViewCellHeight())
        btnAddPlug.isHidden = count > 0 ? true : false
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.output.getItemViewCell(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let stId = viewModel.output.getStId() {
            NavigationManager.instance.pushVC(to: .choosePlug(stId, delegate: self))
        }
    }
}

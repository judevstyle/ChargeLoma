//
//  AddReviewViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 23/1/2565 BE.
//

import UIKit

public protocol AddReviewViewControllerDelegate {
    func addReviewDismiss()
}

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
    @IBOutlet weak var inputIssueType: UITextField!
    
    let pickerIssueTypeView = ToolbarPickerView()
    var issueList: [String] = [Wording.Problem.Problem_Value_InUse.localized,
                               Wording.Problem.Problem_Value_CouldNotActivate.localized,
                               Wording.Problem.Problem_Value_BlockByCar.localized,
                               Wording.Problem.Problem_Value_OutOfOrder.localized,
                               Wording.Problem.Problem_Value_StationClose.localized]
    var selectedIssue : String?
    
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
    
    @IBOutlet weak var imageGrid: CollectionViewImageGrid!
    
    fileprivate var listImageAttachFilesBase64: [String]?
    var imagePickerList: ImagePicker!
    
    @IBOutlet weak var btnSaveReview: UIButton!
    
    public var selectedCategory: AddReviewCategoryType = .onCharge
    
    public var delegate: AddReviewViewControllerDelegate?
    
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
        
        self.imagePickerList = ImagePicker(presentationController: self, sourceType: [.camera, .photoLibrary], delegate: self)
    }
    
    func configure(_ interface: AddReviewProtocol) {
        self.viewModel = interface
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        NavigationManager.instance.setupWithNavigationController(self)
    }

    func setupUI() {
        setupCloseViewButton()
        
        titleChargeOn.font = .smallText
        titleChargeOff.font = .smallText
        titleComment.font = .smallText
        
        titleChargeOn.text = Wording.AddReview.AddReview_Btn_ChargedOK.localized
        titleChargeOff.text = Wording.AddReview.AddReview_Btn_CouldNotCharge.localized
        titleComment.text = Wording.AddReview.AddReview_Btn_LeaveComment.localized
        
        btnChargeOn.setImage(UIImage(named: "yes")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnChargeOn.contentVerticalAlignment = .fill
        btnChargeOn.contentHorizontalAlignment = .fill
        btnChargeOn.imageView?.contentMode = .scaleAspectFit
        
        btnChargeOff.setImage(UIImage(named: "no")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnChargeOff.contentVerticalAlignment = .fill
        btnChargeOff.contentHorizontalAlignment = .fill
        btnChargeOff.imageView?.contentMode = .scaleAspectFit
        
        btnComment.setImage(UIImage(named: "comment")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnComment.contentVerticalAlignment = .fill
        btnComment.contentHorizontalAlignment = .fill
        btnComment.imageView?.contentMode = .scaleAspectFit
        
        selectedCategory(index: 0)
        
        headComment.font = .h3Text
        headComment.textColor = .baseTextGray
        headComment.text = Wording.AddReview.AddReview_Head_Comment.localized
        textComment.setRounded(rounded: 5)
        
        textComment.font = .bodyText
        
        
        headIssue.font = .h3Text
        headIssue.textColor = .baseTextGray
        headIssue.text = Wording.AddReview.AddReview_Head_Problem.localized
        
        setupDelegatesPlugPickerView()
        
        headPower.font = .h3Text
        headPower.textColor = .baseTextGray
        headPower.text = Wording.AddReview.AddReview_Head_Power.localized
        
        inputPower.font = .bodyText
        inputPower.setRounded(rounded: 5)
        inputPower.setPaddingLeft(padding: 8)
        inputPower.setPaddingRight(padding: 8)
        
        headPlugType.font = .h3Text
        headPlugType.textColor = .baseTextGray
        headPlugType.text = Wording.AddReview.AddReview_Head_Connectors.localized
        
        inputIssueType.font = .bodyText
        
        btnAddPlug.setTitle(Wording.AddReview.AddReview_Btn_ChooseConnectors.localized, for: .normal)
        btnAddPlug.titleLabel?.font = .h3Text
        btnAddPlug.tintColor = .baseTextGray
        btnAddPlug.titleLabel?.textColor = .baseTextGray
        btnAddPlug.setRounded(rounded: 5)
        
        
        imageGrid.viewModel.input.setDelegate(delegate: self)
        imageGrid.viewModel.input.setList(images: [])
        imageGrid.titleLabel.isHidden = true
        
        btnSaveReview.setTitle(Wording.AddReview.AddReview_Btn_Review.localized, for: .normal)
        btnSaveReview.titleLabel?.font = .h3Text
        btnSaveReview.setRounded(rounded: 8.0)
        btnSaveReview.backgroundColor = .basePrimary
        btnSaveReview.titleLabel?.textColor = .white
        btnSaveReview.tintColor = .white
        btnSaveReview.addTarget(self, action: #selector(handleBtnSaveReview), for: .touchUpInside)
        
        
    }
    
    func setupDelegatesPlugPickerView() {
        
        inputIssueType.setRounded(rounded: 5)
        inputIssueType.setPaddingLeft(padding: 8)
        inputIssueType.setPaddingRight(padding: 8)
        inputIssueType.delegate = self
        inputIssueType.inputView = pickerIssueTypeView
        inputIssueType.inputAccessoryView = pickerIssueTypeView.toolbar
        
        pickerIssueTypeView.dataSource = self
        pickerIssueTypeView.delegate = self
        pickerIssueTypeView.toolbarDelegate = self
        
        inputIssueType.text = issueList[0]
        self.selectedIssue =  issueList[0]
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
            selectedCategory = .onCharge
            btnChargeOn.tintColor = .green
            btnChargeOff.tintColor = .lightGray
            btnComment.tintColor = .lightGray
        case 1:
            selectedCategory = .offCharge
            btnChargeOn.tintColor = .lightGray
            btnChargeOff.tintColor = .red
            btnComment.tintColor = .lightGray
        case 2:
            selectedCategory = .comment
            btnChargeOn.tintColor = .lightGray
            btnChargeOff.tintColor = .lightGray
            btnComment.tintColor = .basePrimary
        default:
            break
        }
        checkBGView()
    }
    
    func checkBGView() {
        switch selectedCategory {
        case .onCharge:
            bgPlugView.isHidden = false
            bgIssueView.isHidden = true
            bgPowerView.isHidden = false
            bgListImageView.isHidden = false
        case .offCharge:
            bgPlugView.isHidden = false
            bgIssueView.isHidden = false
            bgPowerView.isHidden = true
            bgListImageView.isHidden = false
        case .comment:
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
        
        var request: PostReviewRequest = PostReviewRequest()
        
        guard let textComment = textComment.text, !textComment.isEmpty, let stId = viewModel.output.getStId() else { return }
        request.stId = stId
        request.comment = textComment
        
        switch self.selectedCategory {
        case .onCharge:
            guard let plug = viewModel.output.getSelectedPlug() else { return }
            request.pTypeId = plug.plugType?.pTypeId
            request.power = Int("\(inputPower.text ?? "0")") ?? 0
            request.carServe = ""
            request.isCharge = true
        case .offCharge:
            guard let plug = viewModel.output.getSelectedPlug() else { return }
            request.pTypeId = plug.plugType?.pTypeId
            request.power = 0
            request.carServe = selectedIssue ?? ""
            request.isCharge = false
        case .comment:
            request.pTypeId = 1
            request.power = 0
            request.carServe = ""
            request.isCharge = nil
        }
        
        var requestReviewImg: [ReviewImgRequest] = []
        
        self.listImageAttachFilesBase64?.forEach({ path in
            var imageRequest: ReviewImgRequest = ReviewImgRequest()
            imageRequest.imgBase64 = path
            requestReviewImg.append(imageRequest)
        })
        
        request.reviewImg = requestReviewImg
        
        viewModel.input.createReview(request: request)
        
    }
    
}

// MARK: - Binding
extension AddReviewViewController {
    
    func bindToViewModel() {
        viewModel.output.didGetPlugStationSuccess = didGetPlugStationSuccess()
        viewModel.output.didPostReviewSuccess = didPostReviewSuccess()
    }
    
    func didGetPlugStationSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.plugTableView.reloadData()
        }
    }
    
    func didPostReviewSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let self = self else { return }
            self.delegate?.addReviewDismiss()
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension AddReviewViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.issueList.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.issueList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedIssue = self.issueList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.bodyText
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = self.issueList[row]
        return pickerLabel!
    }
}

extension AddReviewViewController: ToolbarPickerViewDelegate {
    
    func didTapDone() {
        self.inputIssueType.text = self.selectedIssue ?? ""
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
    func didSelectedPlugTypeMaster(_ item: PlugTypeData, power: Int) {
    }
    
    func didSelectedPlugStation(_ item: PlugStationData) {
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

extension AddReviewViewController: ImagePickerDelegate {
    func didSelectImage(image: UIImage?, imagePicker: ImagePicker, base64: String) {
        imageGrid.viewModel.input.addListImage(image: image ?? UIImage(), base64: base64)
    }
}

extension AddReviewViewController : CollectionViewImageGridDelegate {
    func imageListChangeAction(listBase64: [String]?) {
        self.listImageAttachFilesBase64 = listBase64
    }
    
    func didSelectItem(indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.imagePickerList.present(from: self.view)
        }
    }
}

public enum AddReviewCategoryType {
    case onCharge
    case offCharge
    case comment
}

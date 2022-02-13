//
//  AddLocationViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 29/12/2564 BE.
//

import UIKit
import RadioGroup
import GoogleMaps

class AddLocationViewController: UIViewController {
    
    
    @IBOutlet weak var headNameStation: UILabel!
    @IBOutlet weak var inputNameStation: UITextField!
    
    @IBOutlet weak var headDesc: UILabel!
    @IBOutlet weak var inputDesc: UITextField!
    @IBOutlet weak var inputTel: UITextField!
    
    @IBOutlet weak var radioGroupStatus: RadioGroup!
    
    @IBOutlet weak var box1BottomLineView: UIView!
    
    
    @IBOutlet weak var box2View: UIView!
    @IBOutlet weak var headIs24Hr: UILabel!
    @IBOutlet weak var inputOpenTime: UITextField!
    @IBOutlet weak var switchIs24Hr: UISwitch!
    @IBOutlet weak var inputOpenTimeHeight: NSLayoutConstraint!
    
    @IBOutlet weak var box2BottomView: UIView!
    
    
    @IBOutlet weak var headStation: UILabel!
    @IBOutlet weak var headService: UILabel!
    @IBOutlet weak var switchIsService: UISwitch!
    @IBOutlet weak var inputService: UITextField!
    
    @IBOutlet weak var headProvider: UILabel!
    @IBOutlet weak var btnSelectProvider: UIButton!
    
    @IBOutlet weak var btnSelectProviderView: UIView!
    @IBOutlet weak var btnSelectProviderViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableProviderView: UITableView!
    @IBOutlet weak var boxTableProvider: UIView!
    
    @IBOutlet weak var headPlug: UILabel!
    @IBOutlet weak var tablePlugView: UITableView!
    @IBOutlet weak var tablePlugViewHeight: NSLayoutConstraint!
    @IBOutlet weak var boxTablePlug: UIView!
    
    @IBOutlet weak var btnSelectLocation: UIButton!
    @IBOutlet weak var inputLocationText: UITextField!
    
    @IBOutlet weak var radioGroupStatusBox2: RadioGroup!
    
    @IBOutlet weak var headServiceOther: UILabel!
    
    @IBOutlet weak var cbParking: CheckBoxView!
    @IBOutlet weak var titleParking: UILabel!
    
    @IBOutlet weak var cbFoodShop: CheckBoxView!
    @IBOutlet weak var titleFoodShop: UILabel!
    
    @IBOutlet weak var cbCoffeeShop: CheckBoxView!
    @IBOutlet weak var titleCoffeeShop: UILabel!
    
    @IBOutlet weak var cbToilet: CheckBoxView!
    @IBOutlet weak var titleToilet: UILabel!
    
    @IBOutlet weak var cbMarket: CheckBoxView!
    @IBOutlet weak var titleMarket: UILabel!
    
    @IBOutlet weak var cbSleep: CheckBoxView!
    @IBOutlet weak var titleSleep: UILabel!
    
    @IBOutlet weak var cbWifi: CheckBoxView!
    @IBOutlet weak var titleWifi: UILabel!
    
    @IBOutlet weak var cbOther: CheckBoxView!
    @IBOutlet weak var titleOther: UILabel!
    
    @IBOutlet weak var btnSaveData: UIButton!
    @IBOutlet weak var inputOtherText: UITextField!
    
    
    //Var
    

    public var typeService: String = ""
    public var is24hr: Bool = false
    public var servicetimeOpen: String?
    public var servicetimeClose: String?
    public var isServiceCharge: Bool = false
    public var serviceRate: Int?
    public var statusApprove: String?
    public var stationStatus: Int = 0
    public var note: String?
    
    
    lazy var viewModel: AddLocationProtocol = {
        let vm = AddLocationViewModel(vc: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationManager.instance.setupWithNavigationController(self)
        setupTableView()
        setRadioStatus1Group()
        setRadioStatus2Group()
    }
    
    func configure(_ interface: AddLocationProtocol) {
        self.viewModel = interface
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard UserDefaultsKey.UID.string != nil, UserDefaultsKey.isLoggedIn.bool == true else {
            NavigationManager.instance.pushVC(to: .preLogin, presentation: .PushInTabbar, animated: false)
            return
        }
        setupUI()
//        setupEmptyValue()
    }
    
    func setupEmptyValue() {
        viewModel.input.setProviderList(items: [])
        viewModel.input.setClearResetValue()
    }
    
    func setupUI() {
        setupHeadLabel(lb: headNameStation, title: "ชื่อสถานี")
        setupUITextFields(tf: inputNameStation)
        setupHeadLabel(lb: headDesc, title: "คำอธิบาย")
        setupUITextFields(tf: inputDesc)
        setupUITextFields(tf: inputTel, placeholder: "เบอร์โทร")
        
        box1BottomLineView.setBorderBottom(color: .gray)
        
        setupHeadLabel(lb: headIs24Hr, title: "เปิด 24 ชม.")
        setupUITextFields(tf: inputOpenTime)
        switchIs24Hr.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        switchIs24Hr.isOn = false
        box2BottomView.setBorderBottom(color: .gray)
        
        setupHeadLabel(lb: headStation, title: "สถานี")
        setupHeadLabel(lb: headService, title: "มีค่าบริการ")
        setupUITextFields(tf: inputService, placeholder: "ราคา (ถ้ามี)")
        setupHeadLabel(lb: headProvider, title: "ผู้ให้บริการ")
        
        switchIsService.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        switchIsService.isOn = false
        btnSelectProvider.setRounded(rounded: 5)
        btnSelectProvider.setTitle("เลือกผู้ให้บริการ", for: .normal)
        btnSelectProvider.titleLabel?.font = .bodyText
        btnSelectProvider.titleLabel?.textColor = .baseTextGray
        btnSelectProvider.tintColor = .baseTextGray
        btnSelectProvider.backgroundColor = .systemGray5
        btnSelectProvider.addTarget(self, action: #selector(handleSelectProvider), for: .touchUpInside)
        
        setupHeadLabel(lb: headPlug, title: "หัวจ่าย")
        
        btnSelectLocation.setTitle("แก้ไข้พิกัด", for: .normal)
        btnSelectLocation.tintColor = .basePrimary
        btnSelectLocation.setRounded(rounded: 5)
        btnSelectLocation.setBorder(width: 1.0, color: .basePrimary)
        btnSelectLocation.titleLabel?.font = .bodyBold
        btnSelectLocation.addTarget(self, action: #selector(handleSelectLocation), for: .touchUpInside)
        
        setupUITextFields(tf: inputLocationText, placeholder: "ที่อยู่...")
        setupCheckBox()
        
        setupUITextFields(tf: inputOtherText)
        
        btnSaveData.setTitle("บันทึก", for: .normal)
        btnSaveData.tintColor = .white
        btnSaveData.setRounded(rounded: 5)
        btnSaveData.titleLabel?.font = .bodyBold
        btnSaveData.backgroundColor = .basePrimary
        btnSaveData.addTarget(self, action: #selector(handleSaveData), for: .touchUpInside)
        
    }
    
    func setupCheckBox() {
        setupHeadLabel(lb: headServiceOther, title: "สิ่งอำนวยความสะดวกอื่นๆ")
        
        self.cbParking.delegate = self
        self.cbFoodShop.delegate = self
        self.cbCoffeeShop.delegate = self
        self.cbToilet.delegate = self
        self.cbMarket.delegate = self
        self.cbSleep.delegate = self
        self.cbWifi.delegate = self
        self.cbOther.delegate = self
        
        self.titleParking.text = "ที่จอดรถ"
        self.titleFoodShop.text = "ร้านอาหาร"
        self.titleCoffeeShop.text = "ร้านกาแฟ"
        self.titleToilet.text = "ห้องน้ำ"
        self.titleMarket.text = "ร้านค้า"
        self.titleSleep.text = "ที่พักผ่อน"
        self.titleWifi.text = "Wifi"
        self.titleOther.text = "อื่นๆ"
        
        self.titleParking.font = .bodyText
        self.titleParking.textColor = .darkGray
        
        self.titleFoodShop.font = .bodyText
        self.titleFoodShop.textColor = .darkGray
        
        self.titleCoffeeShop.font = .bodyText
        self.titleCoffeeShop.textColor = .darkGray
        
        self.titleToilet.font = .bodyText
        self.titleToilet.textColor = .darkGray
        
        self.titleMarket.font = .bodyText
        self.titleMarket.textColor = .darkGray
        
        self.titleSleep.font = .bodyText
        self.titleSleep.textColor = .darkGray
        
        self.titleWifi.font = .bodyText
        self.titleWifi.textColor = .darkGray
        
        self.titleOther.font = .bodyText
        self.titleOther.textColor = .darkGray
    }
    
    func setupUITextFields(tf: UITextField, placeholder: String = "") {
//        tf.delegate = self
        tf.font = .bodyText
        tf.textColor = .baseTextGray
        tf.placeholder = placeholder
//        tf.text = ""
        tf.setTextFieldBottom(color: .gray)
    }
    
    func setupHeadLabel(lb: UILabel, title: String) {
        lb.font = .bodyText
        lb.textColor = .baseTextGray
        lb.text = title
    }
    
    func setRadioStatus1Group() {
        radioGroupStatus.titles = [RadioGroupStatusBox1Type.publicStatus.rawValue, RadioGroupStatusBox1Type.privateStatus.rawValue]
        radioGroupStatus.tintColor = .basePrimary      // surrounding ring
        radioGroupStatus.selectedIndex = 0
        radioGroupStatus.titleColor = .baseTextGray
        radioGroupStatus.itemSpacing = 8
        radioGroupStatus.spacing = 20
        radioGroupStatus.buttonSize = 21
        radioGroupStatus.isVertical = false
        radioGroupStatus.titleAlignment = .left
        radioGroupStatus.titleFont = .bodyText
        radioGroupStatus.contentHorizontalAlignment = .left
        radioGroupStatus.addTarget(self, action: #selector(selectedRadioStatus1), for: .valueChanged)
    }
    
    func setRadioStatus2Group() {
        radioGroupStatusBox2.titles = [RadioGroupStatusBox2Type.openStatus.rawValue, RadioGroupStatusBox2Type.soonStatus.rawValue, RadioGroupStatusBox2Type.closeStatus.rawValue, RadioGroupStatusBox2Type.privateStatus.rawValue]
        radioGroupStatusBox2.tintColor = .basePrimary      // surrounding ring
        radioGroupStatusBox2.selectedIndex = 0
        radioGroupStatus.titleColor = .baseTextGray
        radioGroupStatusBox2.itemSpacing = 8
        radioGroupStatusBox2.spacing = 20
        radioGroupStatusBox2.buttonSize = 21
        radioGroupStatusBox2.isVertical = false
        radioGroupStatusBox2.titleAlignment = .left
        radioGroupStatusBox2.titleFont = .bodyText
        radioGroupStatusBox2.contentHorizontalAlignment = .left
        radioGroupStatusBox2.addTarget(self, action: #selector(selectedRadioStatus2), for: .valueChanged)
    }
    
    @objc func selectedRadioStatus1() {
        if let title = radioGroupStatus.titles[radioGroupStatus.selectedIndex], let type = RadioGroupStatusBox1Type(rawValue: title) {
            self.typeService = type.value
        }
    }
    
    @objc func selectedRadioStatus2() {
        if let title = radioGroupStatus.titles[radioGroupStatus.selectedIndex], let type = RadioGroupStatusBox2Type(rawValue: title) {
            self.stationStatus = type.value
        }
    }
    
    @objc func handleSelectLocation() {
        NavigationManager.instance.pushVC(to: .selectCurrentLocation(delegate: self))
    }
    
    @objc func handleSaveData() {
        guard let stationName = inputNameStation.text, !stationName.isEmpty,
        let stationDesc = inputDesc.text, !stationDesc.isEmpty,
        let tel = inputTel.text, !tel.isEmpty,
        let addr = inputLocationText.text, !addr.isEmpty else { return }
        
        viewModel.input.createStation(stationName: stationName, stationDesc: stationDesc, tel: tel, typeService: self.typeService, is24hr: self.is24hr, addr: addr, servicetimeOpen: inputOpenTime.text, servicetimeClose: "", isServiceCharge: self.isServiceCharge, serviceRate: Int(inputService.text ?? "0"), statusApprove: "W", stationStatus: self.stationStatus, note: inputOtherText.text)
    }
    
    @IBAction func handleCheckIs24Hr(_ sender: UISwitch) {
        if sender.isOn {
            inputOpenTimeHeight.constant = 0
            inputOpenTime.isHidden = true
        } else {
            inputOpenTimeHeight.constant = 60
            inputOpenTime.isHidden = false
        }
        
        self.is24hr = sender.isOn
    }
    
    @IBAction func handleCheckIsServiceCharge(_ sender: UISwitch) {
        self.isServiceCharge = sender.isOn
    }
    
    @objc func handleSelectProvider() {
        NavigationManager.instance.pushVC(to: .chooseProvider(delegate: self))
    }
    
    func setupTableView() {
        tableProviderView.delegate = self
        tableProviderView.dataSource = self
        tableProviderView.separatorStyle = .none
        tableProviderView.registerCell(identifier: ProviderTableViewCell.identifier)
        tableProviderView.setRounded(rounded: 5)
        tableProviderView.isScrollEnabled = false
        
        tablePlugView.delegate = self
        tablePlugView.dataSource = self
        tablePlugView.separatorStyle = .singleLine
        tablePlugView.registerCell(identifier: SelectPlugTableViewCell.identifier)
        tablePlugView.registerCell(identifier: PlugTableViewCell.identifier)
        tablePlugView.setRounded(rounded: 5)
        tablePlugView.isScrollEnabled = false
    }
    
}

// MARK: - Binding
extension AddLocationViewController {
    
    func bindToViewModel() {
        viewModel.output.didSetPlugTypeRequestSuccess = didSetPlugTypeRequestSuccess()
        viewModel.output.didGetGeoCodeSuccess = didGetGeoCodeSuccess()
        viewModel.output.didGetProviderMasterSuccess = didGetProviderMasterSuccess()
    }
    
    func didSetPlugTypeRequestSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.tablePlugView.reloadData()
        }
    }
    
    func didGetProviderMasterSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.tableProviderView.reloadData()
        }
    }
    
    func didGetGeoCodeSuccess() -> ((String?) -> Void) {
        return { location in
            self.inputLocationText.text = location
        }
    }
}

// MARK: - UITextField
extension AddLocationViewController: UITextFieldDelegate {
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        switch textField {
//        case inputNameStation:
//            inputNameStation.clearSubLayer(onCompletion: {
//                self.inputNameStation.setTextFieldBottom(color: .basePrimary)
//            })
//        case inputDesc:
//            inputDesc.clearSubLayer(onCompletion: {
//                self.inputDesc.setTextFieldBottom(color: .basePrimary)
//            })
//        case inputTel:
//            inputTel.clearSubLayer(onCompletion: {
//                self.inputTel.setTextFieldBottom(color: .basePrimary)
//            })
//        case inputOpenTime:
//            inputOpenTime.clearSubLayer(onCompletion: {
//                self.inputOpenTime.setTextFieldBottom(color: .basePrimary)
//            })
//        default:
//            break
//        }
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
//        switch textField {
//        case inputNameStation:
//            inputNameStation.clearSubLayer(onCompletion: {
//                self.inputNameStation.setTextFieldBottom(color: .gray)
//            })
//        case inputDesc:
//            inputDesc.clearSubLayer(onCompletion: {
//                self.inputDesc.setTextFieldBottom(color: .gray)
//            })
//        case inputTel:
//            inputTel.clearSubLayer(onCompletion: {
//                self.inputTel.setTextFieldBottom(color: .gray)
//            })
//        case inputOpenTime:
//            inputOpenTime.clearSubLayer(onCompletion: {
//                self.inputOpenTime.setTextFieldBottom(color: .gray)
//            })
//        default:
//            break
//        }
//    }
}

public enum RadioGroupStatusBox1Type: String {
    case publicStatus = "เปิดสาธารณะ"
    case privateStatus = "ใช้ส่วนตัว"

    
    public var value: String {
        switch self {
        case .publicStatus:
            return "public"
        case .privateStatus:
            return "private"
        }
    }
}

public enum RadioGroupStatusBox2Type: String {
    case openStatus = "เปิดบริการ"
    case soonStatus = "เปิดเร็วๆนี้"
    case closeStatus = "ปิดปรับปรุง"
    case privateStatus = "ใช้ส่วนตัว"
    
    public var value: Int {
        switch self {
        case .openStatus:
            return 0
        case .soonStatus:
            return 1
        case .closeStatus:
            return 2
        case .privateStatus:
            return 3
        }
    }
}

extension AddLocationViewController: ChooseProviderViewModelDelegate {
    func didSelectedProvider(_ item: ProviderData) {
        viewModel.input.setProviderList(items: [item])
        tableProviderView.reloadData()
    }
}

extension AddLocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case tableProviderView:
            return viewModel.output.getItemViewCellHeight(type: .tableProviderView)
        case tablePlugView:
            return viewModel.output.getItemViewCellHeight(type: .tablePlugView)
        default:
            return 0
        }
    }
}

extension AddLocationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case tableProviderView:
            let count = viewModel.output.getNumberOfRowsInSection(tableView, section: section, type: .tableProviderView)
            if count == 0 {
                btnSelectProviderView.isHidden = false
                btnSelectProviderViewHeight.constant = 40
                
                boxTableProvider.isHidden = true
                
            } else {
                btnSelectProviderView.isHidden = true
                btnSelectProviderViewHeight.constant = 0
                boxTableProvider.isHidden = false
            }
            return count
        case tablePlugView:
            let count = viewModel.output.getNumberOfRowsInSection(tableView, section: section, type: .tablePlugView)
            if count == 0 {
                boxTablePlug.isHidden = true
                tablePlugViewHeight.constant = 0
            } else {
                boxTablePlug.isHidden = false
                tablePlugViewHeight.constant = CGFloat(count * 80)
            }
            return count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case tableProviderView:
            return viewModel.output.getItemViewCell(tableView, indexPath: indexPath, type: .tableProviderView)
        case tablePlugView:
            return viewModel.output.getItemViewCell(tableView, indexPath: indexPath, type: .tablePlugView)
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case tableProviderView:
            NavigationManager.instance.pushVC(to: .chooseProvider(delegate: self))
        case tablePlugView:
            if indexPath.row == 0 {
                NavigationManager.instance.pushVC(to: .choosePlug("", delegate: self))
            }
        default:
            break
        }
    }
}

//ChoosePlugTypeData
extension AddLocationViewController: ChoosePlugViewModelDelegate {
    func didSelectedPlugStation(_ item: PlugStationData) {
    }
    
    func didSelectedPlugTypeMaster(_ item: PlugTypeData, power: Int) {
        viewModel.input.didSetPlugTypeRequest(item: item, power: power)
    }
}

extension AddLocationViewController: SelectCurrentLocationViewControllerDelegate {
    func didSubmitEditLocation(centerMapCoordinate: CLLocationCoordinate2D) {
        viewModel.input.didSelectLocation(centerMapCoordinate: centerMapCoordinate)
    }
}

extension AddLocationViewController: CheckBoxViewDelegate {
    func didSelected(view: CheckBoxView, isSelectedBtn: Bool, index: Int) {
        switch view {
        case cbParking:
            viewModel.input.didSelectCheckBox(isSelected: isSelectedBtn, type: .parking)
        case cbFoodShop:
            viewModel.input.didSelectCheckBox(isSelected: isSelectedBtn, type: .foodShop)
        case cbCoffeeShop:
            viewModel.input.didSelectCheckBox(isSelected: isSelectedBtn, type: .coffeeShop)
        case cbToilet:
            viewModel.input.didSelectCheckBox(isSelected: isSelectedBtn, type: .toilet)
        case cbMarket:
            viewModel.input.didSelectCheckBox(isSelected: isSelectedBtn, type: .market)
        case cbSleep:
            viewModel.input.didSelectCheckBox(isSelected: isSelectedBtn, type: .sleep)
        case cbWifi:
            viewModel.input.didSelectCheckBox(isSelected: isSelectedBtn, type: .wifi)
        case cbOther:
            viewModel.input.didSelectCheckBox(isSelected: isSelectedBtn, type: .other)
        default:
            break
        }
    }
}

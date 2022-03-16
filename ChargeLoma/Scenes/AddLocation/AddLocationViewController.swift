//
//  AddLocationViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 29/12/2564 BE.
//

import UIKit
import RadioGroup
import GoogleMaps

public protocol AddLocationViewControllerDelegate {
    func dismissAddLocationView()
}

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var headNameStation: UILabel!
    @IBOutlet weak var inputNameStation: UnderlinedTextField!
    
    @IBOutlet weak var headDesc: UILabel!
    @IBOutlet weak var inputDesc: UnderlinedTextField!
    @IBOutlet weak var inputTel: UnderlinedTextField!
    
    @IBOutlet weak var radioGroupStatus: RadioGroup!

    @IBOutlet weak var box2View: UIView!
    @IBOutlet weak var headIs24Hr: UILabel!
    @IBOutlet weak var inputOpenTime: UnderlinedTextField!
    @IBOutlet weak var switchIs24Hr: UISwitch!
    @IBOutlet weak var inputOpenTimeHeight: NSLayoutConstraint!
    
    @IBOutlet weak var headStation: UILabel!
    @IBOutlet weak var headService: UILabel!
    @IBOutlet weak var switchIsService: UISwitch!
    @IBOutlet weak var inputService: UnderlinedTextField!
    
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
    @IBOutlet weak var inputLocationText: UnderlinedTextField!
    
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
    @IBOutlet weak var inputOtherText: UnderlinedTextField!

    public var typeService: String = ""
    public var stationStatus: Int = 0
    
    lazy var viewModel: AddLocationProtocol = {
        let vm = AddLocationViewModel(vc: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    public var stationData: StationData? = nil
    public var isFromPushNavigation: Bool = false
    public var delegate: AddLocationViewControllerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationManager.instance.setupWithNavigationController(self)
        setupUI()
        setupTableView()
        setRadioStatus1Group()
        setRadioStatus2Group()
        setupValue()
    }
    
    func configure(_ interface: AddLocationProtocol) {
        self.viewModel = interface
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent, self.isFromPushNavigation {
            self.delegate?.dismissAddLocationView()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func setupValue() {
        guard let station = viewModel.output.getStationData() else { return }
        navigationItem.title = Wording.NavigationTitle.NavigationTitle_EditStation.localized
        inputNameStation.text = station.stationName ?? ""
        inputDesc.text = station.stationDesc ?? ""
        inputTel.text = station.tel ?? ""
        
        //TypeService
        if let typeService = station.typeService , let index = RadioGroupStatusBox1Type.allValues.firstIndex(where: {$0.value == typeService}) {
            radioGroupStatus.selectedIndex = index
            self.typeService = typeService
        }
        
        //is24hr
        switchIs24Hr.isOn = station.is24hr ?? false
        if switchIs24Hr.isOn == false {
            inputOpenTime.text = station.servicetimeOpen ?? ""
        }
        handleCheckIs24Hr(switchIs24Hr)
        
        //isServiceCharge
        switchIsService.isOn = station.isServiceCharge ?? false
        handleCheckIsServiceCharge(switchIsService)
        if let serviceRate = station.serviceRate, switchIsService.isOn == true  {
            inputService.text = "\(serviceRate)"
        }
        
        viewModel.input.getProviderMaster()
        viewModel.input.getPlugStation()
        
        //Address
        inputLocationText.text = station.addr ?? ""
        if let lat = station.lat , let lng = station.lng {
            viewModel.input.setSelectLocation(centerMapCoordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng))
        }
        
        //stationStatus
        if let stationStatus = station.stationStatus , let index = RadioGroupStatusBox2Type.allValues.firstIndex(where: {$0.value == stationStatus}) {
            radioGroupStatusBox2.selectedIndex = index
            self.stationStatus = stationStatus
        }
        
        //CB
        didSetCheckbox(cb: cbParking, isSelected: station.isServiceParking ?? false)
        didSetCheckbox(cb: cbFoodShop, isSelected: station.isServiceFood ?? false)
        didSetCheckbox(cb: cbCoffeeShop, isSelected: station.isServiceCoffee ?? false)
        didSetCheckbox(cb: cbToilet, isSelected: station.isServiceRestroom ?? false)
        didSetCheckbox(cb: cbMarket, isSelected: station.isServiceShoping ?? false)
        didSetCheckbox(cb: cbSleep, isSelected: station.isServiceRestarea ?? false)
        didSetCheckbox(cb: cbWifi, isSelected: station.isServiceWifi ?? false)
        didSetCheckbox(cb: cbOther, isSelected: station.isServiceOther ?? false)
        
        inputOtherText.text = station.note ?? ""
    }
    
    func setupEmptyValue() {
        viewModel.input.setSelectedProviderList(items: [])
        viewModel.input.setClearResetValue()
    }
    
    private func setupCloseViewButton() {
        var closeButton: UIBarButtonItem = UIBarButtonItem(image: UIImage.init(systemName: "xmark"), style: .plain, target: self, action: #selector(handleCloseViewButton))
        closeButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = closeButton
    }
    
    func didSetCheckbox(cb: CheckBoxView, isSelected: Bool) {
        didSelected(view: cb, isSelectedBtn: isSelected, index: 0)
        cb.setCheckBox(isSelected: isSelected)
    }
    
    func setupUI() {
        setupHeadLabel(lb: headNameStation, title: Wording.AddStation.AddStation_Head_StationName.localized)
        setupUITextFields(tf: inputNameStation)
        setupHeadLabel(lb: headDesc, title: Wording.AddStation.AddStation_Head_Description.localized)
        setupUITextFields(tf: inputDesc)
        setupUITextFields(tf: inputTel, placeholder: Wording.AddStation.AddStation_Placeholder_Tel.localized)
        
        setupHeadLabel(lb: headIs24Hr, title: Wording.AddStation.AddStation_Head_Is24Hr.localized)
        setupUITextFields(tf: inputOpenTime)
        switchIs24Hr.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        switchIs24Hr.isOn = false
        
        setupHeadLabel(lb: headStation, title: Wording.AddStation.AddStation_Head_Station.localized)
        setupHeadLabel(lb: headService, title: Wording.AddStation.AddStation_Head_ServiceCharge.localized)
        setupUITextFields(tf: inputService, placeholder: Wording.AddStation.AddStation_Head_PriceIsHas.localized)
        setupHeadLabel(lb: headProvider, title: Wording.AddStation.AddStation_Head_Provider.localized)
        
        switchIsService.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        switchIsService.isOn = false
        btnSelectProvider.setRounded(rounded: 5)
        btnSelectProvider.setTitle(Wording.AddStation.AddStation_Btn_ChooseProvider.localized, for: .normal)
        btnSelectProvider.titleLabel?.font = .bodyText
        btnSelectProvider.titleLabel?.textColor = .baseTextGray
        btnSelectProvider.tintColor = .baseTextGray
        btnSelectProvider.backgroundColor = .systemGray5
        btnSelectProvider.addTarget(self, action: #selector(handleSelectProvider), for: .touchUpInside)
        
        setupHeadLabel(lb: headPlug, title: Wording.AddStation.AddStation_Head_Connectors.localized)
        
        btnSelectLocation.setTitle(Wording.AddStation.AddStation_Btn_EditLocation.localized, for: .normal)
        btnSelectLocation.tintColor = .basePrimary
        btnSelectLocation.setRounded(rounded: 5)
        btnSelectLocation.setBorder(width: 1.0, color: .basePrimary)
        btnSelectLocation.titleLabel?.font = .bodyBold
        btnSelectLocation.addTarget(self, action: #selector(handleSelectLocation), for: .touchUpInside)
        
        setupUITextFields(tf: inputLocationText, placeholder: Wording.AddStation.AddStation_Placeholder_Address.localized)
        setupCheckBox()
        
        setupUITextFields(tf: inputOtherText)
        
        btnSaveData.setTitle(Wording.AddStation.AddStation_Btn_Save.localized, for: .normal)
        btnSaveData.tintColor = .white
        btnSaveData.setRounded(rounded: 5)
        btnSaveData.titleLabel?.font = .bodyBold
        btnSaveData.backgroundColor = .basePrimary
        btnSaveData.addTarget(self, action: #selector(handleSaveData), for: .touchUpInside)
        btnSaveData.titleLabel?.sizeToFit()
        
        
        if isFromPushNavigation == true {
        } else {
            setupCloseViewButton()
        }
        
    }
    
    func setupCheckBox() {
        setupHeadLabel(lb: headServiceOther, title: Wording.AddStation.AddStation_Head_Service.localized)
        
        self.cbParking.delegate = self
        self.cbFoodShop.delegate = self
        self.cbCoffeeShop.delegate = self
        self.cbToilet.delegate = self
        self.cbMarket.delegate = self
        self.cbSleep.delegate = self
        self.cbWifi.delegate = self
        self.cbOther.delegate = self
        
        self.titleParking.text = Wording.cb.Checkbox_Parking.localized
        self.titleFoodShop.text = Wording.cb.Checkbox_Food.localized
        self.titleCoffeeShop.text = Wording.cb.Checkbox_Coffee.localized
        self.titleToilet.text = Wording.cb.Checkbox_RestRoom.localized
        self.titleMarket.text = Wording.cb.Checkbox_Shopping.localized
        self.titleSleep.text = Wording.cb.Checkbox_RestArea.localized
        self.titleWifi.text = Wording.cb.Checkbox_Wifi.localized
        self.titleOther.text = Wording.cb.Checkbox_Other.localized
        
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
    }
    
    func setupHeadLabel(lb: UILabel, title: String) {
        lb.font = .bodyText
        lb.textColor = .baseTextGray
        lb.text = title
    }
    
    func setRadioStatus1Group() {
        radioGroupStatus.titles = [RadioGroupStatusBox1Type.publicStatus.title, RadioGroupStatusBox1Type.privateStatus.title]
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
        radioGroupStatusBox2.titles = [RadioGroupStatusBox2Type.openStatus.title, RadioGroupStatusBox2Type.soonStatus.title, RadioGroupStatusBox2Type.closeStatus.title, RadioGroupStatusBox2Type.privateStatus.title]
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
        if let title = radioGroupStatus.titles[radioGroupStatus.selectedIndex], let type = RadioGroupStatusBox1Type.allValues.filter({ $0.title == title }).first  {
            self.typeService = type.value
        }
    }
    
    @objc func selectedRadioStatus2() {
        if let title = radioGroupStatus.titles[radioGroupStatus.selectedIndex], let type = RadioGroupStatusBox2Type.allValues.filter({ $0.title == title }).first {
            self.stationStatus = type.value
        }
    }
    
    @objc func handleSelectLocation() {
        NavigationManager.instance.pushVC(to: .selectCurrentLocation(delegate: self))
    }
    
    @objc func handleSaveData() {
        guard let stationName = inputNameStation.text, !stationName.isEmpty,
        let addr = inputLocationText.text, !addr.isEmpty else { return }
        
        let serviceRate: Double? = Double(inputService.getText ?? "0")
        viewModel.input.createStation(stationName: stationName, stationDesc: inputDesc.getText ?? "", tel: inputTel.getText ?? "", typeService: self.typeService, is24hr: switchIs24Hr.isOn, addr: addr, servicetimeOpen: inputOpenTime.text, servicetimeClose: "", isServiceCharge: switchIsService.isOn, serviceRate: serviceRate, statusApprove: "W", stationStatus: self.stationStatus, note: inputOtherText.text)
    }
    
    @objc func handleCloseViewButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleCheckIs24Hr(_ sender: UISwitch) {
        if sender.isOn {
            inputOpenTimeHeight.constant = 0
            inputOpenTime.isHidden = true
        } else {
            inputOpenTimeHeight.constant = 60
            inputOpenTime.isHidden = false
        }
    }
    
    @IBAction func handleCheckIsServiceCharge(_ sender: UISwitch) {
    
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
        viewModel.output.didGetAllProviderMasterSuccess = didGetAllProviderMasterSuccess()
        
        viewModel.output.didGetAllPlugTypeSuccess = didGetAllPlugTypeSuccess()
        viewModel.output.didUpdateStationSuccess = didUpdateStationSuccess()
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
    
    func didGetAllProviderMasterSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let self = self else { return }
            if let station = self.viewModel.output.getStationData(),
               let item = self.viewModel.output.getListAllProviderList().filter({$0.pvId == station.provider?.pvId}).first {
                self.viewModel.input.setSelectedProviderList(items: [item])
                self.tableProviderView.reloadData()
            }
        }
    }
    
    func didGetAllPlugTypeSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let self = self else { return }
            if let station = self.viewModel.output.getStationData() {

                station.plugMapping?.forEach({ item in
                    if let plug = self.viewModel.output.getListAllPlugTypeList().filter({$0.pTypeId == item.plugTypeMaster?.pTypeId}).first {
                        let power = Int(item.power ?? "0")
                        self.viewModel.input.didSetPlugTypeRequest(item: plug, power: power ?? 0)
                    }
                })
            }
        }
    }
    
    func didUpdateStationSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                if self.isFromPushNavigation == true {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    
}

public enum RadioGroupStatusBox1Type {
    case publicStatus
    case privateStatus

    static let allValues = [publicStatus, privateStatus]
    
    public var value: String {
        switch self {
        case .publicStatus:
            return "public"
        case .privateStatus:
            return "private"
        }
    }
    
    public var title: String {
        switch self {
        case .publicStatus:
            return Wording.cb.Checkbox_PublicStation.localized
        case .privateStatus:
            return Wording.cb.Checkbox_PrivateStation.localized
        }
    }
}

public enum RadioGroupStatusBox2Type {
    case openStatus
    case soonStatus
    case closeStatus
    case privateStatus
    
    static let allValues = [openStatus, soonStatus, closeStatus, privateStatus]
    
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
    
    public var title: String {
        switch self {
        case .openStatus:
            return Wording.cb.Checkbox_Normal.localized
        case .soonStatus:
            return Wording.cb.Checkbox_OpenSoon.localized
        case .closeStatus:
            return Wording.cb.Checkbox_OnMaintanance.localized
        case .privateStatus:
            return Wording.cb.Checkbox_PrivateStation.localized
        }
    }
}

extension AddLocationViewController: ChooseProviderViewModelDelegate {
    func didSelectedProvider(_ item: ProviderData) {
        viewModel.input.setSelectedProviderList(items: [item])
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

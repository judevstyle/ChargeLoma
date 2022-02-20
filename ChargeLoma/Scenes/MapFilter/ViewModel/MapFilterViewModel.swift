//
//  MapFilterViewModel.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 9/1/2565 BE.
//

import Foundation
import UIKit
import Combine

protocol MapFilterProtocolInput {
    func getPlugTypeMaster()
    func getProviderMaster()
    func getStatusFilter()
    
    func setSelectedACAll(selected: Bool)
    func setSelectedACIndex(index: Int, selected: Bool)
    
    func setSelectedDCAll(selected: Bool)
    func setSelectedDCIndex(index: Int, selected: Bool)
    
    func setSelectedProviderMasterAll(selected: Bool)
    func setSelectedProviderMasterIndex(index: Int, selected: Bool)
    
    func setSelectedStatusFilterIndex(index: Int, selected: Bool)
}

protocol MapFilterProtocolOutput: class {
    var didGetACPlugTypeSuccess: (() -> Void)? { get set }
    var didGetDCPlugTypeSuccess: (() -> Void)? { get set }
    var didGetProviderMasterSuccess: (() -> Void)? { get set }
    var didGetStatusFilterSuccess: (() -> Void)? { get set }
    
    func getListAC() -> ([PlugTypeData], [Bool])
    func getListDC() -> ([PlugTypeData], [Bool])
    func getListProviderMaster() -> ([ProviderData], [Bool])
    func getListStatusFilter() -> ([Int], [String], [Bool])
}

protocol MapFilterProtocol: MapFilterProtocolInput, MapFilterProtocolOutput {
    var input: MapFilterProtocolInput { get }
    var output: MapFilterProtocolOutput { get }
}

class MapFilterViewModel: MapFilterProtocol, MapFilterProtocolOutput {
    var input: MapFilterProtocolInput { return self }
    var output: MapFilterProtocolOutput { return self }
    
    // MARK: - UseCase
    private var getPlugTypeCategoryUseCase: GetPlugTypeCategoryUseCase
    private var getFindAllProviderMasterUseCase: GetFindAllProviderMasterUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: MapFilterViewController
    
    public var listACPlugTypeData: ([PlugTypeData],[Bool]) = ([], [])
    public var listDCPlugTypeData: ([PlugTypeData],[Bool]) = ([], [])
    
    public var listProviderMasterData: ([ProviderData],[Bool]) = ([], [])
    public var listStatusData: ([Int],[String],[Bool]) = ([], [], [])
    
    init(
        vc: MapFilterViewController,
        getPlugTypeCategoryUseCase: GetPlugTypeCategoryUseCase = GetPlugTypeCategoryUseCaseImpl(),
        getFindAllProviderMasterUseCase: GetFindAllProviderMasterUseCase = GetFindAllProviderMasterUseCaseImpl()
    ) {
        self.vc = vc
        self.getPlugTypeCategoryUseCase = getPlugTypeCategoryUseCase
        self.getFindAllProviderMasterUseCase = getFindAllProviderMasterUseCase
    }
    
    // MARK - Data-binding OutPut
    var didGetACPlugTypeSuccess: (() -> Void)?
    var didGetDCPlugTypeSuccess: (() -> Void)?
    var didGetProviderMasterSuccess: (() -> Void)?
    var didGetStatusFilterSuccess: (() -> Void)?
    
    func getPlugTypeMaster() {
        self.vc.startLoding()
        self.getPlugTypeCategoryUseCase.execute().sink { completion in
            debugPrint("getPlugTypeCategoryUseCase \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            
            let storeFilter = StoreManager.shared.getMapFilter()
            
            if let ac = resp?.AC {
                self.listACPlugTypeData.0 = ac
                self.listACPlugTypeData.1 = []
                ac.forEach({ item in
                    let filter = storeFilter?.plugId?.filter { $0 == item.pTypeId }
                    let status: Bool = (filter?.isEmpty ?? true) == true ? false : true
                    self.listACPlugTypeData.1.append(status)
                })
                self.didGetACPlugTypeSuccess?()
            }
            
            if let dc = resp?.DC {
                self.listDCPlugTypeData.0 = dc
                self.listDCPlugTypeData.1 = []
                dc.forEach({ item in
                    let filter = storeFilter?.plugId?.filter { $0 == item.pTypeId }
                    let status: Bool = (filter?.isEmpty ?? true) == true ? false : true
                    self.listDCPlugTypeData.1.append(status)
                })
                self.didGetDCPlugTypeSuccess?()
            }
            
        }.store(in: &self.anyCancellable)
    }
    
    func getProviderMaster() {
        self.vc.startLoding()
        self.getFindAllProviderMasterUseCase.execute().sink { completion in
            debugPrint("getFindAllProviderMasterUseCase \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if let data = resp {
                self.listProviderMasterData.0 = data
                self.listProviderMasterData.1 = []
                
                let storeFilter = StoreManager.shared.getMapFilter()
                data.forEach({ item in
                    let filter = storeFilter?.providerId?.filter { $0 == item.pvId }
                    let status: Bool = (filter?.isEmpty ?? true) == true ? false : true
                    self.listProviderMasterData.1.append(status)
                })
                self.didGetProviderMasterSuccess?()
            }
            
        }.store(in: &self.anyCancellable)
    }
    
    func getStatusFilter() {
        self.listStatusData.0 = [2, 3, 4]
        self.listStatusData.1 = ["เปิดเร็วๆนี้", "ปิดปรับปรุง", "แสดงสถานีที่ใช้ส่วนตัว"]
        self.listStatusData.2 = [true, true, true]
        
        let storeFilter = StoreManager.shared.getMapFilter()
        self.listStatusData.0.enumerated().forEach({ (index, id) in
            let filter = storeFilter?.statusIndex?.filter { $0 == id }
            let status: Bool = (filter?.isEmpty ?? true) == true ? false : true
            self.listStatusData.2[index] = status
        })
        
        self.didGetStatusFilterSuccess?()
    }
    
    func getListAC() -> ([PlugTypeData], [Bool]) {
        return self.listACPlugTypeData
    }
    
    func getListDC() -> ([PlugTypeData], [Bool]) {
        return self.listDCPlugTypeData
    }
    
    func getListProviderMaster() -> ([ProviderData], [Bool]) {
        return self.listProviderMasterData
    }
    
    func getListStatusFilter() -> ([Int], [String], [Bool]) {
        return self.listStatusData
    }
    
    func setSelectedACAll(selected: Bool) {
        self.listACPlugTypeData.1 = []
        self.listACPlugTypeData.0.enumerated().forEach({ (index, item) in
            self.listACPlugTypeData.1.append(selected)
            addRemovePlugTypeMaster(id: self.listACPlugTypeData.0[index].pTypeId, isSeleted: selected)
        })
    }
    
    func setSelectedDCAll(selected: Bool) {
        self.listDCPlugTypeData.1 = []
        self.listDCPlugTypeData.0.enumerated().forEach({ (index, item) in
            self.listDCPlugTypeData.1.append(selected)
            addRemovePlugTypeMaster(id: self.listDCPlugTypeData.0[index].pTypeId, isSeleted: selected)
        })
    }
    
    func setSelectedACIndex(index: Int, selected: Bool) {
        self.listACPlugTypeData.1[index] = selected
        addRemovePlugTypeMaster(id: self.listACPlugTypeData.0[index].pTypeId, isSeleted: selected)
    }
    
    func setSelectedDCIndex(index: Int, selected: Bool) {
        self.listDCPlugTypeData.1[index] = selected
        addRemovePlugTypeMaster(id: self.listDCPlugTypeData.0[index].pTypeId, isSeleted: selected)
    }
    
    func setSelectedProviderMasterAll(selected: Bool) {
        self.listProviderMasterData.1 = []
        self.listProviderMasterData.0.enumerated().forEach({ (index, item) in
            self.listProviderMasterData.1.append(selected)
            addRemoveProviderMaster(id: self.listProviderMasterData.0[index].pvId, isSeleted: selected)
        })
    }
    
    func setSelectedProviderMasterIndex(index: Int, selected: Bool) {
        self.listProviderMasterData.1[index] = selected
        addRemoveProviderMaster(id: self.listProviderMasterData.0[index].pvId, isSeleted: selected)
    }

    func setSelectedStatusFilterIndex(index: Int, selected: Bool) {
        self.listStatusData.2[index] = selected
        addRemoveStatusFilter(id: self.listStatusData.0[index], isSeleted: selected)
    }
}

extension MapFilterViewModel {
    func addRemovePlugTypeMaster(id: Int?, isSeleted: Bool) {
        if let item = StoreManager.shared.getMapFilter() {
            var request = MapFilterModel()
            request = item
            
            if isSeleted == true {
                var newId = item.plugId?.filter { $0 != id }
                newId?.append(id)
                request.plugId = newId
            } else {
                let newId = item.plugId?.filter { $0 != id }
                request.plugId = newId
            }
            StoreManager.shared.clearMapFilter(completion: {
                StoreManager.shared.addMapFilter(request, completion: {})
            })
        }
    }
    
    func addRemoveProviderMaster(id: Int?, isSeleted: Bool) {
        if let item = StoreManager.shared.getMapFilter() {
            var request = MapFilterModel()
            request = item
            
            if isSeleted == true {
                var newId = item.providerId?.filter { $0 != id }
                newId?.append(id)
                request.providerId = newId
            } else {
                let newId = item.providerId?.filter { $0 != id }
                request.providerId = newId
            }
            StoreManager.shared.clearMapFilter(completion: {
                StoreManager.shared.addMapFilter(request, completion: {})
            })
        }
    }
    
    func addRemoveStatusFilter(id: Int?, isSeleted: Bool) {
        if let item = StoreManager.shared.getMapFilter() {
            var request = MapFilterModel()
            request = item
            
            if isSeleted == true {
                var newId = item.statusIndex?.filter { $0 != id }
                newId?.append(id)
                request.statusIndex = newId
            } else {
                let newId = item.statusIndex?.filter { $0 != id }
                request.statusIndex = newId
            }
            StoreManager.shared.clearMapFilter(completion: {
                StoreManager.shared.addMapFilter(request, completion: {})
            })
        }
    }
}

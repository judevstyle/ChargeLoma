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
    func getMapFilter()
    func setSelectedACAll(selected: Bool)
    func setSelectedDCAll(selected: Bool)
    func setSelectedACIndex(index: Int, selected: Bool)
    func setSelectedDCIndex(index: Int, selected: Bool)
}

protocol MapFilterProtocolOutput: class {
    var didGetACPlugTypeSuccess: (() -> Void)? { get set }
    var didGetDCPlugTypeSuccess: (() -> Void)? { get set }
    
    func getListAC() -> ([PlugTypeData], [Bool])
    func getListDC() -> ([PlugTypeData], [Bool])
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
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: MapFilterViewController
    
    public var listACPlugTypeData: ([PlugTypeData],[Bool]) = ([], [])
    public var listDCPlugTypeData: ([PlugTypeData],[Bool]) = ([], [])
    
    init(
        vc: MapFilterViewController,
        getPlugTypeCategoryUseCase: GetPlugTypeCategoryUseCase = GetPlugTypeCategoryUseCaseImpl()
    ) {
        self.vc = vc
        self.getPlugTypeCategoryUseCase = getPlugTypeCategoryUseCase
    }
    
    // MARK - Data-binding OutPut
    var didGetACPlugTypeSuccess: (() -> Void)?
    var didGetDCPlugTypeSuccess: (() -> Void)?
    
    func getMapFilter() {
        self.vc.startLoding()
        self.getPlugTypeCategoryUseCase.execute().sink { completion in
            debugPrint("getPlugTypeCategoryUseCase \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if let ac = resp?.AC {
                self.listACPlugTypeData.0 = ac
                self.listACPlugTypeData.1 = []
                ac.forEach({ item in
                    self.listACPlugTypeData.1.append(true)
                })
                self.didGetACPlugTypeSuccess?()
            }
            
            if let dc = resp?.DC {
                self.listDCPlugTypeData.0 = dc
                self.listDCPlugTypeData.1 = []
                dc.forEach({ item in
                    self.listDCPlugTypeData.1.append(true)
                })
                self.didGetDCPlugTypeSuccess?()
            }
            
        }.store(in: &self.anyCancellable)
    }
    
    func getListAC() -> ([PlugTypeData], [Bool]) {
        return self.listACPlugTypeData
    }
    
    func getListDC() -> ([PlugTypeData], [Bool]) {
        return self.listDCPlugTypeData
    }
    
    func setSelectedACAll(selected: Bool) {
        self.listACPlugTypeData.1 = []
        self.listACPlugTypeData.0.forEach({ item in
            self.listACPlugTypeData.1.append(selected)
        })
    }
    
    func setSelectedDCAll(selected: Bool) {
        self.listDCPlugTypeData.1 = []
        self.listDCPlugTypeData.0.forEach({ item in
            self.listDCPlugTypeData.1.append(selected)
        })
    }
    
    func setSelectedACIndex(index: Int, selected: Bool) {
        self.listACPlugTypeData.1[index] = selected
    }
    
    func setSelectedDCIndex(index: Int, selected: Bool) {
        self.listDCPlugTypeData.1[index] = selected
    }
}

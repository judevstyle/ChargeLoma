//
//  GetPlugTypeCategoryUseCase.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 9/1/2565 BE.
//

import Foundation
import Combine

protocol GetPlugTypeCategoryUseCase {
    func execute() -> AnyPublisher<PlugTypeCategoryData?, Error>
}

struct GetPlugTypeCategoryUseCaseImpl: GetPlugTypeCategoryUseCase {
    
    private let repository: PlugTypeMasterRepository
    
    init(repository: PlugTypeMasterRepository = PlugTypeMasterRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<PlugTypeCategoryData?, Error> {
        return self.repository
            .plugTypeCategory()
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}

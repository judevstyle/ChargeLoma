//
//  GetFindAllPlugTypeMasterUseCase.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 30/12/2564 BE.
//

import Foundation
import Combine

protocol GetFindAllPlugTypeMasterUseCase {
    func execute() -> AnyPublisher<[PlugTypeData]?, Error>
}

struct GetFindAllPlugTypeMasterUseCaseImpl: GetFindAllPlugTypeMasterUseCase {
    
    private let repository: PlugTypeMasterRepository
    
    init(repository: PlugTypeMasterRepository = PlugTypeMasterRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[PlugTypeData]?, Error> {
        return self.repository
            .findAll()
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}

//
//  GetFindAllProviderMasterUseCase.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 30/12/2564 BE.
//

import Foundation
import Combine

protocol GetFindAllProviderMasterUseCase {
    func execute() -> AnyPublisher<[ProviderData]?, Error>
}

struct GetFindAllProviderMasterUseCaseImpl: GetFindAllProviderMasterUseCase {
    
    private let repository: ProviderMasterRepository
    
    init(repository: ProviderMasterRepository = ProviderMasterRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[ProviderData]?, Error> {
        return self.repository
            .findAll()
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}

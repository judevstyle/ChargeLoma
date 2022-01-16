//
//  GetInformationFindAllUseCase.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 15/1/2565 BE.
//

import Foundation
import Combine

protocol GetInformationFindAllUseCase {
    func execute(request: GetInformationFindAllRequest) -> AnyPublisher<[InformationItem]?, Error>
}

struct GetInformationFindAllUseCaseImpl: GetInformationFindAllUseCase {
    
    private let repository: InformationRepository
    
    init(repository: InformationRepository = InformationRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute(request: GetInformationFindAllRequest) -> AnyPublisher<[InformationItem]?, Error> {
        return self.repository
            .findAll(request: request)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}

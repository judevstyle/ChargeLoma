//
//  GetPlaceDirectionUseCase.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 14/1/2565 BE.
//

import Foundation
import Combine

protocol GetPlaceDirectionUseCase {
    func execute(request: GetPlaceDirectionRequest) -> AnyPublisher<[RouteItem]?, Error>
}

struct GetPlaceDirectionUseCaseImpl: GetPlaceDirectionUseCase {
    
    private let repository: GoogleMapRepository
    
    init(repository: GoogleMapRepository = GoogleMapRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute(request: GetPlaceDirectionRequest) -> AnyPublisher<[RouteItem]?, Error> {
        return self.repository
            .placeDirection(request: request)
            .map { $0.routes }
            .eraseToAnyPublisher()
    }
}

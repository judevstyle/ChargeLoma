//
//  GetPlaceDetailUseCase.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 12/1/2565 BE.
//

import Foundation
import Combine

protocol GetPlaceDetailUseCase {
    func execute(request: GetPlaceDetailRequest) -> AnyPublisher<PlaceItem?, Error>
}

struct GetPlaceDetailUseCaseImpl: GetPlaceDetailUseCase {
    
    private let repository: GoogleMapRepository
    
    init(repository: GoogleMapRepository = GoogleMapRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute(request: GetPlaceDetailRequest) -> AnyPublisher<PlaceItem?, Error> {
        return self.repository
            .placeDetail(request: request)
            .map { $0.result }
            .eraseToAnyPublisher()
    }
}

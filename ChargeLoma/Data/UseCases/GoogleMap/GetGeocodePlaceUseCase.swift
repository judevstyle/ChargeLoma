//
//  GetGeocodePlaceUseCase.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 13/2/2565 BE.
//

import Foundation
import Combine

protocol GetGeocodePlaceUseCase {
    func execute(request: GetGeocodePlaceRequest) -> AnyPublisher<GetGeocodePlaceResponse?, Error>
}

struct GetGeocodePlaceUseCaseImpl: GetGeocodePlaceUseCase {
    
    private let repository: GoogleMapRepository
    
    init(repository: GoogleMapRepository = GoogleMapRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute(request: GetGeocodePlaceRequest) -> AnyPublisher<GetGeocodePlaceResponse?, Error> {
        return self.repository
            .placeGeoCode(request: request)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}

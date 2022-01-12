//
//  GetPlaceAutoCompleteUseCase.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 12/1/2565 BE.
//

import Foundation
import Combine

protocol GetPlaceAutoCompleteUseCase {
    func execute(request: GetPlaceAutoCompleteRequest) -> AnyPublisher<[PlaceItem]?, Error>
}

struct GetPlaceAutoCompleteUseCaseImpl: GetPlaceAutoCompleteUseCase {
    
    private let repository: GoogleMapRepository
    
    init(repository: GoogleMapRepository = GoogleMapRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute(request: GetPlaceAutoCompleteRequest) -> AnyPublisher<[PlaceItem]?, Error> {
        return self.repository
            .placeAutoComplete(request: request)
            .map { $0.predictions }
            .eraseToAnyPublisher()
    }
}

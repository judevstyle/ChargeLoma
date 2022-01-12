//
//  GoogleMapRepository.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 12/1/2565 BE.
//

import Foundation
import Combine
import Moya

protocol GoogleMapRepository {
    func placeAutoComplete(request: GetPlaceAutoCompleteRequest) -> AnyPublisher<GetPlaceAutoCompleteResponse, Error>
    func placeDetail(request: GetPlaceDetailRequest) -> AnyPublisher<GetPlaceDetailResponse, Error>
}

final class GoogleMapRepositoryImpl: ChargeLoma.GoogleMapRepository {
    private let provider: MoyaProvider<GoogleMapAPI> = MoyaProvider<GoogleMapAPI>()
    
    func placeAutoComplete(request: GetPlaceAutoCompleteRequest) -> AnyPublisher<GetPlaceAutoCompleteResponse, Error> {
        return self.provider
            .cb
            .request(.getPlaceAutoComplete(request: request))
            .map(GetPlaceAutoCompleteResponse.self)
    }
    
    func placeDetail(request: GetPlaceDetailRequest) -> AnyPublisher<GetPlaceDetailResponse, Error> {
        return self.provider
            .cb
            .request(.getPlaceDetail(request: request))
            .map(GetPlaceDetailResponse.self)
    }
}

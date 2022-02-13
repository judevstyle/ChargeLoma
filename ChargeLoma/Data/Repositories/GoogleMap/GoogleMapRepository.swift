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
    func placeDirection(request: GetPlaceDirectionRequest) -> AnyPublisher<GetPlaceDirectionResponse, Error>
    func placeGeoCode(request: GetGeocodePlaceRequest) -> AnyPublisher<GetGeocodePlaceResponse, Error>
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
    
    func placeDirection(request: GetPlaceDirectionRequest) -> AnyPublisher<GetPlaceDirectionResponse, Error> {
        return self.provider
            .cb
            .request(.getPlaceDirection(request: request))
            .map(GetPlaceDirectionResponse.self)
    }
    
    func placeGeoCode(request: GetGeocodePlaceRequest) -> AnyPublisher<GetGeocodePlaceResponse, Error> {
        return self.provider
            .cb
            .request(.getGeocodePlace(request: request))
            .map(GetGeocodePlaceResponse.self)
    }
}

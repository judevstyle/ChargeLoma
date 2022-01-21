//
//  StationRepository.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 4/1/2565 BE.
//

import Foundation
import Combine
import Moya

protocol StationRepository {
    func postStationFilter(request: PostStationFilterRequest) -> AnyPublisher<PostStationFilterResponse, Error>
    func getFindOne(request: GetStationFindOneRequest) -> AnyPublisher<GetStationFindOneResponse, Error>
    func getImageStation(request: GetImageStationRequest) -> AnyPublisher<GetImageStationResponse, Error>
}

final class StationRepositoryImpl: ChargeLoma.StationRepository {
    private let provider: MoyaProvider<StationAPI> = MoyaProvider<StationAPI>()

    func postStationFilter(request: PostStationFilterRequest) -> AnyPublisher<PostStationFilterResponse, Error> {
        return self.provider
            .cb
            .request(.stationFilter(request: request))
            .map(PostStationFilterResponse.self)
    }
    
    func getFindOne(request: GetStationFindOneRequest) -> AnyPublisher<GetStationFindOneResponse, Error> {
        return self.provider
            .cb
            .request(.findOne(request: request))
            .map(GetStationFindOneResponse.self)
    }
    
    func getImageStation(request: GetImageStationRequest) -> AnyPublisher<GetImageStationResponse, Error> {
        return self.provider
            .cb
            .request(.imageStation(request: request))
            .map(GetImageStationResponse.self)
    }
}

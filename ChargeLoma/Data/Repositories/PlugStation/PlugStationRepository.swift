//
//  PlugStationRepository.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 23/1/2565 BE.
//

import Foundation
import Combine
import Moya

protocol PlugStationRepository {
    func getPlugStation(request: GetPlugStationRequest) -> AnyPublisher<GetPlugStationResponse, Error>
}

final class PlugStationRepositoryImpl: ChargeLoma.PlugStationRepository {
    private let provider: MoyaProvider<PlugStationAPI> = MoyaProvider<PlugStationAPI>()

    func getPlugStation(request: GetPlugStationRequest) -> AnyPublisher<GetPlugStationResponse, Error> {
        return self.provider
            .cb
            .request(.getPlugStation(request: request))
            .map(GetPlugStationResponse.self)
    }
    
}

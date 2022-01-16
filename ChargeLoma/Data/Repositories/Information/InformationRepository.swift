//
//  InformationRepository.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 15/1/2565 BE.
//

import Foundation
import Combine
import Moya

protocol InformationRepository {
    func findAll(request: GetInformationFindAllRequest) -> AnyPublisher<GetInformationFindAllResponse, Error>
}

final class InformationRepositoryImpl: ChargeLoma.InformationRepository {
    private let provider: MoyaProvider<InformationAPI> = MoyaProvider<InformationAPI>()
    
    func findAll(request: GetInformationFindAllRequest) -> AnyPublisher<GetInformationFindAllResponse, Error> {
        return self.provider
            .cb
            .request(.getFindAll(request: request))
            .map(GetInformationFindAllResponse.self)
    }
}

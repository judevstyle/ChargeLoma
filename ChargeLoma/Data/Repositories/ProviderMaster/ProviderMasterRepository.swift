//
//  ProviderMasterRepository.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 30/12/2564 BE.
//

import Foundation
import Combine
import Moya

protocol ProviderMasterRepository {
    func findAll() -> AnyPublisher<GetProviderMasterResponse, Error>
}

final class ProviderMasterRepositoryImpl: ChargeLoma.ProviderMasterRepository {
    private let provider: MoyaProvider<ProviderMasterAPI> = MoyaProvider<ProviderMasterAPI>()

    func findAll() -> AnyPublisher<GetProviderMasterResponse, Error> {
        return self.provider
            .cb
            .request(.findAll)
            .map(GetProviderMasterResponse.self)
    }
}

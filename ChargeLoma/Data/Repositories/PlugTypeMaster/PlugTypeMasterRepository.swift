//
//  PlugTypeMasterRepository.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 30/12/2564 BE.
//

import Foundation
import Combine
import Moya

protocol PlugTypeMasterRepository {
    func findAll() -> AnyPublisher<GetPlugTypeMasterResponse, Error>
    func plugTypeCategory() -> AnyPublisher<GetPlugTypeCategoryResponse, Error>
}

final class PlugTypeMasterRepositoryImpl: ChargeLoma.PlugTypeMasterRepository {
    private let provider: MoyaProvider<PlugTypeMasterAPI> = MoyaProvider<PlugTypeMasterAPI>()

    func findAll() -> AnyPublisher<GetPlugTypeMasterResponse, Error> {
        return self.provider
            .cb
            .request(.findAll)
            .map(GetPlugTypeMasterResponse.self)
    }
    
    func plugTypeCategory() -> AnyPublisher<GetPlugTypeCategoryResponse, Error> {
        return self.provider
            .cb
            .request(.plugTypeCategory)
            .map(GetPlugTypeCategoryResponse.self)
    }
}

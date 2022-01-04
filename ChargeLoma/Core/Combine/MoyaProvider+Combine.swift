//
//  MoyaProvider+Combine.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 30/12/2564 BE.
//

import Foundation
import Combine
import Moya

extension MoyaProvider: CombineCompatible { }

public extension Combine where Base: MoyaProviderType {
    func request(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Future<Response, Error> {
        return Future { [weak base] (promise) in
            _ = base?.request(token, callbackQueue: callbackQueue, progress: nil, completion: { (result) in
                switch result {
                case let .success(response):
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(error))
                }
            })
        }
    }
    
//    func requestWithUpdateAccessToken(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> AnyPublisher<Response, Error> {
//        return TrueAuthenticationManager.shared.selfVerifyObserver().mapError { (_) in
//            MoyaError.imageMapping(.init(statusCode: 300, data: Data()))
//        }.flatMap { (_) in
//            return self.request(token).eraseToAnyPublisher()
//        }.eraseToAnyPublisher()
//    }
}

public extension Publisher where Output == Response, Failure == Error {
    func map<D: Decodable>(_ type: D.Type, atKeyPath keyPath: String? = nil, using decoder: JSONDecoder = JSONDecoder(), failsOnEmptyData: Bool = true) -> AnyPublisher<D, Self.Failure> {
        return flatMap { (output) -> Future<D, Self.Failure> in
            return Future { (promise) in
                do {
                    promise(.success(try output.map(type, atKeyPath: keyPath, using: decoder, failsOnEmptyData: failsOnEmptyData)))
                } catch {
                    promise(.failure(MoyaError.jsonMapping(output)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func filter(statusCode: Int) -> AnyPublisher<Response, Error> {
        return flatMap { (output) -> Future<Response, Error> in
            return Future { (promise) in
                do {
                    promise(.success(try output.filter(statusCode: statusCode)))
                } catch {}
            }
        }.eraseToAnyPublisher()
    }
    
    func filter<R: RangeExpression>(statusCodes: R) -> AnyPublisher<Response, Error> where R.Bound == Int {
        return flatMap { (output) -> Future<Response, Error> in
            return Future { (promise) in
                do {
                    promise(.success(try output.filter(statusCodes: statusCodes)))
                } catch {}
            }
        }.eraseToAnyPublisher()
    }
}

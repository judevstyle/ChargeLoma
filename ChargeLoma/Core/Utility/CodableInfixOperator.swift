//
//  CodableInfixOperator.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 30/12/2564 BE.
//

import Foundation

infix operator <-

let delimiter = "."

// MARK: Decodable
//for non-optional T
public func <- <T: Decodable>(left: inout T, right: (Decoder, String)) throws  {
    let (decoder, key) = right
    let container = try decoder.container(keyedBy: AnyKey.self)
    if key.contains(delimiter) {
        left = try container.decodeDelimiter(T.self, fullKey: key)
    } else {
        left = try container.decode(T.self, forKey: AnyKey(stringValue: key))
    }
}

//for optional T
public func <- <T: Decodable>(left: inout T?, right: (Decoder, String)) throws  {
    let (decoder, key) = right
    let container = try decoder.container(keyedBy: AnyKey.self)
    if key.contains(delimiter) {
        left = try container.decodeDelimiterIfPresent(T.self, fullKey: key)
    } else {
        do {
            left = try container.decodeIfPresent(T.self, forKey: AnyKey(stringValue: key))
        } catch {
            left = nil
        }
    }
}
//
////for TransformType
//public func <- <Transform: TransformType>(left: inout Transform.Object?, right: ((Decoder, String), Transform)) throws {
//    let ((decoder, key), transform) = right
//    let container = try decoder.container(keyedBy: AnyKey.self)
//    if key.contains(delimiter) {
//        do {
//            if let primitive = try container.decodeDelimiterIfPresentAllPrimitive(transform, fullKey: key) {
//                left = primitive
//            } else if let collectionType = try container.decodeDelimiterIfPresentCollectionType(transform, fullKey: key) {
//                left = collectionType
//            }
//        } catch {
//            left = nil //if not found key just return nil
//        }
//
//    } else {
//        if let primitive = container.decodeAllPrimitive(transform: transform, forMappedKey: key) {
//            left = primitive
//        } else if let collectionType = container.decodeCollectionType(transform: transform, forMappedKey: key) {
//            left = collectionType
//        }
//    }
//}
//
////for CodableTransformType
//public func <- <Transform: CodableTransformType>(left: inout Transform.Object?, right: ((Decoder, String), Transform)) throws {
//    let ((decoder, key), transform) = right
//    let container = try decoder.container(keyedBy: AnyKey.self)
//    if key.contains(delimiter) {
//        do {
//            if let primitive = try container.decodeDelimiterIfPresentAllPrimitive(transform, fullKey: key) {
//                left = primitive
//            } else if let collectionType = try container.decodeDelimiterIfPresentCollectionType(transform, fullKey: key) {
//                left = collectionType
//            }
//        } catch {
//            left = nil //if not found key just return nil
//        }
//
//    } else {
//        if let primitive = container.decodeAllPrimitive(transform: transform, forMappedKey: key) {
//            left = primitive
//        } else if let collectionType = container.decodeCollectionType(transform: transform, forMappedKey: key) {
//            left = collectionType
//        }
//    }
//}


//
//// MARK: Encodable
////for non-optional T
//public func <- <T: Encodable>(left: T, right: (Encoder, String)) throws  {
//    let (encoder, key) = right
//    var container = encoder.container(keyedBy: AnyKey.self)
//    if key.contains(delimiter) {
//        try container.encodeDelimiter(left, fullKey: key)
//    } else {
//        try container.encode(left, forKey: AnyKey(stringValue: key))
//    }
//}
//
////for optional T
//public func <- <T: Encodable>(left: T?, right: (Encoder, String)) throws  {
//    let (encoder, key) = right
//    var container = encoder.container(keyedBy: AnyKey.self)
//    if key.contains(find: delimiter) {
//        try container.encodeDelimiter(left, fullKey: key)
//    } else {
//        try container.encodeIfPresent(left, forKey: AnyKey(stringValue: key))
//    }
//}

//
//  KeyedDecodingContainer+Extension.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 30/12/2564 BE.
//

import Foundation

extension KeyedDecodingContainer where K == AnyKey {
    
    private func getKeyMap(prefix: String) -> [String: [String]] {
        let keyMap = [
            "prefixEn": ["en", "eng", "\(prefix)_en", "\(prefix)_eng"],
            "prefixTh": ["th", "thai", "\(prefix)_th", "\(prefix)_thai"],
            "prefixId": ["id", "\(prefix)_id"],
            "prefixMm": ["mm", "\(prefix)_mm"]
        ]
        return keyMap
    }
    
    func decode<T>(_ type: T.Type, forMappedKey key: String, prefix: String) throws -> T where T : Decodable {
        let keyMap = getKeyMap(prefix: prefix)
        for object in keyMap[key] ?? [] {
            if let value = try? decode(T.self, forKey: AnyKey(stringValue: object)) {
                return value
            }
        }
        return try decode(T.self, forKey: AnyKey(stringValue: key))
    }
    
    func decodeIfPresent<T>(_ type: T.Type, forMappedKey key: String, prefix: String) throws -> T? where T : Decodable {
        let keyMap = getKeyMap(prefix: prefix)
        for object in keyMap[key] ?? [] {
            do {
                if let value = try decodeIfPresent(T.self, forKey: AnyKey(stringValue: object)) {
                    return value
                }
            } catch {
                return nil
            }
        }
        return nil
    }
    
    func decodeDelimiter<T>(_ type: T.Type, _ delimiter: String = ".", fullKey: String) throws -> T where T : Decodable {
        var stringList: ArraySlice<String> = ArraySlice(fullKey.components(separatedBy: delimiter))
        let lastValue: String? = stringList.last
        stringList = stringList.dropLast()
        var nestedContainer: KeyedDecodingContainer<K> = self
        while let firstKey: String = stringList.first {
            nestedContainer = try nestedContainer.nestedContainer(keyedBy: K.self, forKey: AnyKey(stringValue: firstKey))
            stringList = stringList.dropFirst()
        }
        return try nestedContainer.decode(T.self, forKey: AnyKey(stringValue: lastValue ?? ""))
    }
    
    func decodeDelimiterIfPresent<T>(_ type: T.Type, _ delimiter: String = ".", fullKey: String, forMappedKey key: String = "") throws -> T? where T : Decodable {
        var value: ArraySlice<String> = ArraySlice(fullKey.components(separatedBy: delimiter))
        let lastValue: String? = value.last
        value = value.dropLast()
        var nestedContainer: KeyedDecodingContainer<K> = self
        while let firstKey: String = value.first {
            nestedContainer = try nestedContainer.nestedContainer(keyedBy: K.self, forKey: AnyKey(stringValue: firstKey))
            value = value.dropFirst()
        }
        if key != "" {
            return try nestedContainer.decodeIfPresent(T.self, forMappedKey: key, prefix: lastValue ?? "")
        } else {
            do {
                return try nestedContainer.decodeIfPresent(T.self, forKey: AnyKey(stringValue: lastValue ?? ""))
            } catch {
                return nil
            }
        }
    }
}

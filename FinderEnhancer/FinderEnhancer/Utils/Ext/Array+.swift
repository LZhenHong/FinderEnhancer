//
//  Array+Raw.swift
//  FinderEnhancer
//
//  Created by Eden on 2023/10/27.
//

import Foundation

extension Array: RawRepresentable where Element: Codable {
    public typealias RawValue = String

    public var rawValue: RawValue {
        do {
            let encoder = JSONEncoder()
            encoder.nonConformingFloatEncodingStrategy = .convertToString(positiveInfinity: "inf",
                                                                          negativeInfinity: "-inf",
                                                                          nan: "NaN")
            let data = try encoder.encode(self)
            let val = String(data: data, encoding: .utf8)
            return val ?? "[]"
        } catch {
            print("Encode array error: \(error)")
            return "[]"
        }
    }

    public init?(rawValue: RawValue) {
        do {
            guard let data = rawValue.data(using: .utf8) else {
                return nil
            }

            let decoder = JSONDecoder()
            decoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: "inf",
                                                                            negativeInfinity: "-inf",
                                                                            nan: "NaN")
            let val = try decoder.decode([Element].self, from: data)
            self = val
        } catch {
            print("Decode array error: \(error)")
            return nil
        }
    }
}

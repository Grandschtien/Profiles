//
//  Decoder.swift
//  Profiles
//
//  Created by Егор Шкарин on 30.06.2022.
//

import Foundation

extension JSONDecoder {
    static func decodeData<T: Decodable>(_ model: T.Type, data: Data) -> T? {
        let decoder = JSONDecoder()
        do {
            let decoded = try decoder.decode(model, from: data)
            return decoded
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
}

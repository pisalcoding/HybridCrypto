//
//  File.swift
//  
//
//  Created by Pisal on 8/19/22.
//

import Foundation

public struct AESResult : Codable {
    let salt: String
    let iv: String
    let encodedData: String
    
    enum CodingKeys: String, CodingKey {
        case salt
        case iv
        case encodedData
    }
}


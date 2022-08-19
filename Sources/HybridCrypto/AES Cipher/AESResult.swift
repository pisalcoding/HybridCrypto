//
//  File.swift
//  
//
//  Created by Pisal on 8/19/22.
//

import Foundation

public struct AESResult : Codable {
    public let salt: String
    public let iv: String
    public let encodedData: String
    
    enum CodingKeys: String, CodingKey {
        case salt
        case iv
        case encodedData
    }
}


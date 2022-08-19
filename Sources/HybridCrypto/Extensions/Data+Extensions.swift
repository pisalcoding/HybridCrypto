//
//  Data+Extensions.swift
//  HybridEncryption
//
//  Created by Pisal on 8/19/22.
//

import Foundation
import CommonCrypto

public extension Data {
    func toBase64String() -> String {
        return self.base64EncodedString(options: .lineLength64Characters)
    }
    
    mutating func appendString(string: String) {
        append(string.data(using: .utf8)!)
    }

    public var bytes: Array<UInt8> {
      Array(self)
    }
}

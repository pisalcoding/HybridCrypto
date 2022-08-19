//
//  String+Extensions.swift
//  HybridEncryption
//
//  Created by Pisal on 8/19/22.
//

import Foundation


public extension String {
    public func toDictionary() -> [String:AnyObject]? {
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {}
        }
        return nil
    }
    
    public func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    public var md5: String {
        return HMAC.hash(input: self, algo: HMACAlgo.MD5)
    }
    
    public var sha1: String {
        return HMAC.hash(input: self, algo: HMACAlgo.SHA1)
    }
    
    public var sha224: String {
        return HMAC.hash(input: self, algo: HMACAlgo.SHA224)
    }
    
    public var sha256: String {
        return HMAC.hash(input: self, algo: HMACAlgo.SHA256)
    }
    
    public var sha384: String {
        return HMAC.hash(input: self, algo: HMACAlgo.SHA384)
    }
    
    public var sha512: String {
        return HMAC.hash(input: self, algo: HMACAlgo.SHA512)
    }
}

# HybridCrypto

HybridCrypto is simple implementation of hybrid cryptography following recommendations by  [OWASP](https://mobile-security.gitbook.io/mobile-security-testing-guide/general-mobile-app-testing-guide/0x04g-testing-cryptography).

## Usage

> Step 1: Add this package to our Swift project via Swift Package Manager (SPM)
```java
https://github.com/UTNGYPisal/SwiftHybridCrypto

```
> Step 2: Import package to classes you need to work with encryption
```swift
import HybridCrypto
```

> Step 3: Initialize HybridCrypto in your AppDelegate
```swift
let publicKeyPlain = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvTtZxoq7IKTwRkADtWix\n" +
"Ryv/CHKK+skNlMMV5G+om75HgHUo8AOzHnj9yUvhcm8Maz46ukxiZsvDPgExu9N1\n" +
"agEm9HHJEZg1VN+2dT+JojODuC3qkF7o94duchQX44gPjyIBEE/113E6fS51SGGm\n" +
"WYrCapSYjNRubB97O1WPm/2nK+A/m9KTtCuIZMp4i/qe4mXCLMRepFO2ORBLD5Ac\n" +
"RU+/tF15IruvaBhZezY+IX571yRao3ZLlVBJtZKU7SHp5udxQ0daRxtsVc9aloC3\n" +
"TRRL8RvFjHyg7V+uSHkg6cN4IIMrTnkwVkn+7BE9KrT7tY8yEkSE8W4WVCDChIRf\n" +
"FwIDAQAB"
HybridCrypto.initialize(with: Configuration.defaultCofig, publicKeyPlain: publicKeyPlain)
```
> Step 4 (Final): Use it wherever you want
```swift
do {
    let result = try HybridCrypto.shared.encrypt(message: "Hello")
    print(result.httpParams)
} catch  let err {
    print("Error: \(err)")
}
```

## Result
Once encryption is successful, you'll get a Http-friendly result object
```swift
public struct HttpFriendlyResult : Codable {
    let requestPassword: String
    let iv: String
    let salt: String
    let responsePassword: String
    let encryptedData: String
    let signature: String
}
```

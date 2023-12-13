//
//  KeyChain.swift
//  KeyChain
//
//  Created by Teddy on 12/13/23.
//

import SwiftUI

@propertyWrapper
public class KeyChain<T: RawRepresentable<String>, U: Codable> {
    private let classKey = kSecClassGenericPassword
    private let key: T

    init(wrappedValue: U? = nil, key: T) {
        self.key = key
        if let wrappedValue {
            save(value: wrappedValue)
        }
        self.wrappedValue = read()
    }

    public var wrappedValue: U? {
        get {
            read()
        }
        set {
            guard let newValue else {
                delete()
                return
            }

            let value = read()

            value != nil ? update(value: newValue) : save(value: newValue)
        }
    }

    private func save(value: U) {
        let data = try? JSONEncoder().encode(value)

        let query: NSDictionary = [
            kSecClass as String: classKey,
            kSecAttrAccount as String: key.rawValue, // 저장할 Account
            kSecValueData: data as Any, // 저장할 값
        ]

        SecItemDelete(query) // Keychain은 Key값에 중복이 생기면, 저장할 수 없기 때문에 먼저 Delete해줌

        SecItemAdd(query, nil)
    }

    private func read() -> U? {
        let query: NSDictionary = [
            kSecClass as String: classKey,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData: kCFBooleanTrue as Any, // CFData 타입으로 불러오라는 의미
            kSecMatchLimit: kSecMatchLimitOne, // 중복되는 경우, 하나의 값만 불러오라는 의미
        ]

        var dataTypeRef: AnyObject?
        SecItemCopyMatching(query, &dataTypeRef)

        guard let retrievedData: Data = dataTypeRef as? Data,
              let value = try? JSONDecoder().decode(U.self, from: retrievedData) else {
            return nil
        }

        return value
    }

    private func update(value: U) {
        let data = try? JSONEncoder().encode(value)

        let query = [kSecClass as String: classKey,
                     kSecAttrAccount as String: key.rawValue] as CFDictionary

        let attributes = [kSecValueData as String: data as Any] as CFDictionary

        SecItemUpdate(query, attributes)
    }

    private func delete() {
        let query: NSDictionary = [
            kSecClass as String: classKey,
            kSecAttrAccount as String: key.rawValue,
        ]
        SecItemDelete(query)
    }
}

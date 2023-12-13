//
//  KeyChainTests.swift
//  KeyChainTests
//
//  Created by Teddy on 12/13/23.
//

import XCTest
@testable import KeyChain

class KeyChainTests: XCTestCase {
    enum TestKey: String {
        case testKey1
        case testKey2
        case nonExistentKey
        case stringKey
        case intKey
        case doubleKey
    }

    struct TestModel: Codable, Equatable {
        let name: String
        let age: Int
    }

    override func tearDown() {
        super.tearDown()
        KeyChainManager.deleteAll()
    }

    // KeyChain에 값을 저장하고 읽어오는 테스트
    func testKeyChainSaveAndRead() {
        // 테스트용 KeyChain 인스턴스
        @KeyChain(key: TestKey.testKey1)
        var keyChainInstance1: TestModel?

        @KeyChain(key: TestKey.testKey2)
        var keyChainInstance2: TestModel? = nil
        
        // 값을 저장
        let newValue1 = TestModel(name: "Bob", age: 28)
        keyChainInstance1 = newValue1

        // 저장된 값 읽기
        let readValue1 = keyChainInstance1
        XCTAssertEqual(readValue1, newValue1)

        // 다른 Key에 값 저장
        let newValue2 = TestModel(name: "Eve", age: 35)
        keyChainInstance2 = newValue2

        // 다른 Key의 저장된 값 읽기
        let readValue2 = keyChainInstance2
        XCTAssertEqual(readValue2, newValue2)
    }

    // KeyChain에 값을 저장하고 읽어오는 테스트
    func testKeyChainSaveAndRead2() {
        @KeyChain(key: TestKey.testKey1)
        var keyChainInstance1: TestModel?

        // 값을 저장
        let newValue1 = TestModel(name: "Bob", age: 28)
        keyChainInstance1 = newValue1

        // 테스트용 KeyChain 인스턴스
        @KeyChain(key: TestKey.testKey1)
        var keyChainInstance3: TestModel?

        // 다른 Key의 저장된 값 읽기
        XCTAssertEqual(keyChainInstance3, newValue1)
    }

    // KeyChain에서 값 삭제하는 테스트
    func testKeyChainDelete() {
        @KeyChain(key: TestKey.testKey1)
        var keyChainInstance1: TestModel?

        // 값을 저장
        keyChainInstance1 = TestModel(name: "Charlie", age: 32)

        // 값을 삭제
        keyChainInstance1 = nil

        // 삭제된 값이 nil인지 확인
        XCTAssertNil(keyChainInstance1)
    }

    // KeyChain에서 모든 값 삭제하는 테스트
    func testKeyChainDelete2() {
        @KeyChain(key: TestKey.testKey1)
        var keyChainInstance1: TestModel?

        @KeyChain(key: TestKey.testKey2)
        var keyChainInstance2: TestModel? = nil

        // 여러 값 저장
        keyChainInstance1 = TestModel(name: "David", age: 27)
        keyChainInstance2 = TestModel(name: "Grace", age: 40)

        keyChainInstance1 = nil
        keyChainInstance2 = nil

        // 삭제된 값이 nil인지 확인
        XCTAssertNil(keyChainInstance1)
        XCTAssertNil(keyChainInstance2)
        XCTAssertEqual(KeyChainManager.countOfKeyChainItems(), 0)
    }

    // KeyChain에서 모든 값 삭제하는 테스트
    func testKeyChainDeleteAll() {
        @KeyChain(key: TestKey.testKey1)
        var keyChainInstance1: TestModel?

        @KeyChain(key: TestKey.testKey2)
        var keyChainInstance2: TestModel? = nil

        // 여러 값 저장
        keyChainInstance1 = TestModel(name: "David", age: 27)
        keyChainInstance2 = TestModel(name: "Grace", age: 40)

        KeyChainManager.deleteAll()

        // 삭제된 값이 nil인지 확인
        XCTAssertNil(keyChainInstance1)
        XCTAssertNil(keyChainInstance2)
    }

    // KeyChain에 String 값을 저장하고 읽어오는 테스트
    func testStringKeyChainSaveAndRead() {
        // 테스트용 KeyChain 인스턴스
        @KeyChain(key: TestKey.stringKey)
        var stringKeyChain: String? = "123"

        // 값을 저장
        let newValue = "NewStringValue"
        stringKeyChain = newValue

        // 저장된 값 읽기
        let readValue = stringKeyChain
        XCTAssertEqual(readValue, newValue)
    }

    // KeyChain에 Int 값을 저장하고 읽어오는 테스트
    func testIntKeyChainSaveAndRead() {
        @KeyChain(key: TestKey.intKey)
        var intKeyChain: Int?

        // 값을 저장
        let newValue = 100
        intKeyChain = newValue

        // 저장된 값 읽기
        let readValue = intKeyChain
        XCTAssertEqual(readValue, newValue)
    }

    // KeyChain에 Double 값을 저장하고 읽어오는 테스트
    func testDoubleKeyChainSaveAndRead() {
        @KeyChain(key: TestKey.doubleKey)
        var doubleKeyChain: Double? = 3.14

        // 값을 저장
        let newValue = 5.67
        doubleKeyChain = newValue

        // 저장된 값 읽기
        let readValue = doubleKeyChain
        XCTAssertEqual(readValue, newValue)
    }

    // KeyChain에 각 타입의 값 삭제하는 테스트
    func testKeyChainDelete3() {
        // 테스트용 KeyChain 인스턴스
        @KeyChain(key: TestKey.stringKey)
        var stringKeyChain: String? = "123"

        @KeyChain(key: TestKey.intKey)
        var intKeyChain: Int? = 111

        @KeyChain(key: TestKey.doubleKey)
        var doubleKeyChain: Double? = 3.14

        // String 값 저장
        stringKeyChain = "DeleteMeString"
        // Int 값 저장
        intKeyChain = 123
        // Double 값 저장
        doubleKeyChain = 7.89

        XCTAssertEqual(stringKeyChain, "DeleteMeString")
        XCTAssertEqual(intKeyChain, 123)
        XCTAssertEqual(doubleKeyChain, 7.89)

        @KeyChain(key: TestKey.stringKey)
        var stringKeyChain2: String? = "123"
        
        // 각 값 삭제
        stringKeyChain = nil
        intKeyChain = nil
        doubleKeyChain = nil

        // 삭제된 값이 nil인지 확인
        XCTAssertNil(stringKeyChain)
        XCTAssertNil(stringKeyChain2)
        XCTAssertNil(intKeyChain)
        XCTAssertNil(doubleKeyChain)
    }
}

struct KeyChainManager {
    // - MARK: Test를 위한 함수
    static func countOfKeyChainItems() -> Int {
        let query: NSDictionary = [
            kSecClass as String: kSecClassGenericPassword,
            kSecMatchLimit: kSecMatchLimitAll,
            kSecReturnAttributes: kCFBooleanTrue as Any,
            kSecReturnData: kCFBooleanTrue as Any,
        ]

        var result: AnyObject?
        let status = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query, UnsafeMutablePointer($0))
        }

        guard status != errSecItemNotFound else {
            return 0
        }

        guard status == errSecSuccess else {
            return 0
        }

        var count = 0

        if let array = result as? [[String: AnyObject]] {
            count = array.count
        }

        return count
    }

    static func deleteAll() {
        let query: NSDictionary = [
            kSecClass as String: kSecClassGenericPassword,
        ]
        SecItemDelete(query)
    }
}

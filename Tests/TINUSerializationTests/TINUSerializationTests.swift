
#if !os(watchOS) || swift(>=5.4)

import XCTest
@testable import TINUSerialization

#if !(os(watchOS) || os(Linux) || os(Windows))
import TINURecovery
#endif

final class TINUSerializationTests: XCTestCase {
    func testBase() throws {
        ///Tesing struct, to be able to use this library it must conform to `Codable` and `FastCodable` or `GenericCodable` and `FastCdable`.
        struct Foo: Equatable, Codable, FastCodable{
            let bar_string: String
            let bar_integer: Int
        }

        //Testing initialization of the struct
        let test = Foo.init(bar_string: "Test", bar_integer: 30)

        //testing serialization to json
        let json = test.json(usingFormatting: .prettyPrinted)
        XCTAssertNotNil(json, "JSON serialization is nil")

        print("Obtained json string: \n" + (json ?? "") + "\n\n")
        
        //testing serialization to plist
        let plist = test.plist()
        XCTAssertNotNil(plist, "Plist serialization is nil")
        
        print("Obtained plsit string: \n" + (test.plist() ?? "") + "\n\n")

        let fromJSON = Foo.init(fromJSONSerializedString: json ?? "")
        XCTAssertNotNil(fromJSON, "De-serialization from json failure")
        XCTAssertEqual(fromJSON, test, "starter instance is not equal to the json-obtained instance")

        let fromPlist = Foo.init(fromPlistSerialisedString: plist ?? "")
        XCTAssertNotNil(fromPlist, "De-serialization from plist failure")
        XCTAssertEqual(fromPlist, test, "starter instance is not equal to the plist-obtained instance")
        
        let fromPlistu = Foo.init(fromSerializedString: plist ?? "")
        XCTAssertNotNil(fromPlistu, "De-serialization from plist universal method failure")
        XCTAssertEqual(fromPlistu, test, "starter instance is not equal to the plist-universal-obtained instance")
        
        let fromJSONu = Foo.init(fromSerializedString: json ?? "")
        XCTAssertNotNil(fromJSONu, "De-serialization from json universal method failure")
        XCTAssertEqual(fromJSONu, test, "starter instance is not equal to the json-universal-obtained instance")
        
        #if !(os(watchOS) || os(Linux) || os(Windows))
        if TINURecovery.SimpleReachability.status{
            XCTAssertEqual(Foo.init(fromRemoteFileAtUrl: "https://raw.githubusercontent.com/ITzTravelInTime/TINUSerialization/main/Test.json"), test, "Remote json instance desn't match the reference one.")
            
            XCTAssertEqual(Foo.init(fromRemoteFileAtUrl: "https://raw.githubusercontent.com/ITzTravelInTime/TINUSerialization/main/Test.plist" ), test, "Remote plist instance desn't match the reference one.")
        }
        #endif
    }
}

#endif

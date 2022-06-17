import Foundation
import TINUSerialization
import TINURecovery

TINURecovery.Printer.enabled = false

///Tesing struct, to be able to use this library it must conform to `Codable` and `FastCodable` or `GenericCodable` and `FastCdable`.
struct Foo: Codable, FastCodable{
    let bar_string: String
    let bar_integer: Int
}

//extension Dictionary: GenericCodable {  }

//Testing initialization of the struct
let test = Foo.init(bar_string: "Test", bar_integer: 30)

//testing serialization to json
print("Obtained json string: \n" + (test.json(usingFormatting: .prettyPrinted) ?? "") + "\n\n")

//testing serialization to plist
print("Obtained plsit string: \n" + (test.plist() ?? "") + "\n\n")

//creating new instance from a json deserialization
print("Testing json de-serialization: \(Foo.init(fromJSONSerializedString: test.json(usingFormatting: nil) ?? "")!) \n\n")

//creating new instance from a plist deserialization
print("Testing plist de-serialization: \(Foo.init(fromPlistSerialisedString: test.plist() ?? "")!) \n\n")

//creating new instance from a remote json file
print("Testing remote json de-serialization: \( Foo.init(fromRemoteFileAtUrl: "https://raw.githubusercontent.com/ITzTravelInTime/TINUSerialization/main/Test.json" )! ) \n\n")

//creating new instance from a remote plist file
print("Testing remote plist de-serialization: \( Foo.init(fromRemoteFileAtUrl: "https://raw.githubusercontent.com/ITzTravelInTime/TINUSerialization/main/Test.plist" )! ) \n\n")

//print("Testing dictionary plist decoding: \([String: Any].init(fromRemoteFileAtUrl: "https://raw.githubusercontent.com/ITzTravelInTime/TINUSerialization/main/Test.plist")!)")

//print("Testing dictionary json decoding: \([String: Any].init(fromRemoteFileAtUrl: "https://raw.githubusercontent.com/ITzTravelInTime/TINUSerialization/main/Test.json")!)")

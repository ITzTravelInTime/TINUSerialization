import Foundation
import TINUSerialization

///Tesing struct, since this package is an extension for `Equatable` and `Decodable` types this struct has been made `Codable` so it's both.
struct Foo: Codable{
    let bar_string: String
    let bar_integer: Int
}

//Testing initialization of the struct
let test = Foo.init(bar_string: "Test", bar_integer: 30)

//testing de-serialization to json
print("Obtained json string: \n" + (test.json(usingFormatting: .prettyPrinted) ?? "") + "\n\n")

//testing de-serialization to plist
print("Obtained plsit string: \n" + (test.plist() ?? "") + "\n\n")

//creating new instance from a json deserialization
print("Testing json de-serialization: \(Foo.init(fromJSONSerialisedString: test.json(usingFormatting: nil) ?? "")!) \n\n")

//creating new instance from a plist deserialization
print("Testing plist de-serialization: \(Foo.init(fromPlistSerialisedString: test.plist() ?? "")!) \n\n")

//creating new instance from a remote json file
print("Testing remote json de-serialization: \( Foo.init(fromRemoteFileAtUrl: "https://raw.githubusercontent.com/ITzTravelInTime/TINUSerialization/main/Test.json" )! ) \n\n")

//creating new instance from a remote plist file
print("Testing remote plist de-serialization: \( Foo.init(fromRemoteFileAtUrl: "https://raw.githubusercontent.com/ITzTravelInTime/TINUSerialization/main/Test.plist" )! ) \n\n")




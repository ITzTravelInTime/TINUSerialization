import Foundation
import TINUSerialization

struct Foo: Codable{
    let bar_string: String
    let bar_integer: Int
}

let test = Foo.init(bar_string: "Test", bar_integer: 30)

print("Obtained json string: \n" + (test.json(prettyPrinted: true) ?? "") + "\n\n")

print("Obtained plsit string: \n" + (test.plist() ?? "") + "\n\n")

print("Testing json de-serialization: \(Foo.init(fromJSONSerialisedString: test.json() ?? "")!) \n\n")

print("Testing plist de-serialization: \(Foo.init(fromPlistSerialisedString: test.plist() ?? "")!) \n\n")

print("Testing remote json de-serialization: \( Foo.init(fromRemoteFileAtUrl: "https://raw.githubusercontent.com/ITzTravelInTime/TINUSerialization/main/Test.json" )! ) \n\n")

print("Testing remote plist de-serialization: \( Foo.init(fromRemoteFileAtUrl: "https://raw.githubusercontent.com/ITzTravelInTime/TINUSerialization/main/Test.plist" )! ) \n\n")




# TINUSerialization

Library with useful extensions to `Decodable` and `Encodable` (and so also `Codable`) types, including simple JSON/Plist serialization and deserialization.

## Features and usage

The main feature of this library are the extensions for `Decodable` and `Encodable` (and so also `Codable`) types.

Here are some examples of intended usages:

```swift
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
```

## Who should use this Library?

This library should be used by Swift apps/programs that needs to perform simple operations with JSON/Plist serializaed objects, either locally or remotely.

This code is tested on macOS, iPadOS, iOS and macCatalyst only.

## About the project

This code was created as part of my TINU project (https://github.com/ITzTravelInTime/TINU) and has been separated and made into it's own library to make the main project's source less complex and more focused on it's aim. 

Also having it as it's own library allows for code to be updated separately and so various versions of the main TINU app will be able to be compiled all with the latest version of this library.

## Libraries used

 - [ITzTravelInTime/TINURecovery](https://github.com/ITzTravelInTime/TINURecovery)
 - [ITzTravelInTime/SwiftLoggedPrint](https://github.com/ITzTravelInTime/SwiftLoggedPrint)

## Credits

 - [ITzTravelInTime (Pietro Caruso)](https://github.com/ITzTravelInTime) - Project creator and main developer.

## Contacts

 - ITzTravelInTime (Pietro Caruso): piecaruso97@gmail.com

## Legal info

TINUSerialization: A library for the usage of serialization formats in Swift.
Copyright (C) 2021-2022 Pietro Caruso

This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA





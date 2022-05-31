/*
 TINUSerialization: A library for the usage of serialization formats in Swift.
 Copyright (C) 2021-2022 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import Foundation
import SwiftLoggedPrint

///class used for the print functions
public class Printer: LoggedPrinter{
    
    public override class var prefix: String{
        return "[TINUSerialization]"
    }
    
    public override class var printerID: String{
        return "TINUSerializationPrinter"
    }
    
}

@inline(__always) internal func log(_ line: Any){
    TINUSerialization.Printer.print("\(line)")
}

@inline(__always) internal func debug(_ line: Any){
    TINUSerialization.Printer.debug("\(line)")
}

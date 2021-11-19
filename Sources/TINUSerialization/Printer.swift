//
//  File.swift
//  
//
//  Created by Pietro Caruso on 19/11/21.
//

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

internal func log(_ line: Any){
    Printer.print("\(line)")
}

internal func debug(_ line: Any){
    Printer.debug("\(line)")
}

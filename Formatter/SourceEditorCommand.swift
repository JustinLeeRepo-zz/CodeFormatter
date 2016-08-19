//
//  SourceEditorCommand.swift
//  Formatter
//
//  Created by Justin Lee on 8/19/16.
//  Copyright © 2016 AppLovin. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand
{
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: (NSError?) -> Void ) -> Void
    {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        
        var updatedLineIndexes = []
        
        for lineIndex in 0 ..< invocation.buffer.lines.count
        {
            let line = invocation.buffer.lines[lineIndex] as! NSString
            do
            {
                let regex = try RegularExpression(pattern: "\\{.*\\(.+\\).in", options: .caseInsensitive)
                let range = NSRange(0 ..< line.length)
                let results = regex.matches(in: line as String, options: .reportProgress, range: range)
                
            }
            catch
            {
                completionHandler(error as NSError)
            }
        }
        
        completionHandler(nil)
    }
    
}

//
//  SourceEditorCommand.swift
//  Formatter
//
//  Created by Justin Lee on 8/19/16.
//  Copyright © 2016 AppLovin. All rights reserved.
//

import Foundation
import XcodeKit

extension NSString
{
    func remove (characters: [Character], in range: NSRange) -> NSString
    {
        var cleanString = self;
        for char in characters
        {
            cleanString = cleanString.replacingOccurrences(of: String(char), with: "", options: .caseInsensitive, range: range)
        }
        return cleanString
    }
}

class SourceEditorCommand: NSObject, XCSourceEditorCommand
{
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: (NSError?) -> Void ) -> Void
    {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        
        var updatedLineIndexes: [Int] = []
        
        for lineIndex in 0 ..< invocation.buffer.lines.count
        {
            let line = invocation.buffer.lines[lineIndex] as! NSString
            do
            {
                let regex = try RegularExpression(pattern: "\\{.*\\(.+\\).+in", options: .caseInsensitive)
                let range = NSRange(0 ..< line.length)
                let results = regex.matches(in: line as String, options: .reportProgress, range: range)
                
                _ = results.map
                { result in
                    let cleanLine = line.remove(characters: ["(", ")"], in: result.range)
                    updatedLineIndexes.append(lineIndex)
                    invocation.buffer.lines[lineIndex] = cleanLine
                }
            }
            catch
            {
                completionHandler(error as NSError)
            }
        }
        
        if !updatedLineIndexes.isEmpty
        {
            let updatedSelections: [XCSourceTextRange] = updatedLineIndexes.map
            { lineIndex in
                let lineSelection = XCSourceTextRange()
                lineSelection.start = XCSourceTextPosition(line: lineIndex, column: 0)
                lineSelection.end = XCSourceTextPosition(line: lineIndex, column: 0)
                return lineSelection
            }
            invocation.buffer.selections.setArray(updatedSelections)
        }
        completionHandler(nil)
    }
}

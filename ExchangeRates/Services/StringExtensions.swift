//
//  StringExtensions.swift
//  ExchangeRates
//
//  Created by Aim on 20/01/21.
//

import Foundation
extension String {
  
  public func replaceFirst(of pattern:String,
                           with replacement:String) -> String {
    if let range = self.range(of: pattern){
      return self.replacingCharacters(in: range, with: replacement)
    }else{
      return self
    }
  }
  
  public func replaceAll(of pattern:String,
                         with replacement:String,
                         options: NSRegularExpression.Options = []) -> String{
    do{
      let regex = try NSRegularExpression(pattern: pattern, options: [])
      let range = NSRange(0..<self.utf16.count)
      return regex.stringByReplacingMatches(in: self, options: [],
                                            range: range, withTemplate: replacement)
    }catch{
      NSLog("replaceAll error: \(error)")
      return self
    }
  }
  
}

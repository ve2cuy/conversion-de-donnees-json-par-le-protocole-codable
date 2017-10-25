//
//  YahooFinance.swift
//  testerCodable
//
//  Created by Alain on 17-10-25.
//  Copyright © 2017 Alain. All rights reserved.
//

import Foundation
struct YahooFinance: Codable {
    var query: Query
}

struct Query:Codable {
    var count:      Int
    var created:    String
    var lang:       String
    var results:    Results
}

struct Results:Codable {
    var quote: Array<Quote>
 
}

struct Quote:Codable {
    var Symbol: String?
    var Ask:    String?
    var Name:   String?
}

//
//  BusinessSearchResponse.swift
//  Yelp
//
//  Created by Gokul Sai Katragadda on 10/28/21.
//

import Foundation

struct BusinessSearchResponse: Codable {
    let total: UInt
    let businesses: [Business]
}

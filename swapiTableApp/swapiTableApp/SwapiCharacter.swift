//
//  swapiCharacter.swift
//  swapiTableApp
//
//  Created by Riley Gibbs on 12/5/19.
//  Copyright © 2019 Riley Gibbs. All rights reserved.
//

import Foundation

struct SwapiCharacter {
    let name: String
    let gender: String
    var filmCount: Int {
        get { return films.count }
    }
    let films: [String]
    let species: [String]
    let birthYear: String
}

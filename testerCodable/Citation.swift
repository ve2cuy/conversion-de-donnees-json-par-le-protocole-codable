//
//  Citation.swift
//  testerCodable
//
//  Created by Alain on 17-10-25.
//  Copyright © 2017 Alain. All rights reserved.
//

import Foundation

class Citation: Codable {
    
    var info: Dictionary<String, String>
    var resultat: Array<DetailCitation>
}

struct DetailCitation:Codable {
    var categorie: String
    var pensee_auteur: String?
    var pensee_texte: String?
}

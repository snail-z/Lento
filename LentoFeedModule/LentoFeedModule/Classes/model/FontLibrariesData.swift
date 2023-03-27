//
//  FontLibrariesData.swift
//  Lento
//
//  Created by zhang on 2022/10/24.
//

import UIKit

class FontLibrariesData: NSObject {

    static func dataGroups() -> [FontLibrariesGroup] {
        let familyNames = UIFont.sortedFamilyNames.catalogues { $0.firstCharacter } map: { aKey, values in
            return FontLibrariesGroup(letter: aKey, familyNames: values)
        }
        return familyNames
    }
}

struct FontLibrariesGroup {
    
    var letter: String = ""
    var familyNames: [String] = []
}

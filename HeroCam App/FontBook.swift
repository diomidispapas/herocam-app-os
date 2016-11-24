//
//  FontBook.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 29/09/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

enum DynamicType : String {
    case Body = "UIFontTextStyleBody"
    case Headline = "UIFontTextStyleHeadline"
    case Subheadline = "UIFontTextStyleSubheadline"
    case Footnote = "UIFontTextStyleFootnote"
    case Caption1 = "UIFontTextStyleCaption1"
    case Caption2 = "UIFontTextStyleCaption2"
}

enum FontBook: String {
    case Regular = "SourceSansPro"
    case Light = "SourceSansPro-Light"
    func of(_ style: DynamicType) -> UIFont {
        let preferred = UIFont.preferredFont(forTextStyle: UIFontTextStyle(rawValue: style.rawValue)).pointSize
        return UIFont(name: self.rawValue, size: preferred)!
    }
}

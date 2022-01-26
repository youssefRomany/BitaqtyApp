//
//  CustomLbl.swift
//  Zillo
//
//  Created by Alia Ziada on 3/11/20.
//  Copyright © 2020 Alia Ziada. All rights reserved.
//

import Foundation
import UIKit

class LblSmallerLightFont: UILabel {
    override func awakeFromNib() {
        font = UIFont(name: FONT_LIGHT, size: FONT_SMALLER);
    }
    
}

class LblSmallerRegularFont: UILabel {
    override func awakeFromNib() {
        font = UIFont(name: FONT_REG, size: FONT_SMALLER);
    }
    
}

class LblSmallerBoldFont: UILabel {
    override func awakeFromNib() {
        font = UIFont(name: FONT_BOLD, size: FONT_SMALLER);
    }
    
}
class LblExtraSmallerBoldFont: UILabel {
    override func awakeFromNib() {
        let extraSmall: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? lang == "en" ? 12 : 10 : lang == "en" ? 9 : 7;
        font = UIFont(name: FONT_BOLD, size: extraSmall);
    }
    
}
class LblExtraSmallerRegularFont: UILabel {
    override func awakeFromNib() {
        let extraSmall: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? lang == "en" ? 12 : 10 : lang == "en" ? 9 : 7;
        font = UIFont(name: FONT_REG, size: extraSmall);
    }
    
}

class LblSmallerSemiBoldFont: UILabel {
    override func awakeFromNib() {
        font = UIFont(name: FONT_SEMI_BOLD, size: FONT_SMALLER);
    }
    
}


class LblSmallRegularFont: UILabel {
    override func awakeFromNib() {
        font = UIFont(name: FONT_REG, size: FONT_SMALL);
    }
    
}

class LblSmallBoldFont: UILabel {
    override func awakeFromNib() {
        font = UIFont(name: FONT_BOLD, size: FONT_SMALL);
    }
    
}

class LblSmallSemiBoldFont: UILabel {
    override func awakeFromNib() {
        font = UIFont(name: FONT_SEMI_BOLD, size: FONT_SMALL);
    }
    
}

class LblMediumRegularFont: UILabel {
    override func awakeFromNib() {
        font = UIFont(name: FONT_REG, size: FONT_MEDUIM);
    }
    
}

class LblMediumBoldFont: UILabel {
    override func awakeFromNib() {
        font = UIFont(name: FONT_BOLD, size: FONT_MEDUIM);
    }
}

class LblMediumSemiBoldFont: UILabel {
    override func awakeFromNib() {
        font = UIFont(name: FONT_SEMI_BOLD, size: FONT_MEDUIM);
    }
}

class LblLargeRegularFont: UILabel {
    override func awakeFromNib() {
        font = UIFont(name: FONT_REG, size: FONT_LARGE);
    }
    
}

class LblLargeBoldFont: UILabel {
    override func awakeFromNib() {
        font = UIFont(name: FONT_BOLD, size: FONT_LARGE);
    }
}
class LblLargeSemiBoldFont: UILabel {
    override func awakeFromNib() {
        font = UIFont(name: FONT_SEMI_BOLD, size: FONT_LARGE);
    }
}

class LblMediumLightFont: UILabel {
    override func awakeFromNib() {
        font = UIFont(name: FONT_LIGHT, size: FONT_MEDUIM);
    }
}
class LblSmallLightFont: UILabel {
    override func awakeFromNib() {
        font = UIFont(name: FONT_LIGHT, size: FONT_SMALL);
    }
}

class LblLargerLightFont: UILabel {
    override func awakeFromNib() {
        font = UIFont(name: FONT_LIGHT, size: FONT_LARGER);
    }
}

class LblLargerRegularFont: UILabel {
    override func awakeFromNib() {
        font = UIFont(name: FONT_REG, size: FONT_LARGER);
    }
}

class LblLargerMediumFont: UILabel {
    override func awakeFromNib() {
        font = UIFont(name: FONT_SEMI_BOLD, size: FONT_LARGER);
    }
}

class LblLargerBoldFont: UILabel {
    override func awakeFromNib() {
        font = UIFont(name: FONT_BOLD, size: FONT_LARGER);
    }
}



class LblSmallIconFont: UILabel {
    override func awakeFromNib() {
        font = UIFont(name: FONT_ICON, size: ICON_FONT_SMALL);
    }
}

class LblMediumIconFont: UILabel {
    override func awakeFromNib() {
        font = UIFont(name: FONT_ICON, size: ICON_FONT_MEDUIM);
    }
}

class LblLargeIconFont: UILabel {
    override func awakeFromNib() {
        font = UIFont(name: FONT_ICON, size: ICON_FONT_LARGE);
    }
}


class PaddingLabel: UILabel{
    override func awakeFromNib() {
        font = UIFont(name: FONT_LIGHT, size: FONT_SMALL);
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        super.drawText(in: rect.inset(by: insets))
    }
}

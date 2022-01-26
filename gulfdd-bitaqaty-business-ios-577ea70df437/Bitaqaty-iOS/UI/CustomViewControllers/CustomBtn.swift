//
//  CustomBtn.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 7/8/21.
//

import Foundation
import UIKit

class BtnSmallerRegularFont: UIButton {
    override func awakeFromNib() {
        titleLabel?.font = UIFont(name: FONT_REG, size: FONT_SMALLER);
    }
    
}

class BtnSmallerBoldFont: UIButton {
    override func awakeFromNib() {
        titleLabel?.font = UIFont(name: FONT_BOLD, size: FONT_SMALLER);
    }
    
}
class BtnExtraSmallerBoldFont: UIButton {
    override func awakeFromNib() {
        let extraSmall: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? lang == "en" ? 12 : 10 : lang == "en" ? 9 : 7;
        titleLabel?.font = UIFont(name: FONT_BOLD, size: extraSmall);
    }
    
}

class BtnSmallerSemiBoldFont: UIButton {
    override func awakeFromNib() {
        titleLabel?.font = UIFont(name: FONT_SEMI_BOLD, size: FONT_SMALLER);
    }
    
}


class BtnSmallRegularFont: UIButton {
    override func awakeFromNib() {
        titleLabel?.font = UIFont(name: FONT_REG, size: FONT_SMALL);
    }
    
}

class BtnSmallBoldFont: UIButton {
    override func awakeFromNib() {
        titleLabel?.font = UIFont(name: FONT_BOLD, size: FONT_SMALL);
    }
    
}

class BtnSmallSemiBoldFont: UIButton {
    override func awakeFromNib() {
        titleLabel?.font = UIFont(name: FONT_SEMI_BOLD, size: FONT_SMALL);
    }
    
}

class BtnMediumRegularFont: UIButton {
    override func awakeFromNib() {
        titleLabel?.font = UIFont(name: FONT_REG, size: FONT_MEDUIM);
    }
    
}

class BtnMediumBoldFont: UIButton {
    override func awakeFromNib() {
        titleLabel?.font = UIFont(name: FONT_BOLD, size: FONT_MEDUIM);
    }
}

class BtnMediumSemiBoldFont: UIButton {
    override func awakeFromNib() {
        titleLabel?.font = UIFont(name: FONT_SEMI_BOLD, size: FONT_MEDUIM);
    }
}

class BtnLargeRegularFont: UIButton {
    override func awakeFromNib() {
        titleLabel?.font = UIFont(name: FONT_REG, size: FONT_LARGE);
    }
    
}

class BtnLargeBoldFont: UIButton {
    override func awakeFromNib() {
        titleLabel?.font = UIFont(name: FONT_BOLD, size: FONT_LARGE);
    }
}
class BtnLargeSemiBoldFont: UIButton {
    override func awakeFromNib() {
        titleLabel?.font = UIFont(name: FONT_SEMI_BOLD, size: FONT_LARGE);
    }
}

class BtnMediumLightFont: UIButton {
    override func awakeFromNib() {
        titleLabel?.font = UIFont(name: FONT_LIGHT, size: FONT_MEDUIM);
    }
}
class BtnSmallerLightFont: UIButton {
    override func awakeFromNib() {
        titleLabel?.font = UIFont(name: FONT_LIGHT, size: FONT_SMALLER);
    }
}
class BtnSmallLightFont: UIButton {
    override func awakeFromNib() {
        titleLabel?.font = UIFont(name: FONT_LIGHT, size: FONT_SMALL);
    }
}

class BtnLargerLightFont: UIButton {
    override func awakeFromNib() {
        titleLabel?.font = UIFont(name: FONT_LIGHT, size: FONT_LARGER);
    }
}

class BtnLargerRegularFont: UIButton {
    override func awakeFromNib() {
        titleLabel?.font = UIFont(name: FONT_REG, size: FONT_LARGER);
    }
}

class BtnLargerMediumFont: UIButton {
    override func awakeFromNib() {
        titleLabel?.font = UIFont(name: FONT_SEMI_BOLD, size: FONT_LARGER);
    }
}

class BtnLargerBoldFont: UIButton {
    override func awakeFromNib() {
        titleLabel?.font = UIFont(name: FONT_BOLD, size: FONT_LARGER);
    }
}

class BtnStandard: UIButton {
    let DEFAULT_HEIGHT: CGFloat = UIDevice.isPad ? 70 : 50;
    let DEFAULT_WIDTH: CGFloat = UIDevice.isPad ? 200 : 160;
    let CORNER_RADIUS: CGFloat = UIDevice.isPad ? 6 : 4;
    override func awakeFromNib() {
        titleLabel?.font = UIFont(name: FONT_REG, size: FONT_MEDUIM);
        setTitleColor(.white, for: .normal)
        backgroundColor = .accentColor
        layer.cornerRadius = CORNER_RADIUS
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: DEFAULT_HEIGHT),
            self.widthAnchor.constraint(equalToConstant: DEFAULT_WIDTH)
        ])
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
}




//

import UIKit

class TimerCustomLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        textAlignment = .center
        textColor = .textColor
        adjustsFontSizeToFitWidth = true
        let style  = UIFont.TextStyle.body
        font = UIFont.preferredFont(forTextStyle: style)
        backgroundColor = .gradientDarker
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 2
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

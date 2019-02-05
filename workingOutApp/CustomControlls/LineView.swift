
import UIKit

class LineView : UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderColor = UIColor.linesColor.cgColor
        layer.borderWidth = 3
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

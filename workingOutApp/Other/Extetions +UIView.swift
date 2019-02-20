//
//  Extetions +UIView.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 03/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit


extension UITextField {
    func setLeftPaddingPoints(_ space: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: space, height: frame.size.height))
        leftView = paddingView
        leftViewMode = .always
    }
}
extension Array where Array.Element: AnyObject {

    func index(ofElement element: Element) -> Int {
        for (currentIndex, currentElement) in self.enumerated() {
            if currentElement === element {
                return currentIndex
            }
        }
        return 0
    }
}

extension UIColor {

    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
    static let blackColor = UIColor.rgb(r: 0, g: 0, b: 0, a: 0.2)
    static let mainDark = UIColor.rgb(r: 44, g: 62, b: 101, a: 1)
    static let mainLight = UIColor.rgb(r: 223, g: 115, b: 181, a: 1)
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension UIView {

    func setBackgroudView() {
        let backgroundImage = UIImageView(image: UIImage(named: "backgraund"))
        backgroundImage.contentMode = .scaleAspectFill
        addSubview(backgroundImage)
        backgroundImage.fillSuperview()
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.alpha = 0.9
        addSubview(visualEffectView)
        visualEffectView.fillSuperview()
    }

    enum Directons {
        case horizontal
        case vertical
    }
    
    func setupSabLayer(shapelayerOfView: CAShapeLayer, cornerRadius: CGFloat, strokes: Int, direction: Directons) {

        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        let path = UIBezierPath()
        let strokePath = UIBezierPath()
        var stroke = 0
        if  strokes == 0 {
            stroke = 1
        } else {
            stroke = strokes
        }
        switch direction {
        case .horizontal:
            path.move(to: CGPoint(x: 0, y: self.frame.height / 2))
            path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height / 2))

            var x: CGFloat = 0
            for _ in 0...stroke {
                x = x + (self.frame.width / CGFloat(stroke * 2) ) // x * 2 = amount of strokes
                strokePath.move(to: CGPoint(x: x + x, y: 0))
                strokePath.addLine(to: CGPoint(x: x + x, y: self.frame.height))
            }

        case .vertical:
            path.move(to: CGPoint(x: self.frame.width / 2, y: self.frame.height))
            path.addLine(to: CGPoint(x: self.frame.width / 2, y: 0 ))

            var y: CGFloat = 0
            for _ in 0...stroke {
                y = y + (self.frame.height / CGFloat(stroke) * 2 ) // x * 2 = amount of strokes
                strokePath.move(to: CGPoint(x: 0, y: y + y))
                strokePath.addLine(to: CGPoint(x: self.frame.width, y: y + y))
            }
        }
        path.move(to: CGPoint(x: 0, y: self.frame.height / 2))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height / 2))

        shapelayerOfView.path = path.cgPath
        shapelayerOfView.lineWidth = self.frame.height
        shapelayerOfView.strokeColor = UIColor.mainDark.cgColor
        shapelayerOfView.strokeEnd = 0
        self.layer.addSublayer(shapelayerOfView)

        let fillStrokes = CAShapeLayer()
        fillStrokes.path = strokePath.cgPath
        fillStrokes.lineWidth = 2
        fillStrokes.strokeColor = UIColor.mainLight.cgColor
        self.layer.addSublayer(fillStrokes)
    }
}
extension UIView {

    func fillSuperview() {
        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor)
    }

    func anchorSize(to view: UIView) {
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }

    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }

        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }

        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }

        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }

        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }

        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }

    func centerInSuperview(size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
        }

        if let superviewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
        }

        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }

        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}

extension UIImageView {
    func downloaded(from link: String, completion: ((Data) -> Void)? = nil) {
        guard let url = URL(string: link) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self?.image = image
                completion?(data)
            }

            }.resume()
    }
}

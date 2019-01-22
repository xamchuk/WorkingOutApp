//
//  Extetions +UIView.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 03/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

extension UIColor {

    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }

    static let backgroundColor = UIColor.rgb(r: 21, g: 22, b: 33)
    static let outlineStrokeColor = UIColor.rgb(r: 234, g: 46, b: 111)
    static let trackStrokeColor = UIColor.rgb(r: 56, g: 25, b: 49)
    static let pulsatingFillColor = UIColor.rgb(r: 86, g: 30, b: 63)


    static let gradientDarker = UIColor.rgb(r: 86, g: 113, b: 123)
    static let gradientLighter = UIColor.rgb(r: 53, g: 92, b: 97)

    static let darckOrange = UIColor.rgb(r: 187, g: 147, b: 104)


    static let linesColor = UIColor.rgb(r: 165, g: 162, b: 153)
    static let textColor = UIColor.rgb(r: 196, g: 188, b: 188)

}

extension UIView {

    func makeGradients() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.gradientDarker.cgColor, UIColor.gradientLighter.cgColor]
        gradient.locations = [0, 1, 1 ,0]
        gradient.frame = self.bounds
        self.layer.addSublayer(gradient)
    }

    enum Directons {
        case horizontal
        case vertical
    }
    
    func setupSabLayer(shapelayerOfView: CAShapeLayer, cornerRadius: CGFloat, strokes: Int, direction: Directons) {

        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.linesColor.cgColor
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
        shapelayerOfView.lineWidth = self.frame.width
        shapelayerOfView.strokeColor = UIColor.textColor.cgColor
        self.layer.addSublayer(shapelayerOfView)

        let fillStrokes = CAShapeLayer()
        fillStrokes.path = strokePath.cgPath
        fillStrokes.lineWidth = 1
        fillStrokes.strokeColor = UIColor.black.cgColor
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

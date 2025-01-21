//
//  Ex + UIButton.swift
//  FratriaVPN
//
//  Created by Антон Баландин on 21.01.25.
//

import UIKit

extension UIButton {
    
    func styleButton(backgroundColor: UIColor, title: String, titleColor: UIColor, cornerRadius: CGFloat, fontSize: CGFloat) {
        self.setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSize)
        self.setTitleColor(titleColor, for: .normal)
    }
    
    func addPressAnimation() {
        self.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchDown)
        self.addTarget(self, action: #selector(buttonReleased(_:)), for: .touchUpInside)
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            sender.alpha = 0.7
        }
    }
    
    @objc private func buttonReleased(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            sender.transform = CGAffineTransform.identity
            sender.alpha = 1.0
        }
    }
}


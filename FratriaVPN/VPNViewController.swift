//
//  VPNViewController.swift
//  FratriaVPN
//
//  Created by Антон Баландин on 20.01.25.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    // MARK: - GUI Variables
    private let startButton = UIButton(type: .system)
    private let stopButton = UIButton(type: .system)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupGradientBackground()
        setupStartButton()
        setupStopButton()
    }
    
    // MARK: - Actions
    @objc func startVPN() {
        VPNManager.shared.setupVPN { error in
            if let error {
                print("Failed to setup VPN: \(error)")
            } else {
                VPNManager.shared.startVPN()
            }
        }
    }
    
    @objc func stopVPN() {
        VPNManager.shared.stopVPN()
    }
}

// MARK: - ViewController extensions
extension ViewController {
    private func setupStartButton() {
        startButton.styleButton(backgroundColor: .systemGreen, title: "Start VPN", titleColor: .white, cornerRadius: 25, fontSize: 18)
        startButton.addTarget(self, action: #selector(startVPN), for: .touchUpInside)
        
        view.addSubview(startButton)
        startButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-200)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        startButton.addPressAnimation()
    }
    
    private func setupStopButton() {
        stopButton.styleButton(backgroundColor: .systemRed, title: "Stop VPN", titleColor: .white, cornerRadius: 25, fontSize: 18)
        stopButton.addTarget(self, action: #selector(stopVPN), for: .touchUpInside)
        
        view.addSubview(stopButton)
        stopButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        stopButton.addPressAnimation()
    }
    
    private func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.white.cgColor,
            UIColor.blue.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

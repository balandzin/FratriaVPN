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
        
        setupStartButton()
        setupStopButton()
    }
    
    // MARK: - Private Methods
    private func setupStartButton() {
        startButton.setTitle("Start VPN", for: .normal)
        startButton.addTarget(self, action: #selector(startVPN), for: .touchUpInside)
        
        view.addSubview(startButton)
        startButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
    
    private func setupStopButton() {
        stopButton.setTitle("Stop VPN", for: .normal)
        stopButton.addTarget(self, action: #selector(stopVPN), for: .touchUpInside)
        
        view.addSubview(stopButton)
        stopButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(startButton.snp.bottom).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Actions
    @objc func startVPN() {
        VPNManager.shared.setupVPN { error in
            if let error = error {
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


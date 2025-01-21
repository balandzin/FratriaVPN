//
//  VPNManager.swift
//  FratriaVPN
//
//  Created by Антон Баландин on 21.01.25.
//

import Foundation
import NetworkExtension

class VPNManager {
    static let shared = VPNManager()
    private let vpnManager = NETunnelProviderManager()
    
    private init() {}
    
    // MARK: - VPN Control
    func setupVPN(completion: @escaping (Error?) -> Void) {
        vpnManager.loadFromPreferences { [weak self] error in
            if let error {
                completion(error)
                return
            }
            
            guard let self = self else { return }
            
            let tunnelProtocol = NETunnelProviderProtocol()
            tunnelProtocol.serverAddress = "lon5.vpntype.dev"
            tunnelProtocol.providerConfiguration = [
                "vlessConfig": self.generateVLESSConfig()
            ]
            tunnelProtocol.disconnectOnSleep = false
            
            self.vpnManager.protocolConfiguration = tunnelProtocol
            self.vpnManager.localizedDescription = "VLESS VPN"
            self.vpnManager.isEnabled = true
            
            self.vpnManager.saveToPreferences { error in
                if let error {
                    print("Failed to save VPN preferences: \(error)")
                    completion(error)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    func startVPN() {
        vpnManager.loadFromPreferences { error in
            if let error {
                print("Failed to load VPN preferences: \(error)")
                return
            }
            
            do {
                try self.vpnManager.connection.startVPNTunnel()
                print("VPN started.")
            } catch {
                print("Failed to start VPN tunnel: \(error)")
            }
        }
    }
    
    func stopVPN() {
        vpnManager.connection.stopVPNTunnel()
        print("VPN stopped.")
    }
    
    // MARK: - VPN Configuration
    private func generateVLESSConfig() -> [String: Any] {
        return [
            "log": [
                "loglevel": "info"
            ],
            "outbounds": [
                [
                    "protocol": "vless",
                    "settings": [
                        "vnext": [
                            [
                                "address": "lon5.vpntype.dev",
                                "port": 443,
                                "users": [
                                    [
                                        "id": "7cd4f52e-30f7-4f78-8b98-4f8f9847c1b9",
                                        "security": "tls",
                                        "encryption": "none",
                                        "flow": "xtls-rprx-vision",
                                        "alpn": ["h2", "http/1.1"]
                                    ]
                                ]
                            ]
                        ]
                    ],
                    "tag": "vless-out"
                ]
            ],
            "streamSettings": [
                "network": "tcp",
                "security": "tls",
                "tlsSettings": [
                    "alpn": ["h2", "http/1.1"],
                    "allowInsecure": false
                ]
            ],
            "routing": [
                "rules": [
                    [
                        "type": "field",
                        "outboundTag": "vless-out"
                    ]
                ]
            ]
        ]
    }
}


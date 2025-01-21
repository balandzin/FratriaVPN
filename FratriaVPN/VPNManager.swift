//
//  VPNManager.swift
//  FratriaVPN
//
//  Created by Антон Баландин on 21.01.25.
//

import NetworkExtension

class VPNManager {
    static let shared = VPNManager()
    private let vpnManager = NETunnelProviderManager()
    
    private init() {}
    
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
                "vlessConfig": VPNConfig.generateVLESSConfig()
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
}

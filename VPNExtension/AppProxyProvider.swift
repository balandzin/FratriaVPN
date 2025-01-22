//
//  AppProxyProvider.swift
//  VPNExtension
//
//  Created by Антон Баландин on 21.01.25.
//

import NetworkExtension

class AppProxyProvider: NEAppProxyProvider {
    override func startProxy(options: [String: Any]?, completionHandler: @escaping (Error?) -> Void) {
        print("Proxy started with options: \(String(describing: options))")
        if let vpnConfig = options?["vlessConfig"] as? [String: Any] {
            print("VLESS config received: \(vpnConfig)")
        }
        
        completionHandler(nil)
    }

    override func stopProxy(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        print("Proxy stopped with reason: \(reason.rawValue)")
        
        completionHandler()
    }
}


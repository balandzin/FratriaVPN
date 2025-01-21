//
//  AppDelegate.swift
//  FratriaVPN
//
//  Created by Антон Баландин on 20.01.25.
//

import UIKit
import NetworkExtension

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureVPN()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        let vpnViewController = ViewController()
        let navigationController = UINavigationController(rootViewController: vpnViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        checkVPNStatus()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        disconnectVPN()
    }
    
    // MARK: - VPN Configuration
    
    private func configureVPN() {
        let vpnManager = NETunnelProviderManager()
        
        vpnManager.loadFromPreferences { error in
            if let error {
                print("Ошибка при загрузке настроек VPN: \(error.localizedDescription)")
                return
            }
            
            let tunnelProtocol = NETunnelProviderProtocol()
            tunnelProtocol.serverAddress = "lon5.vpntype.dev"
            tunnelProtocol.providerConfiguration = [
                "vlessConfig": VPNConfig.generateVLESSConfig()
            ]
            tunnelProtocol.disconnectOnSleep = false
            
            vpnManager.protocolConfiguration = tunnelProtocol
            vpnManager.localizedDescription = "VLESS VPN"
            vpnManager.isEnabled = true
            
            vpnManager.saveToPreferences { (error) in
                if let error = error {
                    print("Ошибка при сохранении настроек VPN: \(error.localizedDescription)")
                    return
                }
                print("VPN настроен успешно")
            }
        }
    }
    
    private func connectVPN() {
        let vpnManager = NETunnelProviderManager()
        
        vpnManager.loadFromPreferences { (error) in
            if let error {
                print("Ошибка при загрузке настроек для подключения: \(error.localizedDescription)")
                return
            }
            
            do {
                try vpnManager.connection.startVPNTunnel()
                print("VPN подключен")
            } catch {
                print("Ошибка при подключении к VPN: \(error.localizedDescription)")
            }
        }
    }
    
    private func disconnectVPN() {
        let vpnManager = NETunnelProviderManager()
        
        vpnManager.loadFromPreferences { (error) in
            if let error {
                print("Ошибка при загрузке настроек для отключения: \(error.localizedDescription)")
                return
            }
            
            vpnManager.connection.stopVPNTunnel()
            print("VPN отключен")
        }
    }
    
    private func checkVPNStatus() {
        let vpnManager = NETunnelProviderManager()
        
        vpnManager.loadFromPreferences { (error) in
            if let error {
                print("Ошибка при проверке статуса VPN: \(error.localizedDescription)")
                return
            }
            
            if vpnManager.connection.status == .connected {
                print("VPN уже подключен")
            } else {
                print("VPN не подключен")
            }
        }
    }
    
    private func reconnectVPN() {
        let vpnManager = NETunnelProviderManager()
        
        vpnManager.loadFromPreferences { [weak self] (error) in
            if let error = error {
                print("Ошибка при повторном подключении к VPN: \(error.localizedDescription)")
                return
            }
            
            if vpnManager.connection.status != .connected {
                self?.connectVPN()
            }
        }
    }
}

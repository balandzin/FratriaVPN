//  VPNManager.swift
//  FratriaVPN
//
//  Created by Антон Баландин on 21.01.25.
//

import NetworkExtension
import Foundation

class VPNManager {
    static let shared = VPNManager()

    private init() {}

    // Запуск VPN с использованием NEVPNManager
    func startVPN(completion: @escaping (Bool, Error?) -> Void) {
        let vpnManager = NEVPNManager.shared()

        vpnManager.loadFromPreferences { error in
            guard error == nil else {
                completion(false, error)
                return
            }

            // Создаем объект VPN протокола IKEv2
            let vpnProtocol = NEVPNProtocolIKEv2()
            vpnProtocol.username = "your-username" // Здесь используйте ваш логин для подключения
            vpnProtocol.passwordReference = nil // Не используется пароль
            vpnProtocol.serverAddress = "rutube.isgood.host"
            vpnProtocol.authenticationMethod = .none // Используйте метод аутентификации, который не требует пароля
            vpnProtocol.localIdentifier = "your-local-identifier"
            vpnProtocol.remoteIdentifier = "your-remote-identifier"
            vpnProtocol.useExtendedAuthentication = false

            vpnManager.protocolConfiguration = vpnProtocol
            vpnManager.isEnabled = true

            // Сохраняем конфигурацию
            vpnManager.saveToPreferences { error in
                guard error == nil else {
                    completion(false, error)
                    return
                }

                // Подключаемся к VPN
                do {
                    try vpnManager.connection.startVPNTunnel()
                    completion(true, nil)  // Успех
                } catch {
                    completion(false, error)  // Ошибка при подключении
                }
            }
        }
    }

    // Остановка VPN
    func stopVPN(completion: @escaping (Bool, Error?) -> Void) {
        let vpnManager = NEVPNManager.shared()

        vpnManager.loadFromPreferences { error in
            guard error == nil else {
                completion(false, error)
                return
            }

            vpnManager.connection.stopVPNTunnel()
            completion(true, nil)
        }
    }
}


//  ViewController.swift
//  FratriaVPN
//
//  Created by Антон Баландин on 20.01.25.
//

import UIKit
import NetworkExtension

class ViewController: UIViewController {
    var vpnManager: NEVPNManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Настроим VPN Manager
        vpnManager = NEVPNManager.shared()

        // Создание протокола для VPN
        let vpnProtocol = NEVPNProtocolIPSec()
        vpnProtocol.serverAddress = "178.172.150.133" // IP-адрес вашего сервера
        vpnProtocol.username = "user"  // Имя пользователя (если используется)
        vpnProtocol.passwordReference = nil // Можно указать пароль, если он используется
        vpnProtocol.authenticationMethod = .none // Используем метод аутентификации без пароля
        vpnProtocol.remoteIdentifier = "twitch.tv"  // Используемое SNI
        vpnProtocol.localIdentifier = "local_identifier" // Уникальный идентификатор для локальной стороны

        // Настройка безопасности
        vpnProtocol.useExtendedAuthentication = false
        vpnProtocol.disconnectOnSleep = false // Отключать VPN при переходе в режим сна

        // Сохраняем протокол VPN
        vpnManager.protocolConfiguration = vpnProtocol
        vpnManager.isEnabled = true

        // Применение настроек
        vpnManager.saveToPreferences { error in
            if let error = error {
                print("Ошибка при сохранении настроек: \(error.localizedDescription)")
            } else {
                print("Настройки VPN сохранены")
            }
        }
        
        // Добавим кнопку для подключения
        let connectButton = UIButton(type: .system)
        connectButton.setTitle("Connect VPN", for: .normal)
        connectButton.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        connectButton.addTarget(self, action: #selector(connectVPN), for: .touchUpInside)
        view.addSubview(connectButton)
    }

    // Метод для подключения VPN
    @objc func connectVPN() {
        do {
            try vpnManager.connection.startVPNTunnel()
            print("VPN подключен")
        } catch {
            print("Ошибка при подключении к VPN: \(error.localizedDescription)")
        }
    }
}




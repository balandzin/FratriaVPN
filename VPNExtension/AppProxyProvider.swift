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
        
        // Здесь можно добавить настройку подключения, используя параметры options
        // Если у вас есть настройка VLESS, ее можно обработать в этой части.
        
        // Например, можно использовать настройки для подключения к вашему серверу:
        // Обработка VLESS-параметров из options или настроек вашего VPN
        if let vpnConfig = options?["vlessConfig"] as? [String: Any] {
            // Настройка VLESS конфигурации
            print("VLESS config received: \(vpnConfig)")
        }
        
        // Завершаем запуск прокси
        completionHandler(nil)
    }

    override func stopProxy(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        // Логируем причину остановки прокси
        print("Proxy stopped with reason: \(reason.rawValue)")
        
        // Здесь можно выполнить любую очистку, если необходимо, например, закрытие соединений, остановка туннелей и т.д.
        
        completionHandler()
    }

    // Опционально: Можно добавить методы для обработки трафика и подключения.
}


//
//  VPNConfig.swift
//  FratriaVPN
//
//  Created by Антон Баландин on 21.01.25.
//

import Foundation

class VPNConfig {

    static func generateVLESSConfig() -> [String: Any] {
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

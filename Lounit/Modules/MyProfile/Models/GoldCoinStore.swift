//
//  GoldCoinStore.swift
//  Lounit
//
//  Created by Codex on 2026/6/9.
//

import Foundation

enum GoldCoinStore {
    private static let keyPrefix = "lounit.goldCoins.balance."
    private static let testAccountGiftBalance = 100

    static var balance: Int {
        let key = balanceKey(for: currentOwnerMail)
        if let storedBalance = UserDefaults.standard.object(forKey: key) as? Int {
            return storedBalance
        }
        return defaultBalance(for: currentOwnerMail)
    }

    static func addCoins(_ amount: Int) {
        guard amount > 0 else { return }
        setBalance(balance + amount)
    }

    static func hasEnoughCoins(_ amount: Int) -> Bool {
        balance >= amount
    }

    static func spendCoins(_ amount: Int) -> Bool {
        guard amount > 0, hasEnoughCoins(amount) else { return false }
        setBalance(balance - amount)
        return true
    }

    private static func setBalance(_ balance: Int) {
        UserDefaults.standard.set(max(0, balance), forKey: balanceKey(for: currentOwnerMail))
    }

    private static var currentOwnerMail: String {
        AuthSession.currentMail ?? "guest"
    }

    private static func balanceKey(for mail: String) -> String {
        keyPrefix + mail
    }

    private static func defaultBalance(for mail: String) -> Int {
        mail == AuthSession.testMail ? testAccountGiftBalance : 0
    }
}

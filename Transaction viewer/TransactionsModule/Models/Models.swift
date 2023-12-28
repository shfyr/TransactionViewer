//
//  Transaction.swift
//  Transaction viewer
//
//  Created by Liza on 27.12.2023.
//
import Foundation

struct TransactionModel: Decodable {
    let amount: String
    let currency: String
    let sku: String
}

struct Transaction {
    let amount: Decimal?
    let currency: String
    let sku: String

    init(amount: String, currency: String, sku: String) {
        self.amount = Decimal(string: amount)
        self.currency = currency
        self.sku = sku
    }
}

struct ProductViewModel: Equatable, Hashable {
    static func == (lhs: ProductViewModel, rhs: ProductViewModel) -> Bool {
        return lhs.sku == rhs.sku
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(sku)
    }
    
    let sku: String
    var transactions: [Transaction]

    mutating func addTransaction(transaction: Transaction) {
        self.transactions.append(transaction)
    }
}

struct RateModel: Decodable {
    let from: String
    let rate: String
    let to: String
}

struct Rate {
    let from: String
    let rate: Decimal?
    let to: String

    init(from: String, rate: String, to: String) {
        self.from = from
        self.rate = Decimal(string: rate)
        self.to = to
    }
}

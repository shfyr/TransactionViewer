//
//  ProductsPresenter.swift
//  Transaction viewer
//
//  Created by Liza on 27.12.2023.
//
import OrderedCollections
import Foundation

final class ProductsPresenter {
    var productsSet = OrderedSet<ProductViewModel>()

    var selected: ProductViewModel?
    var rates: [Rate] = .init()
    var gbpTransactions: [(initial: Decimal, currency: String, gbp: Decimal)]? { toGBP() }

    func getProductSet() {
        let transactions = getTransactions()

        let products = transactions?.map { ProductViewModel(sku: $0.sku, transactions: [$0]) }

        products?.forEach { product in
            if let myElement = productsSet.first(where: { $0.sku == product.sku} ) {
                var transactions = myElement.transactions
                transactions.append(contentsOf: product.transactions)

                productsSet.updateOrInsert(ProductViewModel(sku: product.sku, transactions: transactions ), at: 0)
            } else {
                productsSet.insert(product, at: 0)
            }
        }
    }

    private func getTransactions() -> [Transaction]? {
        let url = Bundle.main.url(forResource: "transactions", withExtension: "plist")
        guard let url else { return nil }

        let data = try? Data(contentsOf: url)
        let transactionModels = try? PropertyListDecoder().decode([TransactionModel].self, from: data!)

        guard let transactionModels else { return nil }

        return transactionModels.map { Transaction(amount: $0.amount, currency: $0.currency, sku: $0.sku) }
    }

    func select(index: Int) {
        selected = productsSet[index]
    }

    func getRates() {
        let url = Bundle.main.url(forResource: "rates", withExtension: "plist")
        guard let url else { return }

        let data = try? Data(contentsOf: url)
        let models = try? PropertyListDecoder().decode([RateModel].self, from: data!)

        guard let models else { return }

        rates = models.map { Rate(from: $0.from, rate: $0.rate, to: $0.to) }
    }

    private func toGBP() -> [(initial: Decimal, currency: String, gbp: Decimal)]? {
        var transactionInGbp: [(initial: Decimal, currency: String, gbp: Decimal)]? = .init()
        guard let selected else { return nil }

        let directRates = rates.filter { $0.to == "GBP"}
        let directRateFrom = directRates.map { $0.from }
        let transactions = selected.transactions

        for transaction in transactions {
            guard let amount = transaction.amount else { continue }

            let currentCurrency = transaction.currency

            if currentCurrency ==  "GBP" {
                transactionInGbp?.append((initial: amount, currency: currentCurrency, gbp: amount))
                continue

            } else if directRateFrom.contains(currentCurrency) {
                for element in directRates {
                    if element.from == currentCurrency {
                        guard let rate = element.rate else { continue }

                        transactionInGbp?.append((initial: amount, currency: currentCurrency, gbp: amount * rate))
                        break
                    }
                }

            } else {
                for directCurrency in directRates {
                    let tempCurrency = directCurrency.from

                    for rate in rates {
                        if rate.from == currentCurrency, rate.to == tempCurrency {
                            let value = amount * rate.rate! * directCurrency.rate!
                            transactionInGbp?.append((initial: amount, currency: currentCurrency, gbp: value))
                            break
                        }
                    }
                }
            }
        }
        
        return transactionInGbp
    }

}

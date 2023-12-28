//
//  TransactionsTableViewController.swift
//  Transaction viewer
//
//  Created by Liza on 27.12.2023.
//

import UIKit

class TransactionsTableViewController: UITableViewController {

    private let presenter: ProductsPresenter
    private lazy var cellId = "cellId0"

    private var gbpTransactions: [(initial: Decimal, currency: String, gbp: Decimal)]?

    init(presenter: ProductsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = presenter.selected?.sku
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: cellId)
    }

    override func viewWillAppear(_ animated: Bool) {
        gbpTransactions = presenter.gbpTransactions
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.selected?.transactions.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? TransactionTableViewCell
        else { fatalError("dequeue cell error") }

        guard let gbpTransactions else { fatalError("no transaction array") }

        let currentTransaction = gbpTransactions[indexPath.row]
        let amount = currentTransaction.initial
        let double = Double(truncating: currentTransaction.gbp as NSNumber)
        let currency = currentTransaction.currency

        cell.setText(leftLabelText: "\(amount) \(currency)", rightLabelText: String(format: "%.2f GBP", double))
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let gbpTransactions else { return nil }

        let allAmount = gbpTransactions
            .map { $0.gbp }
            .reduce(0, +)
        let double = Double(truncating: allAmount as NSNumber)

        return String(format: "Total amount: %.2f GBP", double)
    }

}

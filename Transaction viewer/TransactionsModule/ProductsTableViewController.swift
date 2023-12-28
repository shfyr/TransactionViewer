//
//  ViewController.swift
//  Transaction viewer
//
//  Created by Liza on 27.12.2023.
//

import UIKit
import OrderedCollections

class ProductsTableViewController: UITableViewController {
    private let presenter: ProductsPresenter

    private lazy var cellId = "cellId"

    init(presenter: ProductsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Products"
        presenter.getProductSet()
        presenter.getRates()
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.productsSet.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? TransactionTableViewCell
        else { fatalError("dequeue cell error") }

        let name = presenter.productsSet[indexPath.row].sku
        let amount = presenter.productsSet[indexPath.row].transactions.count
        cell.setText(leftLabelText: name, rightLabelText: String(amount))
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let navController = UIApplication.shared.firstKeyWindow?.rootViewController as! UINavigationController
        navController.pushViewController(TransactionsTableViewController(presenter: presenter), animated: true)
        presenter.select(index: indexPath.row)
    }
}


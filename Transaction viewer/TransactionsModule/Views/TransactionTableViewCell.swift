//
//  ProductCellTableViewCell.swift
//  Transaction viewer
//
//  Created by Liza on 27.12.2023.
//

import UIKit
import SnapKit

class TransactionTableViewCell: UITableViewCell {

    private lazy var leftLabel = UILabel()
    private lazy var rightLabel = UILabel()

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(leftLabel)
        addSubview(rightLabel)

        leftLabel.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
        }

        rightLabel.snp.makeConstraints {
            $0.trailing.top.bottom.equalToSuperview()
        }
    }

    func setText(leftLabelText: String, rightLabelText: String) {
        leftLabel.text = leftLabelText
        rightLabel.text = rightLabelText
    }
}

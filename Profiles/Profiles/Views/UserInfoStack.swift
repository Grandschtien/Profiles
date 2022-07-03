//
//  UserInfoStack.swift
//  Profiles
//
//  Created by Егор Шкарин on 03.07.2022.
//

import UIKit

final class UserInfoStack: UIView {
    
    private lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .systemGray
        return label
    }()
    private lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupConstraints()
    }
    
    func setRightLabel(text: String) {
        rightLabel.text = text
    }
    func setLeftLabel(text: String) {
        leftLabel.text = text
    }
    private func setupConstraints(){
        self.addSubview(leftLabel)
        leftLabel.leading()
        leftLabel.top(isIncludeSafeArea: false)
        
        self.addSubview(rightLabel)
        rightLabel.trailing()
        rightLabel.top(isIncludeSafeArea: false)
    }
}



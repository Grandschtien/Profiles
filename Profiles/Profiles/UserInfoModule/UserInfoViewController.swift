//
//  UserInfoViewController.swift
//  Profiles
//
//  Created by Егор Шкарин on 30.06.2022.
//

import UIKit

final class UserInfoViewController: UIViewController {
    private let output: UserInfoViewOutput
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init(output: UserInfoViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
    }
}

extension UserInfoViewController: UserInfoViewInput {
    func presentProfile(_ profile: LocalProfileModel) {
        
    }
}

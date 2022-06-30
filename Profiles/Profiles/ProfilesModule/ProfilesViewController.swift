//
//  ProfilesViewController.swift
//  Profiles
//
//  Created by Егор Шкарин on 30.06.2022.
//

import UIKit

final class ProfilesViewController: UIViewController {
    private let output: ProfilesViewOutput
    
    init(output: ProfilesViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) didn't implement")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
    
}

extension ProfilesViewController: ProfilesViewInput {
    
}

//
//  UserInfoView.swift
//  Profiles
//
//  Created by Егор Шкарин on 03.07.2022.
//

import UIKit

final class UserInfoView: UIView {
    private enum Placeholders: String {
        case age = "Возраст"
        case dob = "Дата рождения"
        case email = "Почта"
        case localTime = "Текущее время"
    }

    private(set) lazy var picture: UIImageView = {
        let picture = UIImageView()
        picture.translatesAutoresizingMaskIntoConstraints = false
        picture.contentMode = .scaleAspectFill
        picture.tintColor = .darkGray
        return picture
    }()
    
    private lazy var genderImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var ageStackView: UserInfoStack = {
        let stackView = UserInfoStack()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setLeftLabel(text: Placeholders.age.rawValue)
        return stackView
    }()
    
    private lazy var dobStackView: UserInfoStack = {
        let stackView = UserInfoStack()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setLeftLabel(text: Placeholders.dob.rawValue)
        return stackView
    }()
    private lazy var emailStackView: UserInfoStack = {
        let stackView = UserInfoStack()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setLeftLabel(text: Placeholders.email.rawValue)
        return stackView
    }()
    private lazy var localTimeStackView: UserInfoStack = {
        let stackView = UserInfoStack()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setLeftLabel(text: Placeholders.localTime.rawValue)
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setupUI()
    }
    
    func setModel(profileModel: LocalProfileModel) {
        picture.setImage(url: profileModel.picture)
        switch profileModel.gender {
        case .female:
            genderImage.image = UIImage(named: "female")
        case .male:
            genderImage.image = UIImage(named: "male")
        }
        ageStackView.setRightLabel(text: profileModel.age)
        dobStackView.setRightLabel(text: profileModel.dob)
        emailStackView.setRightLabel(text: profileModel.email)
        localTimeStackView.setRightLabel(text: profileModel.currentTime)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        self.addSubview(picture)
        picture.top(self.frame.height / 20, isIncludeSafeArea: true)
        picture.centerX()
        NSLayoutConstraint.activate([
            picture.widthAnchor.constraint(equalToConstant: self.frame.height / 6),
            picture.heightAnchor.constraint(equalToConstant: self.frame.height / 6)
        ])
        
        self.addSubview(genderImage)
        genderImage.centerX()
        NSLayoutConstraint.activate([
            genderImage.topAnchor.constraint(equalTo: picture.bottomAnchor,
                                             constant: self.frame.height / 20),
            genderImage.widthAnchor.constraint(equalToConstant: self.frame.width / 15),
            genderImage.heightAnchor.constraint(equalToConstant: self.frame.width / 15)
        ])
        
        self.addSubview(ageStackView)
        ageStackView.leading(self.frame.width / 10)
        ageStackView.trailing(-self.frame.width / 10)
        NSLayoutConstraint.activate([
            ageStackView.topAnchor.constraint(equalTo: genderImage.bottomAnchor,
                                              constant: self.frame.height / 20),
            ageStackView.heightAnchor.constraint(equalToConstant: self.frame.height / 14)
        ])
        
        self.addSubview(dobStackView)
        dobStackView.leading(self.frame.width / 10)
        dobStackView.trailing(-self.frame.width / 10)
        NSLayoutConstraint.activate([
            dobStackView.topAnchor.constraint(equalTo: ageStackView.bottomAnchor),
            dobStackView.heightAnchor.constraint(equalToConstant: self.frame.height / 14)
        ])
        
        self.addSubview(emailStackView)
        emailStackView.leading(self.frame.width / 10)
        emailStackView.trailing(-self.frame.width / 10)
        NSLayoutConstraint.activate([
            emailStackView.topAnchor.constraint(equalTo: dobStackView.bottomAnchor),
            emailStackView.heightAnchor.constraint(equalToConstant: self.frame.height / 14)
        ])
        
        self.addSubview(localTimeStackView)
        localTimeStackView.leading(self.frame.width / 10)
        localTimeStackView.trailing(-self.frame.width / 10)
        NSLayoutConstraint.activate([
            localTimeStackView.topAnchor.constraint(equalTo: emailStackView.bottomAnchor),
            localTimeStackView.heightAnchor.constraint(equalToConstant: self.frame.height / 14)
        ])
    }
    
    private func setupUI(){
        picture.layer.cornerRadius = self.frame.height / 12
        picture.clipsToBounds = true
    }
}

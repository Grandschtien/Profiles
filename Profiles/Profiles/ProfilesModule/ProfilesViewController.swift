//
//  ProfilesViewController.swift
//  Profiles
//
//  Created by Егор Шкарин on 30.06.2022.
//

import UIKit

final class ProfilesViewController: UIViewController {
    
    private lazy var profileCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: setupCollectionViewLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        let nibForCell = UINib(nibName: ProfileCell.nibName,
                               bundle: nil)
        collection.registerWithNib(ProfileCell.self,
                                   nib: nibForCell)
        return collection
    }()
    
    private lazy var profileCollectionAdapter: ProfileCollectionAdapter = {
        let pca = ProfileCollectionAdapter(profileCollection, batchSize: batchSize)
        pca.delegate = self
        return pca
    }()
    
    private let output: ProfilesViewOutput
    private let batchSize = 10
    init(output: ProfilesViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) didn't implement")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        output.fetchProfiles(page: 0, batchSize: batchSize)
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    private func setupUI() {
        title = "Profiles"
        view.addSubview(profileCollection)
        profileCollection.pins()
        
    }
    
    private func setupCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension ProfilesViewController: ProfilesViewInput {
    func loadedProfiles(_ profiles: [LocalProfileModel]) {
        Task {
            profileCollectionAdapter.configure(profiles)
        }
    }
}

extension ProfilesViewController: ProfileAdapterDelegate {
    func loadNetxtPage(page: Int) {
        output.fetchProfiles(page: page, batchSize: batchSize)
    }
}

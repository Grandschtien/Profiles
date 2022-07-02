//
//  ProfileCollectionAdapter.swift
//  Profiles
//
//  Created by Егор Шкарин on 30.06.2022.
//

import Foundation
import UIKit

protocol ProfileAdapterDelegate: AnyObject {
    func loadNetxtPage(page: Int)
    func didTapOnProfile(profile: LocalProfileModel)
}

final class ProfileCollectionAdapter: NSObject {
    
    enum Section {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, LocalProfileModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, LocalProfileModel>
    
    private var items: [LocalProfileModel]
    //Weak refereces
    private weak var collectionView: UICollectionView?
    weak var delegate: ProfileAdapterDelegate?
    
    // stroed properties
    private lazy var dataSource: DataSource = setupDataSource()
    private let batchSize: Int
    init(_ collectionView: UICollectionView, batchSize: Int) {
        self.collectionView = collectionView
        self.batchSize = batchSize
        items = []
        super.init()
        collectionView.delegate = self
    }
    
    func configure(_ items: [LocalProfileModel]) {
        self.items.append(contentsOf: items)
        applySnapshot()
    }
    private func setupDataSource() -> DataSource {
        guard let collectionView = collectionView else {
            fatalError("Not collection in adapter")
        }
        let dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, profile) -> UICollectionViewCell in
            let cell = collectionView.dequeueCell(cellType: ProfileCell.self, for: indexPath)
            cell.configure(with: profile.picture, name: profile.name)
            return cell
        }
        return dataSource
    }
    
    private func applySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UICollectionViewDelegate
extension ProfileCollectionAdapter: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        delegate?.didTapOnProfile(profile: items[indexPath.row])
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == items.count - 1 {
            let page = (indexPath.row / batchSize) + 1
            delegate?.loadNetxtPage(page: page)
        }
    }
}


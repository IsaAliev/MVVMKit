//
//  ViewDependecy+Installation.swift
//
//  Created by Isa Aliev on 18.09.2020.
//  Copyright © 2020. All rights reserved.
//

import UIKit

extension CollectionItemsViewDependenciesContainable where Self: UITableViewController {
    func installViewDependecies() {
        itemsDependencyManager?.install(on: tableView)
    }
}

extension CollectionItemsViewDependenciesContainable where Self: UICollectionViewController {
    func installViewDependecies() {
        itemsDependencyManager?.install(on: collectionView)
    }
}

extension CollectionItemsViewDependenciesContainable {
    func installViewDependecies(on collectionView: UICollectionView) {
        itemsDependencyManager?.install(on: collectionView)
    }
    
    func installViewDependecies(on tableView: UITableView) {
        itemsDependencyManager?.install(on: tableView)
    }
}

extension CollectionItemsViewDependenciesContainable where Self: UICollectionView {
    func installViewDependecies() {
        itemsDependencyManager?.install(on: self)
    }
}

extension CollectionItemsViewDependenciesContainable where Self: UITableView {
    func installViewDependecies() {
        itemsDependencyManager?.install(on: self)
    }
}

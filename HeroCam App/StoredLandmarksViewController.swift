//
//  StoredLandmarksViewController.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 10/1/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

final class StoredLandmarksViewController: UIViewController, NavigationTitlePresentable, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var sourceCell: UICollectionViewCell?
    
    /// Data Source
    lazy var dataSource: PersistedLandmarksDataSource = {
        return PersistedLandmarksDataSource(managedObjectContext: Storage.shared.context)
    }()
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.reloadData()
        self.navigationController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Update due to the ability to delete an element on the detail view controller
//        self.collectionView.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataSource.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.numberOfObjectsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let persistedLandmark = dataSource.object(atIndexPath: indexPath)
        let cell: StoredLandmarkCollectionViewCell = collectionView.dequeueReusable(forIndexPath: indexPath)
        cell.configure(with: StoredLandmarkCollectionViewCellModel(title: persistedLandmark.title, imageURL: persistedLandmark.wikipediaThumbnailURLString!))
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension StoredLandmarksViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sourceCell = collectionView.cellForItem(at: indexPath)
        
        let persistedLandmark = dataSource.object(atIndexPath: indexPath)
        let storedLandmarkVC = self.storyboard?.instantiateViewController(withIdentifier: StoredLandmarkViewController.storyboardIdentifier) as? StoredLandmarkViewController
        storedLandmarkVC?.inject(persistedLandmark)
        self.navigationController?.pushViewController(storedLandmarkVC!, animated: true)
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension StoredLandmarksViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        // Original: http://stackoverflow.com/questions/26143591/specifying-one-dimension-of-cells-in-uicollectionview-using-auto-layout
        // Here is where we say we want cells to use the width of the collection view
        let requiredWidth = collectionView.bounds.size.width / 2 - 30
        // Here is where we ask our sizing cell to compute what height it needs
        return   CGSize(width: requiredWidth, height: requiredWidth * 1.4)
    }
}

//MARK: UINavigationControllerDelegate
extension StoredLandmarksViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // In this method belonging to the protocol UINavigationControllerDelegate you must
        // return an animator conforming to the protocol UIViewControllerAnimatedTransitioning.
        // To perform the Pop in and Out animation PopInAndOutAnimator should be returned
        return PopInAndOutAnimator(operation: operation)
    }
}

//MARK: CollectionPushAndPoppable
extension StoredLandmarksViewController: CollectionPushAndPoppable {}

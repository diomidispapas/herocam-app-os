//
//  CollectionPushAndPoppable.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 10/3/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

protocol CollectionPushAndPoppable {
    var sourceCell: UICollectionViewCell? { get }
    var collectionView: UICollectionView! { get }
    var view: UIView! { get }
}

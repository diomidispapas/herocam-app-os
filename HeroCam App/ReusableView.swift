//
//  ReusableView.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 18/09/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

/**
 *  ReusableView protocol provides a default reuse identifier throught its extension constrained to ```UIView``` subclasses. The default reuse identifier is set to the name of the class.
 */
protocol ReusableView: class {
    static var reuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView { }
extension UITableViewHeaderFooterView: ReusableView { }
extension UICollectionViewCell: ReusableView { }

extension UITableView {
    
    //MARK: Cells
    func registerReusable(_ cellClass: ReusableView.Type, fromNib: Bool = true) -> UITableView {
        if (fromNib) {
            let nib = UINib(nibName: cellClass.reuseIdentifier, bundle: nil)
            self.register(nib, forCellReuseIdentifier: cellClass.reuseIdentifier)
        } else {
            self.register(cellClass, forCellReuseIdentifier: cellClass.reuseIdentifier)
        }
        return self
    }
    
    func dequeueReusable<T: UITableViewCell>(_ indexPath: IndexPath) -> T where T: ReusableView {
        return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    //MARK: HeaderFooter
    func registerReusableHeaderFooterView(_ headerFooterViewClass: ReusableView.Type, fromNib: Bool = true) -> UITableView {
        if (fromNib) {
            let nib = UINib(nibName: headerFooterViewClass.reuseIdentifier, bundle: nil)
            self.register(nib, forHeaderFooterViewReuseIdentifier: headerFooterViewClass.reuseIdentifier)
        } else {
            self.register(headerFooterViewClass, forHeaderFooterViewReuseIdentifier: headerFooterViewClass.reuseIdentifier)
        }
        return self
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T? where T: ReusableView {
        return self.dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T
    }
}

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableView {
        self.register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableView, T: NibLoadableView {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        
        self.register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusable<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        
        return cell
    }    
}

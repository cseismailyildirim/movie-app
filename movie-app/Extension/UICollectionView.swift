//
//  UICollectionView.swift
//  movie-app
//
//  Created by ismailyildirim on 5.03.2021.
//

import Foundation
import UIKit

extension UICollectionView {
    
    public func register<T: UICollectionViewCell>(cellType: T.Type, bundle: Bundle? = nil) {
        let className =  String(describing: cellType)
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: className)
    }
    public func dequeueReusableCell<T: UICollectionViewCell>(with cellType: T.Type,
                                                             for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: String(describing:  cellType), for: indexPath) as! T
    }
}

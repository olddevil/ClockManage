//
//  UITableView+Extension.swift
//  HotPot
//
//  Created by olddevil on 2018/8/14.
//  Copyright © 2018 olddevil. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
//MARK: - UITableViewCell
    func registerCellNib<T: UITableViewCell>(aClass: T.Type) {
        let name = String(describing: aClass)
        let nib = UINib(nibName: name, bundle: nil)
        self.register(nib, forCellReuseIdentifier: name)
    }
    
    func registerCellClass<T: UITableViewCell>(aClass: T.Type) {
        let name = String(describing: aClass)
        self.register(aClass, forCellReuseIdentifier: name)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(aClass: T.Type) -> T {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableCell(withIdentifier: name) as? T else {
            fatalError("\(name) is not registed")
        }
        return cell
    }
    
//MARK: - UITableViewHeaderFooterView
    func registerHeaderFooterCellNib<T: UIView>(aClass: T.Type) {
        let name = String(describing: aClass)
        let nib = UINib(nibName: name, bundle: nil)
        self.register(nib, forHeaderFooterViewReuseIdentifier: name)
    }
    
    func registerHeaderFooterCellClass<T: UIView>(aClass: T.Type) {
        let name = String(describing: aClass)
        self.register(aClass, forHeaderFooterViewReuseIdentifier: name)
    }
    
    func dequeueReusableHeaderFooter<T: UIView>(aClass: T.Type) -> T {
        let name = String(describing: aClass)
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: name) as? T else {
            fatalError("\(name) is not registed")
        }
        return view
    }
}

//
//  Extensions.swift
//  ClassfiedsMVVM
//
//  Created by Filip Krzyzanowski on 26/12/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Activates constraints with visual format on given views
    /// - Parameter format: visual format for the constraints
    /// - Parameter views: views to which the constraints should apply
    func addConstraintWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    
    /// Adds UIActivityIndicatorView as a subview with constraints to center it in the X and Y axis of the superview. The colour is set to white and the indicator starts animating.
    /// - Parameter spinner: acitvity indicator to be added as subview
    func addSpinner(spinner: UIActivityIndicatorView) {
        addSubview(spinner)
        spinner.color = .white
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        spinner.startAnimating()
    }
    
    /// Removes the activity indicator from the superview
    func removeSpinner(spinner: UIActivityIndicatorView) {
        spinner.removeFromSuperview()
    }
    
}

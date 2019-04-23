//
//  Base.swift
//  AIDevLog
//
//  Created by iosdevlog on 2019/4/6.
//  Copyright © 2019 iosdevlog. All rights reserved.
//

import Foundation


/// Base class for all estimators
///
/// All estimators should specify all the parameters that can be set
/// at the class level in their `init` as explicit keyword
public class BaseEstimator: NSObject, Codable {
    /// Get parameters for this estimator.
    ///
    /// - Parameter deep: boolean, optional
    /// If True, will return the parameters for this estimator and
    /// contained subobjects that are estimators.
    /// - Returns: mapping of string to any
    /// Parameter names mapped to their values.
    func getParams(deep: Bool) -> String {
        let bookMirror = Mirror(reflecting: self)

        var result = ""
        for (name, value) in bookMirror.children {
            guard let name = name else { continue }
            result += "\(name):\t\(type(of: value))\t=\t\(value)\n"
        }

        return result
    }
    
    /// Set the parameters of this estimator.
    ///
    /// - Parameter params: The latter have parameters of the form
    /// `<component>__<parameter>` so that it's possible to update each
    /// component of a nested object.
    func setParams(params: [String: Any]) {
        setValuesForKeys(params)
    }
}

/// Mixin class for all classifiers
public protocol ClassifierMixin {
    /// Returns the mean accuracy on the given test data and labels.
    /// In multi-label classification, this is the subset accuracy
    /// which is a harsh metric since you require for each sample that
    /// each label set be correctly predicted.
    ///
    /// - Parameters:
    ///   - X: array-like, shape = (n_samples, n_features)
    /// Test samples.
    ///   - y: y : array-like, shape = (n_samples) or (n_samples, n_outputs)
    /// True labels for X.
    ///   - sample_weight:  array-like, shape = [n_samples], optional
    /// Sample weights.
    /// - Returns: score:
    /// Mean accuracy of self.predict(X) wrt. y.
    func score(X: Any, y: Any, sample_weight: Any) -> Double
}

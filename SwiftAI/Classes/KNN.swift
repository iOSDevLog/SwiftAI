//
//  KNN.swift
//  Pods-SwiftAI_Example
//
//  Created by developer on 4/23/19.
//

import Foundation
import Surge

/// Base class for Nearest neighbors classifier and regressor.
public class KNNBase: BaseEstimator {
    var k: Int = 1
    var distanceFunc: ([Double], [Double]) -> Double

    public init(k: Int, distanceFunc: @escaping ([Double], [Double]) -> Double) {
        assert(k > 0, "k must >= 1")
        self.k = k
        self.distanceFunc = distanceFunc
        super.init()
    }

    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

    func aggregate(neighborsTargets: [Double]) -> Double {
        fatalError("NotImplementedError")
    }

    override func _predict(XTest: Matrix<Double>) -> [Double] {
        let predictions = XTest.makeIterator().map {
            self._predict_x(xTest: Array($0))
        }

        return predictions
    }


    /// Predict the label of a single instance x.
    ///
    /// - Parameter x: predict x
    /// - Returns: predict label of x
    func _predict_x(xTest: [Double]) -> Double {
        // compute distances between x and all examples in the training set.
        let distances = self.X.makeIterator()
            .map { self.distanceFunc(xTest, Array($0)) }

        // Sort all examples by their distance to x and keep their target value.
        let neighbors = zip(distances, self.y)
            .sorted { $0.0 < $1.0 }
            .prefix(k)
        NotificationCenter.default.post(name: Notification.kNN, object: (xTest, neighbors.first!), userInfo: nil)

        // Get targets of the k-nn and aggregate them (most common one or average).
        let neighborsTargets = neighbors
            .map { $0.1 }

        return self.aggregate(neighborsTargets: neighborsTargets)
    }
}

/// Nearest neighbors classifier.
///
/// Note: if there is a tie for the most common label among the neighbors, then
/// the predicted label is arbitrary.
public class KNNClassifier: KNNBase {

    /// Return the most common target label.
    ///
    /// - Parameter neighborsTargets: neighborsTargets
    /// - Returns: Return the most common target label.
    override func aggregate(neighborsTargets: [Double]) -> Double {
        let countedSet = NSCountedSet(array: neighborsTargets)
        let label = countedSet.allObjects.sorted {
            countedSet.count(for: $0) > countedSet.count(for: $1)
        }.first! as! Double

        return label
    }
}

/// Nearest neighbors regressor.
public class KNNRegressor: KNNBase {

    /// Return the mean of all targets.
    ///
    /// - Parameter neighborsTargets: neighborsTargets
    /// - Returns: Return the mean of all targets.
    override func aggregate(neighborsTargets: [Double]) -> Double {
        return mean(neighborsTargets)
    }
}

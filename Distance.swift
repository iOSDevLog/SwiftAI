//
//  Distance.swift
//  Pods-SwiftAI_Example
//
//  Created by developer on 4/23/19.
//

import Foundation
import Accelerate
import Surge

/// Computes the Euclidean distance between two 1-D arrays.
///
/// The Euclidean distance between 1-D arrays `u` and `v`, is defined as
///
/// .. math::
///
/// {||u-v||}_2
///
/// \\left(\\sum{(w_i |(u_i - v_i)|^2)}\\right)^{1/2}
///
/// Parameters
/// ----------
/// u : (N,) array_like
/// Input array.
/// v : (N,) array_like
/// Input array.
/// w : (N,) array_like, optional
/// The weights for each value in `u` and `v`. Default is None,
/// which gives each value a weight of 1.0
///
/// Returns
/// -------
/// euclidean : double
/// The Euclidean distance between vectors `u` and `v`.
///
/// Examples
/// --------
/// >>> from scipy.spatial import distance
/// >>> distance.euclidean([1, 0, 0], [0, 1, 0])
/// 1.4142135623730951
/// >>> distance.euclidean([1, 1, 0], [0, 1, 0])
/// 1.0
public func euclidean(u: [Double], v: [Double], w: [Double]) -> Double {
    return minkowski(u: u, v: v, p: 2, w: w)
}

public func euclidean(u: [Double], v: [Double]) -> Double {
    return minkowski(u: u, v: v, p: 2, w: nil)
}

/// Compute the Minkowski distance between two 1-D arrays.
///
/// The Minkowski distance between 1-D arrays `u` and `v`,
/// is defined as
///
/// .. math::
///
/// {||u-v||}_p = (\\sum{|u_i - v_i|^p})^{1/p}.
///
///
/// \\left(\\sum{w_i(|(u_i - v_i)|^p)}\\right)^{1/p}.
///
/// Parameters
///     ----------
/// u : (N,) array_like
/// Input array.
/// v : (N,) array_like
/// Input array.
/// p : int
/// The order of the norm of the difference :math:`{||u-v||}_p`.
/// w : (N,) array_like, optional
/// The weights for each value in `u` and `v`. Default is None,
/// which gives each value a weight of 1.0
///
/// Returns
/// -------
/// minkowski : double
/// The Minkowski distance between vectors `u` and `v`.
///
/// Examples
/// --------
/// >>> from scipy.spatial import distance
/// >>> distance.minkowski([1, 0, 0], [0, 1, 0], 1)
/// 2.0
///     >>> distance.minkowski([1, 0, 0], [0, 1, 0], 2)
/// 1.4142135623730951
///     >>> distance.minkowski([1, 0, 0], [0, 1, 0], 3)
/// 1.2599210498948732
///     >>> distance.minkowski([1, 1, 0], [0, 1, 0], 1)
/// 1.0
///     >>> distance.minkowski([1, 1, 0], [0, 1, 0], 2)
/// 1.0
///     >>> distance.minkowski([1, 1, 0], [0, 1, 0], 3)
/// 1.0
func minkowski(u: [Double], v: [Double], p: Int = 2, w: [Double]? = nil) -> Double {
    assert(p >= 1, "p must be at least 1")

    var u_v = u - v
    if let w = w {
        var root_w: [Double]!
        if p == 1 {
            root_w = w
        }
        if p == 2 {
            ///  better precision and speed
            root_w = sqrt(w)
        }
        else {
            root_w = pow(w, Double(1 / p))
        }
        u_v = root_w * u_v
    }

    let dist = norm(array: u_v, ord: p)
    return dist
}

/// vector norm.
/// /
/// This function is able to return one of an infinite number of array norms
/// (described below), depending on the value of the ``ord`` parameter.
/// The following norms can be calculated:
/// /
/// =====  ============================  ==========================
/// ord    norm for matrices             norm for vectors
/// =====  ============================  ==========================
/// None   Frobenius norm                2-norm
/// 'fro'  Frobenius norm                --
/// inf    max(sum(abs(x), axis=1))      max(abs(x))
/// -inf   min(sum(abs(x), axis=1))      min(abs(x))
/// 0      --                            sum(x != 0)
/// 1      max(sum(abs(x), axis=0))      as below
/// -1     min(sum(abs(x), axis=0))      as below
/// 2      2-norm (largest sing. value)  as below
/// -2     smallest singular value       as below
/// other  --                            sum(abs(x)**ord)**(1./ord)
/// =====  ============================  ==========================
/// /
/// - Parameters:
///   - v: Input array
///   - ord: Order of the norm
/// - Returns: Norm of the array
public func norm(array: [Double], ord: Int) -> Double {
    let p = Double(ord)
    let arr = Array(array
            .map { abs($0) }
            .map { $0 ** p })
    let s = sum(arr)
    return s ** (1 / p)
}

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator **: PowerPrecedence
func ** (radix: Double, power: Double) -> Double {
    return pow(Double(radix), Double(power))
}

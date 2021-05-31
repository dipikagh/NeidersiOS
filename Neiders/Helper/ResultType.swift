//
//  ResultType.swift
//  TCSTransit
//
//  Created by Palash Das, Appsbee LLC on 13/10/20.
//  Copyright © 2020 Intelebee LLC. All rights reserved.
//

import Foundation

/// Default type of `Result`  with an `Error` `Failure` type.
public typealias NeidersResult<Success> = Result<Success, Error>

// MARK: - Internal APIs

extension Result {
    /// Returns whether the instance is `.success`.
    var isSuccess: Bool {
        guard case .success = self else { return false }
        return true
    }

    /// Returns whether the instance is `.failure`.
    var isFailure: Bool {
        !isSuccess
    }

    /// Returns the associated value if the result is a success, `nil` otherwise.
    var success: Success? {
        guard case let .success(value) = self else { return nil }
        return value
    }

    /// Returns the associated error value if the result is a failure, `nil` otherwise.
    var failure: Failure? {
        guard case let .failure(error) = self else { return nil }
        return error
    }

    /// Initializes a `Result` from value or error. Returns `.failure` if the error is non-nil, `.success` otherwise.
    ///
    /// - Parameters:
    ///   - value: A value.
    ///   - error: An `Error`.
    init(value: Success, error: Failure?) {
        if let error = error {
            self = .failure(error)
        } else {
            self = .success(value)
        }
    }
}

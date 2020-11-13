//
//  ADEFingerDetailDelegate.swift
//  Adelaide
//
//  Created by Charles on 2020/11/13.
//

import Foundation

@objc public protocol ADEFringerDetailDelegate {
    func clickLike(fingerId: String, complection: @escaping (String, String) -> Void)
    func clickDislike(fingerId: String, complection: @escaping (String, String) -> Void)
    func clickInsterested(fingerId: String, name: String)
}

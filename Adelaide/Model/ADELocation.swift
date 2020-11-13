//
//  ADELocationModel.swift
//  Adelaide
//
//  Created by Charles on 2020/11/12.
//

import UIKit

@objcMembers
class ADELocation: NSObject {
    var id: String = ""
    var name: String = ""
    var latitude: Double = 0
    var longitude: Double = 0
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

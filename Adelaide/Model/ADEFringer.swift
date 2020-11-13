//
//  ADEFringer.swift
//  Adelaide
//
//  Created by Charles on 2020/11/12.
//

import UIKit

@objcMembers
class ADEFringer: NSObject {
    var id: String = ""
    var name: String = ""
    var artist: String = ""
    var venue: String = ""
    var likes: String = ""
    var dislikes: String = ""
    var image: String = ""
    var latitude: Double = 0
    var longitude: Double = 0
    var width: CGFloat = 0
    var height: CGFloat = 0
    var desc: String = ""
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

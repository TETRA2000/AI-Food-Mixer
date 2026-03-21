//
//  Item.swift
//  AI Food Mixer
//
//  Created by Takahiko Inayama on 2026/3/22.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

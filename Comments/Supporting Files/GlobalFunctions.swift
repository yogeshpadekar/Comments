//
//  GlobalFunctions.swift
//  Comments
//
//  Created by Yogesh Padekar on 04/10/20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import Foundation

/// Function to print logs in debug mode only
/// - Parameter items: Items to print
func debugLog(_ items: Any) {
    if _isDebugAssertConfiguration() {
        print(items)
    }
}

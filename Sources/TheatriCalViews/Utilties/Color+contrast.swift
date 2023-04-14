//
//  Color+contrast.swift
//  
//
//  Created by Scott Matthewman on 13/04/2023.
//

import SwiftUI

extension Color {
    var contrastColor: Color {
        Color(uiColor: UIColor(self).contrastingColor())
    }
}

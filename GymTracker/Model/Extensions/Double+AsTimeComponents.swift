//
//  Double+AsTimeComponents.swift
//  GymTracker
//
//  Created by Adam Tokarski on 10/03/2025.
//

import Foundation

extension Double {
	var asTimeComponents: String {
		let tmpHours = Int(self) / 3600
		let tmpMinutes = (Int(self) - tmpHours * 3600) / 60
		let tmpSeconds = Int(self) - tmpHours * 3600 - tmpMinutes * 60
		
		if tmpHours > 0 {
			return String(format: "%d:%02d:%02d", tmpHours, tmpMinutes, tmpSeconds)
		} else {
			return String(format: "%d:%02d", tmpMinutes, tmpSeconds)
		}
	}
}

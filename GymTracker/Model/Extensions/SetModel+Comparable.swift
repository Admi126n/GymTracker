//
//  SetModel+Comparable.swift
//  GymTracker
//
//  Created by Adam Tokarski on 08/03/2025.
//

import Foundation

extension SetModel: Comparable {
	static func < (lhs: SetModel, rhs: SetModel) -> Bool {
		if lhs.mainStat == .speed {
			return lhs.mainStatValue > rhs.mainStatValue
		} else {
			return lhs.mainStatValue < rhs.mainStatValue
		}
	}
}

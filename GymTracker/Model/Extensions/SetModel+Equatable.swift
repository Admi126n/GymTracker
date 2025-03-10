//
//  SetModel+Equatable.swift
//  GymTracker
//
//  Created by Adam Tokarski on 08/03/2025.
//

import Foundation

extension SetModel: Equatable {
	static func == (lhs: SetModel, rhs: SetModel) -> Bool {
		lhs.mainStat == rhs.mainStat &&
		lhs.stats == rhs.stats &&
		lhs.timestamp == rhs.timestamp
	}
}

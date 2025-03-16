//
//  ExerciseRecordCell.swift
//  GymTracker
//
//  Created by Adam Tokarski on 08/03/2025.
//

import SwiftUI

struct ExerciseRecordCell: View {
	
	let exerciseRecord: ExerciseRecord
	
	var body: some View {
		VStack(alignment: .leading) {
			Text(exerciseRecord.name)
				.frame(maxWidth: .infinity, alignment: .leading)
				.fontWeight(.bold)
			
			if exerciseRecord.mainStat.isTimeReleated {
				(Text("Record: ") +
				 Text(exerciseRecord.record.asTimeComponents))
				.font(.subheadline)
			} else {
				(Text("Record: ") +
				 Text(exerciseRecord.record, format: .number) +
				 Text(" \(exerciseRecord.mainStat.unit)"))
					.font(.subheadline)
			}
			
			if !exerciseRecord.optionalStats.isEmpty {
				(Text("Optional stats: ") +
				 Text(ListFormatter.localizedString(byJoining: exerciseRecord.optionalStats.map { $0.rawValue })))
				.font(.footnote)
			}
			
		}
		.padding(8)
		.background(HierarchicalShapeStyle.quaternary)
		.clipShape(.rect(cornerRadius: 15, style: .continuous))
	}
}
#Preview {
	ExerciseRecordCell(exerciseRecord: ExerciseRecord(
		uuid: "",
		name: "Push ups",
		mainStat: .repetitions,
		record: 20,
		seatHeight: nil,
		additionalStats: [.weight],
		recordDate: .now))
}

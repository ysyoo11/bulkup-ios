//
//  InstructionView.swift
//  BulkUp
//
//  Created by Suji Lee on 5/9/24.
//

import SwiftUI

struct InstructionView: View {
    @ObservedObject var vm = ExerciseListViewModel()
    let viewModel = SharedViewModel()
    let exerciseName: String //밖에서 받아온것
    @State private var selectedExercise: ExerciseModel?

    var body: some View {

        if let selectedExercise = vm.exercises.first(where: { $0.name == exerciseName }){
            Text("\(selectedExercise.name) (\(selectedExercise.tool))").font(.headline)

            Image(selectedExercise.imageName)
                .resizable()
                .scaledToFill()
                .frame(width:400, height:300)
                .clipped()
            HStack{
                Text("Instructions").padding().font(.title)
                Spacer()
            }
            ScrollView{
                Text("\(selectedExercise.instruction)").padding()
                Spacer()
            }
        } else {
            Text("Could not find exercise named: \(exerciseName)")
        }

            }
    }

#Preview {
    InstructionView(exerciseName: "Bicep Curl")
}

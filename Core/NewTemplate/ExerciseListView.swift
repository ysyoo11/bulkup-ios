//
//  ListView.swift
//  BulkUp
//
//  Created by Suji Lee on 5/8/24.
//
import SwiftUI

struct ExerciseListView: View {
    @ObservedObject var vm = ExerciseListViewModel()
    @ObservedObject var sharedVM: SharedViewModel
    @State private var showInstruction: Bool = false

    var body: some View {
        VStack {
            ScrollView {
                ForEach(vm.exercises) { exercise in
                    HStack {
                        Image(exercise.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipped()
                            .padding(.trailing, 20)

                        VStack(alignment: .leading, spacing: 0) {
                            VStack(alignment: .leading, spacing: 20){
                                Text(exercise.name)
                                    .font(.headline)
                                    .padding(.top)

                                Text(exercise.bodyPart)
                                    .font(.body)
                                    .foregroundColor(Color.gray)
                            }
                            Spacer()
                            HStack{
                                Spacer()
                                Button {
                                    vm.addExercise(exercise)
                                    vm.selectedExercises.append(exercise)
                                } label: {
                                    HStack{
                                        Image(systemName: "plus.circle")
                                    }
                                }
                                .background(Color.secondaryBlue)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .foregroundStyle(.cyan)
                                .shadow(color: Color.black.opacity(0.2), radius: 1, x: 1, y: 1)


                                Button(action: { showInstruction.toggle() }, label: {
                                    HStack{
                                        Image(systemName: "questionmark.circle")
                                    }
                                    .background(Color.secondaryBlue)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .foregroundStyle(.cyan)
                                    .shadow(color: Color.black.opacity(0.2), radius: 1, x: 1, y: 1)
                                }).sheet(isPresented: $showInstruction, content: {
                                    InstructionView(exerciseName: exercise.name)
                                        .presentationDetents([.large, .medium, .fraction(0.75)])
                                })
                            }
                        }
                        Spacer()
                    }
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(.secondaryGray), lineWidth: 2)
                    )
                    .padding(.vertical, 4)
                    .padding(.horizontal)
                }
            }
        }
        .padding(.top,20)
    }
}

#Preview {
    ExerciseListView(sharedVM: SharedViewModel())
}

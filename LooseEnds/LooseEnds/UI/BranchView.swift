//
//  BranchView.swift
//  LooseEnds
//
//  Created by Javier Heisecke on 2024-11-28.
//

import SwiftUI

// MARK: - Branch View

struct BranchView: View {
    @State var firstTaskBox: CGPoint = CGPoint()
    @State var lastTaskBox: CGPoint = CGPoint()
    @State var firstUncompletedTaskBox: CGPoint?
    @State var nextTask: LooseEnd?

    @State private var tasks: [LooseEnd] = [
        LooseEnd(completed: true),
        LooseEnd(completed: false),
        LooseEnd(completed: false),
        LooseEnd(completed: false)
    ]

    var body: some View {
        ZStack {
            Path { path in
                path.move(to: firstTaskBox)
                path.addLine(to: lastTaskBox)
            }
            .stroke(pathGradient(), lineWidth: 4)
            VStack(spacing: 50) {
                ForEach($tasks, id: \.id) { task in
                    CircleTask(completed: task.completed, canComplete: canComplete(task.wrappedValue))
                        .overlay(AbsolutePositionReader(task.wrappedValue.id.uuidString))
                }
            }
            .onPreferenceChange(AbsolutePositionKey.self) { preferences in
                for pref in preferences {
                    if pref.id == tasks.first?.id.uuidString {
                        firstTaskBox = pref.absolutePosition
                    } else if pref.id == tasks.last?.id.uuidString {
                        lastTaskBox = pref.absolutePosition
                    }
                    guard firstUncompletedTaskBox != nil else { continue }
                    if pref.id == nextTask?.id.uuidString {
                        firstUncompletedTaskBox = CGPoint(x: pref.absolutePosition.x, y: pref.absolutePosition.y)
                    }
                }
            }
        }
        .coordinateSpace(name: AbsolutePositionReader.spaceName)
        .onAppear {
            nextTask = tasks.first(where: { !$0.completed })
        }
    }

    private func canComplete(_ task: LooseEnd) -> Bool {
        guard !task.completed else { return false }
        if let currentIndex = tasks.firstIndex(where: { $0.id == task.id }),
           currentIndex == tasks.firstIndex(where: { !$0.completed }) {
            return true
        }
        return false
    }

    private func pathGradient() -> LinearGradient {
        return LinearGradient(
            stops: [
                Gradient.Stop(color: .cyan, location: 0.55),
                Gradient.Stop(color: .gray, location: 0.1)
            ],
            startPoint: .bottom,
            endPoint: .top
        )
    }
}

// MARK: - Circle Task

struct CircleTask: View {
    let diameter: CGFloat = 30
    @Binding var completed: Bool
    let canComplete: Bool

    var body: some View {
        Circle()
            .frame(width: diameter, height: diameter)
            .foregroundStyle(completed ? .cyan : .gray)
            .onTapGesture {
                guard canComplete else { return }
                withAnimation {
                    completed = true
                }
            }
    }
}

// MARK: - Types

class LooseEnd: ObservableObject {
    let id = UUID()
    @Published var completed: Bool

    init(completed: Bool) {
        self.completed = completed
    }
}

#Preview {
    BranchView()
}

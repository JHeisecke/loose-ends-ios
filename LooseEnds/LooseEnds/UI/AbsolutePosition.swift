//
//  AbsolutePosition.swift
//  LooseEnds
//
//  Created by Javier Heisecke on 2024-11-28.
//
import SwiftUI

struct AbsolutePositionReader: View {
    let id: String?
    init() { self.id = nil }
    init(_ id: String?) { self.id = id }
    static let spaceName = "AbsolutePositionReaderSpace"

    var body: some View {
        GeometryReader { metrics in
            let absolutePosition = CGPoint(
                x: metrics.frame(in: .named(AbsolutePositionReader.spaceName)).midX,
                y: metrics.frame(in: .named(AbsolutePositionReader.spaceName)).midY
            )
            
            Rectangle()
                .fill(Color.clear)
                .preference(
                    key: AbsolutePositionKey.self,
                    value: [AbsolutePositionValue(id: id, absolutePosition: absolutePosition)]
                )
        }
    }
}

struct AbsolutePositionValue: Equatable {
    let id: String?
    let absolutePosition: CGPoint
}

struct AbsolutePositionKey: PreferenceKey {
    typealias Value = [AbsolutePositionValue]
    static var defaultValue: [AbsolutePositionValue] = []
    static func reduce(value: inout [AbsolutePositionValue], nextValue: () -> [AbsolutePositionValue]) {
        value.append(contentsOf: nextValue())
    }
}

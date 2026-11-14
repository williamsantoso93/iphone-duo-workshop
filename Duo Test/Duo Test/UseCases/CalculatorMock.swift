import SwiftUI

/// A single-page, bottom-heavy calculator that opts out of vertical bars to use the whole width,
/// and keeps its keypad clear of the edge where a vertical bar would sit.
struct CalculatorMock: View {
    @State private var display = "0"
    @State private var accumulator: Double?
    @State private var pending: Operation?
    @State private var startsNewEntry = true
    @Environment(\.toolbarVerticalEdge) private var toolbarVerticalEdge
    @ScaledMetric(relativeTo: .largeTitle) private var displaySize = 72.0

    private enum Operation: String {
        case add = "+", subtract = "−", multiply = "×", divide = "÷"

        func apply(_ lhs: Double, _ rhs: Double) -> Double {
            switch self {
            case .add: lhs + rhs
            case .subtract: lhs - rhs
            case .multiply: lhs * rhs
            case .divide: rhs == 0 ? .nan : lhs / rhs
            }
        }
    }

    private let rows: [[String]] = [
        ["AC", "±", "%", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "−"],
        ["1", "2", "3", "+"],
        ["0", ".", "="],
    ]

    /// Extra room on whichever edge the vertical bar uses, so keys never sit under it.
    private var barInsets: EdgeInsets {
        switch toolbarVerticalEdge {
        case .leading: EdgeInsets(top: 0, leading: Metrics.spacing * 2, bottom: 0, trailing: 0)
        case .trailing: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: Metrics.spacing * 2)
        default: EdgeInsets()
        }
    }

    var body: some View {
        VStack(spacing: 10) {
            Spacer(minLength: 0)
            Text(display)
                .font(.system(size: displaySize, weight: .light))
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.4)
                .contentTransition(.numericText())
                .frame(maxWidth: .infinity, alignment: .trailing)
                .accessibilityLabel("Result")
                .accessibilityValue(display)
            Grid(horizontalSpacing: 10, verticalSpacing: 10) {
                ForEach(rows, id: \.self) { row in
                    GridRow {
                        ForEach(row, id: \.self) { key in
                            keyButton(key)
                                .gridCellColumns(key == "0" ? 2 : 1)
                        }
                    }
                }
            }
        }
        .padding(Metrics.spacing)
        .padding(barInsets)
        .foregroundStyle(.white)
        .background(.black)
        .toolbarVerticalBehavior(.disabled)
        .floatingCloseButton()
    }

    private func keyButton(_ key: String) -> some View {
        let isOperator = Operation(rawValue: key) != nil || key == "="
        let isFunction = ["AC", "±", "%"].contains(key)
        return Button {
            press(key)
        } label: {
            Text(key)
                .font(.title.weight(.medium))
                .frame(maxWidth: .infinity, minHeight: 64)
        }
        .buttonStyle(.plain)
        .background(isOperator ? Color.orange : isFunction ? Color(white: 0.65) : Color(white: 0.2), in: .capsule)
        .foregroundStyle(isFunction ? .black : .white)
    }

    private func press(_ key: String) {
        switch key {
        case "AC":
            display = "0"
            accumulator = nil
            pending = nil
            startsNewEntry = true
        case "±":
            if display != "0" {
                display = display.hasPrefix("-") ? String(display.dropFirst()) : "-" + display
            }
        case "%":
            show(value / 100)
        case ".":
            if startsNewEntry {
                display = "0."
                startsNewEntry = false
            } else if !display.contains(".") {
                display += "."
            }
        case "=":
            evaluate()
            pending = nil
        default:
            if let operation = Operation(rawValue: key) {
                evaluate()
                pending = operation
            } else {
                display = startsNewEntry || display == "0" ? key : display + key
                startsNewEntry = false
            }
        }
    }

    private var value: Double {
        Double(display) ?? 0
    }

    private func evaluate() {
        if let pending, let accumulator, !startsNewEntry {
            show(pending.apply(accumulator, value))
        }
        accumulator = value
        startsNewEntry = true
    }

    private func show(_ number: Double) {
        display = number.isFinite ? number.formatted(.number.precision(.significantDigits(1...10)).grouping(.never)) : "Error"
        startsNewEntry = true
    }
}

#Preview {
    CalculatorMock()
}

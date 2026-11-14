import SwiftUI

/// Apple's three readiness steps plus the team's own iPhone Duo checklist.
struct ReadinessView: View {
    @State private var done: Set<String> = []

    private var total: Int { Catalog.readiness.count + Catalog.duoChecklist.count }
    private var allDone: Bool { done.count == total }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Gauge(value: Double(done.count), in: 0...Double(total)) {
                        Text("Ready for iPhone Duo")
                    } currentValueLabel: {
                        Text("\(done.count) of \(total)")
                            .monospacedDigit()
                            .contentTransition(.numericText())
                    }
                    .tint(allDone ? .green : .accentColor)
                }

                ForEach(1...3, id: \.self) { step in
                    Section("Step \(step)") {
                        ForEach(Catalog.readiness.filter { $0.step == step }) { item in
                            ReadinessRow(item: item, isDone: $done[contains: item.id])
                        }
                    }
                }

                Section("iPhone Duo checklist") {
                    ForEach(Catalog.duoChecklist, id: \.self) { line in
                        Toggle(isOn: $done[contains: line]) {
                            Text(LocalizedStringKey(line))
                        }
                        .toggleStyle(.checklist)
                    }
                }
            }
            .navigationTitle("Readiness")
            .animation(Motion.standard, value: done)
            .sensoryFeedback(.success, trigger: allDone) { _, isDone in isDone }
        }
    }
}

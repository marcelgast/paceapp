// Pace home-screen widget.
//
// Reads data the Flutter app writes via home_widget into the shared App Group
// "group.de.mgstudios.pace". The stint timer self-updates via SwiftUI's timer
// text. Tapping the Boxenstopp button deep-links into the app (pace://boxenstopp)
// which opens the pit-stop form directly.

import WidgetKit
import SwiftUI

private let kAppGroup = "group.de.mgstudios.pace"
private let kBoxenstopp = URL(string: "pace://boxenstopp")
private let kOpen = URL(string: "pace://open")

private let magenta = Color(red: 1.0, green: 0.18, blue: 0.58)
private let purple = Color(red: 0.6, green: 0.35, blue: 1.0)
private let cyan = Color(red: 0.10, green: 0.88, blue: 1.0)
private let lime = Color(red: 0.22, green: 1.0, blue: 0.42)

struct PaceEntry: TimelineEntry {
    let date: Date
    let isBaseline: Bool
    let timerRef: Date
    let best: String
    let savedMoney: String
    let car: String
}

struct PaceProvider: TimelineProvider {
    func placeholder(in context: Context) -> PaceEntry {
        PaceEntry(date: Date(), isBaseline: false,
                  timerRef: Date().addingTimeInterval(1800),
                  best: "4 h 12 min", savedMoney: "12,40 €", car: "Rostlaube")
    }

    func getSnapshot(in context: Context, completion: @escaping (PaceEntry) -> Void) {
        completion(read())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PaceEntry>) -> Void) {
        let entry = read()
        var entries = [entry]
        if !entry.isBaseline && entry.timerRef > Date() {
            entries.append(PaceEntry(date: entry.timerRef, isBaseline: false,
                                     timerRef: entry.timerRef, best: entry.best,
                                     savedMoney: entry.savedMoney, car: entry.car))
        }
        let refresh = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date().addingTimeInterval(900)
        completion(Timeline(entries: entries, policy: .after(refresh)))
    }

    private func read() -> PaceEntry {
        let d = UserDefaults(suiteName: kAppGroup)
        let isBaseline = (d?.string(forKey: "is_baseline") ?? "1") == "1"
        let ms = d?.double(forKey: "timer_ref_ms") ?? 0
        let ref = ms > 0 ? Date(timeIntervalSince1970: ms / 1000.0) : Date()
        return PaceEntry(date: Date(), isBaseline: isBaseline, timerRef: ref,
                         best: d?.string(forKey: "best_label") ?? "—",
                         savedMoney: d?.string(forKey: "saved_money") ?? "—",
                         car: d?.string(forKey: "car_name") ?? "Rostlaube")
    }
}

struct PaceWidgetEntryView: View {
    @Environment(\.widgetFamily) private var family
    var entry: PaceEntry

    private var overtime: Bool { !entry.isBaseline && entry.timerRef <= entry.date }
    private var accent: Color { entry.isBaseline ? cyan : (overtime ? lime : cyan) }
    private var label: String {
        entry.isBaseline ? "AKTUELL" : (overtime ? "OVERTIME" : "NÄCHSTER STINT")
    }

    var body: some View {
        if family == .systemMedium {
            HStack(alignment: .top, spacing: 14) {
                VStack(alignment: .leading, spacing: 3) {
                    header
                    Spacer(minLength: 0)
                    timerBlock(size: 30)
                    Spacer(minLength: 0)
                    Link(destination: kBoxenstopp ?? URL(string: "pace://boxenstopp")!) {
                        boxenstoppButton
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                statsColumn.frame(maxWidth: .infinity, alignment: .leading)
            }
            .widgetURL(kOpen)
        } else {
            VStack(alignment: .leading, spacing: 4) {
                header
                Spacer(minLength: 0)
                timerBlock(size: 26)
                Spacer(minLength: 0)
                boxenstoppButton
            }
            .widgetURL(kBoxenstopp)
        }
    }

    private var header: some View {
        HStack {
            Text("PACE").font(.system(size: 15, weight: .heavy, design: .rounded)).italic()
                .foregroundColor(.white)
            Spacer()
            Image(systemName: "flame.fill").foregroundColor(magenta).font(.system(size: 11))
        }
    }

    private func timerBlock(size: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(label).font(.system(size: 10, weight: .bold)).tracking(1.5).foregroundColor(accent)
            Text(entry.timerRef, style: .timer)
                .font(.system(size: size, weight: .heavy, design: .rounded))
                .foregroundColor(accent).monospacedDigit().lineLimit(1).minimumScaleFactor(0.7)
        }
    }

    private var boxenstoppButton: some View {
        HStack(spacing: 5) {
            Image(systemName: "flame.fill").font(.system(size: 11, weight: .bold))
            Text("BOXENSTOPP").font(.system(size: 11, weight: .heavy)).tracking(0.5)
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(LinearGradient(colors: [magenta, purple, cyan],
                                   startPoint: .leading, endPoint: .trailing))
        .clipShape(Capsule())
    }

    private var statsColumn: some View {
        VStack(alignment: .leading, spacing: 10) {
            miniStat("WAGEN", entry.car, .white)
            miniStat("BESTZEIT", entry.best, cyan)
            miniStat("GESPART", entry.savedMoney, lime)
        }
        .padding(.top, 2)
    }

    private func miniStat(_ title: String, _ value: String, _ color: Color) -> some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(title).font(.system(size: 9, weight: .bold)).tracking(1).foregroundColor(.gray)
            Text(value).font(.system(size: 16, weight: .heavy, design: .rounded))
                .foregroundColor(color).lineLimit(1).minimumScaleFactor(0.7)
        }
    }
}

@main
struct PaceWidget: Widget {
    let kind = "PaceWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PaceProvider()) { entry in
            if #available(iOS 17.0, *) {
                PaceWidgetEntryView(entry: entry)
                    .containerBackground(for: .widget) {
                        LinearGradient(
                            colors: [Color(red: 0.07, green: 0.06, blue: 0.09),
                                     Color(red: 0.10, green: 0.09, blue: 0.13)],
                            startPoint: .top, endPoint: .bottom)
                    }
            } else {
                PaceWidgetEntryView(entry: entry).padding(14)
            }
        }
        .configurationDisplayName("Pace")
        .description("Stint-Timer, Bestzeit, Gespart — und ein Boxenstopp-Knopf.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

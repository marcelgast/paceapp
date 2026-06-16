// Pace home-screen widget.
//
// Reads data the Flutter app writes via home_widget into the shared App Group
// "group.de.mgstudios.pace". The stint timer self-updates via SwiftUI's timer
// text. Tapping the Boxenstopp button deep-links into the app (pace://boxenstopp)
// which opens the pit-stop form directly.

import WidgetKit
import SwiftUI
import ActivityKit

private let kAppGroup = "group.de.mgstudios.pace"
private let kBoxenstopp = URL(string: "pace://boxenstopp")
private let kOpen = URL(string: "pace://open")

private let magenta = Color(red: 1.0, green: 0.18, blue: 0.58)
private let purple = Color(red: 0.6, green: 0.35, blue: 1.0)
private let cyan = Color(red: 0.10, green: 0.88, blue: 1.0)
private let lime = Color(red: 0.22, green: 1.0, blue: 0.42)
private let orange = Color(red: 1.0, green: 0.48, blue: 0.12)

struct PaceEntry: TimelineEntry {
    let date: Date
    let isBaseline: Bool
    let timerRef: Date
    let best: String
    let savedMoney: String
    let car: String
    let streak: Int
    let carImagePath: String?
}

struct PaceProvider: TimelineProvider {
    func placeholder(in context: Context) -> PaceEntry {
        PaceEntry(date: Date(), isBaseline: false,
                  timerRef: Date().addingTimeInterval(1800),
                  best: "4 h 12 min", savedMoney: "12,40 €", car: "Rostlaube",
                  streak: 3, carImagePath: nil)
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
                                     savedMoney: entry.savedMoney, car: entry.car,
                                     streak: entry.streak,
                                     carImagePath: entry.carImagePath))
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
                         car: d?.string(forKey: "car_name") ?? "Rostlaube",
                         streak: d?.integer(forKey: "streak") ?? 0,
                         carImagePath: d?.string(forKey: "car_image"))
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
        HStack(spacing: 4) {
            Text("PACE").font(.system(size: 15, weight: .heavy, design: .rounded)).italic()
                .foregroundColor(.white)
            Spacer()
            Image(systemName: "flame.fill").foregroundColor(orange).font(.system(size: 12))
            Text("\(entry.streak)")
                .font(.system(size: 14, weight: .heavy, design: .rounded))
                .foregroundColor(orange)
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
        VStack(alignment: .leading, spacing: 6) {
            if let path = entry.carImagePath, let img = UIImage(contentsOfFile: path) {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: 72)
            }
            Text(entry.car)
                .font(.system(size: 12, weight: .heavy, design: .rounded))
                .foregroundColor(.white).lineLimit(1).minimumScaleFactor(0.7)
            HStack(alignment: .top, spacing: 12) {
                miniStat("BESTZEIT", entry.best, cyan)
                miniStat("GESPART", entry.savedMoney, lime)
            }
        }
    }

    private func miniStat(_ title: String, _ value: String, _ color: Color) -> some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(title).font(.system(size: 9, weight: .bold)).tracking(1).foregroundColor(.gray)
            Text(value).font(.system(size: 16, weight: .heavy, design: .rounded))
                .foregroundColor(color).lineLimit(1).minimumScaleFactor(0.7)
        }
    }
}

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

// ---- Live Activity (Pro) -------------------------------------------------
//
// Mirrors the running stint to the Dynamic Island and lock screen. Dynamic
// values are written by the `live_activities` Flutter plugin into the shared
// App Group under "<activityId>_<key>", read here via `prefixedKey`.

struct LiveActivitiesAppAttributes: ActivityAttributes, Identifiable {
    public struct ContentState: Codable, Hashable {}
    var id = UUID()
}

extension LiveActivitiesAppAttributes {
    func prefixedKey(_ key: String) -> String { "\(id)_\(key)" }
}

private let liveDefaults = UserDefaults(suiteName: kAppGroup)

@available(iOS 16.1, *)
private func liveStr(_ ctx: ActivityViewContext<LiveActivitiesAppAttributes>, _ key: String) -> String {
    liveDefaults?.string(forKey: ctx.attributes.prefixedKey(key)) ?? ""
}

@available(iOS 16.1, *)
private func liveInt(_ ctx: ActivityViewContext<LiveActivitiesAppAttributes>, _ key: String) -> Int {
    Int(liveStr(ctx, key)) ?? 0
}

@available(iOS 16.1, *)
private func liveTimerRef(_ ctx: ActivityViewContext<LiveActivitiesAppAttributes>) -> Date {
    let ms = Double(liveStr(ctx, "timerRefMs")) ?? 0
    return ms > 0 ? Date(timeIntervalSince1970: ms / 1000.0) : Date()
}

@available(iOS 16.1, *)
private func liveBaseline(_ ctx: ActivityViewContext<LiveActivitiesAppAttributes>) -> Bool {
    liveStr(ctx, "isBaseline") == "true"
}

@available(iOS 16.1, *)
private func liveAccent(_ ctx: ActivityViewContext<LiveActivitiesAppAttributes>) -> Color {
    let overtime = !liveBaseline(ctx) && liveTimerRef(ctx) <= Date()
    return overtime ? lime : cyan
}

@available(iOS 16.1, *)
private func liveLabel(_ ctx: ActivityViewContext<LiveActivitiesAppAttributes>) -> String {
    if liveBaseline(ctx) { return "MESSRUNDE" }
    return liveTimerRef(ctx) <= Date() ? "OVERTIME" : "NÄCHSTER STINT"
}

@available(iOS 16.1, *)
struct PaceLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivitiesAppAttributes.self) { context in
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("PACE")
                        .font(.system(size: 13, weight: .heavy, design: .rounded))
                        .italic().foregroundColor(.white)
                    Text(liveLabel(context))
                        .font(.system(size: 9, weight: .bold)).tracking(1.5)
                        .foregroundColor(liveAccent(context))
                }
                Spacer()
                Text(liveTimerRef(context), style: .timer)
                    .font(.system(size: 30, weight: .heavy, design: .rounded))
                    .monospacedDigit().foregroundColor(liveAccent(context))
                    .frame(maxWidth: 130, alignment: .trailing)
            }
            .padding(16)
            .activityBackgroundTint(Color(red: 0.07, green: 0.06, blue: 0.09))
            .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading, spacing: 1) {
                        HStack(spacing: 5) {
                            Image(systemName: "flag.fill")
                                .foregroundColor(.yellow).font(.system(size: 18))
                            Text("\(liveInt(context, "smokedToday"))")
                                .font(.system(size: 22, weight: .heavy, design: .rounded))
                                .foregroundColor(.white).monospacedDigit()
                        }
                        Text("HEUTE")
                            .font(.system(size: 9, weight: .bold)).tracking(1.5)
                            .foregroundColor(.gray)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(liveTimerRef(context), style: .timer)
                        .font(.system(size: 22, weight: .heavy, design: .rounded))
                        .monospacedDigit().foregroundColor(liveAccent(context))
                        .frame(maxWidth: 110, alignment: .trailing)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text(liveLabel(context))
                        .font(.system(size: 11, weight: .bold)).tracking(1.5)
                        .foregroundColor(liveAccent(context))
                }
            } compactLeading: {
                HStack(spacing: 3) {
                    Image(systemName: "flag.fill")
                        .foregroundColor(.yellow).font(.system(size: 13))
                    Text("\(liveInt(context, "smokedToday"))")
                        .font(.system(size: 15, weight: .heavy, design: .rounded))
                        .foregroundColor(.white).monospacedDigit()
                }
            } compactTrailing: {
                Text(liveTimerRef(context), style: .timer)
                    .monospacedDigit().foregroundColor(liveAccent(context))
                    .frame(maxWidth: 56)
            } minimal: {
                Image(systemName: "flame.fill").foregroundColor(magenta)
            }
        }
    }
}

@main
struct PaceWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        PaceWidget()
        if #available(iOS 16.1, *) {
            PaceLiveActivity()
        }
    }
}

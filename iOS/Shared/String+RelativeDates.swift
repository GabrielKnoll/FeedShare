import Combine
import Foundation
import SwiftUI

public struct RelativeTime: View {
    @State var displayDate: String?
    
    private let date: Date?
    private static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    private static let relativeFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter
    }()
    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    public init(_ dateString: String) {
        self.date = RelativeTime.dateFormatter.date(from: dateString)
        _displayDate = State(initialValue: getTime())
    }
    
    func getTime() -> String? {
        let now = Date()
        if let date = self.date {
            let distance = date.distance(to: now)
            if distance.isLessThanOrEqualTo(60) {
                return "just now"
            } else if distance.isLessThanOrEqualTo(4 * 24 * 60 * 60)  {
                return RelativeTime.relativeFormatter.localizedString(for: date, relativeTo: now)
            } else {
                return date.formattedDate()
            }
        }
        return nil
    }
    
    public var body: some View {
        Text(displayDate ?? "")
        .onReceive(timer) { _ in
            self.displayDate = getTime()
        }
    }
}

public extension String {
    func parseDateFormatRelative() -> String? {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let date = dateFormatter.date(from: self) else {
            return nil
        }
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        formatter.doesRelativeDateFormatting = true
        return formatter.string(from: date)
    }
    
    static let isoDateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    func formattedIsoString() -> String? {
        guard let date = String.isoDateFormatter.date(from: self) else { return nil }
        return date.formattedDate()
    }
}

public extension Date {
    static let absoluteFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        return formatter
    }()
    
    static let absoluteFormatterSameYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("dMMMM")
        return formatter
    }()
    
    func formattedDate() -> String? {
        if self.isInSameYear(as: Date()) {
            return Date.absoluteFormatterSameYear.string(from: self)
        } else {
            return Date.absoluteFormatter.string(from: self)
        }
    }
}

extension Date {
    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }
    
    func isInSameYear(as date: Date) -> Bool { isEqual(to: date, toGranularity: .year) }
    func isInSameMonth(as date: Date) -> Bool { isEqual(to: date, toGranularity: .month) }
    func isInSameWeek(as date: Date) -> Bool { isEqual(to: date, toGranularity: .weekOfYear) }
    
    func isInSameDay(as date: Date) -> Bool { Calendar.current.isDate(self, inSameDayAs: date) }
    
    var isInThisYear: Bool { isInSameYear(as: Date()) }
    var isInThisMonth: Bool { isInSameMonth(as: Date()) }
    var isInThisWeek: Bool { isInSameWeek(as: Date()) }
    
    var isInYesterday: Bool { Calendar.current.isDateInYesterday(self) }
    var isInToday: Bool { Calendar.current.isDateInToday(self) }
    var isInTomorrow: Bool { Calendar.current.isDateInTomorrow(self) }
    
    var isInTheFuture: Bool { self > Date() }
    var isInThePast: Bool { self < Date() }
}

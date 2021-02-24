//
//  ShareRow.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI
import URLImage

public struct EpisodeDate: View {
    
    let datePublished: String
    let durationSeconds: Int?
    
    public init(datePublished: String, durationSeconds: Int?) {
        self.datePublished = datePublished
        self.durationSeconds = durationSeconds
    }
    
//    static let durationFormatter: DateComponentsFormatter = {
//        let formatter = DateComponentsFormatter()
//        formatter.unitsStyle = .brief
//        formatter.allowedUnits = [.hour, .minute]
//        formatter.zeroFormattingBehavior = [.dropLeading]
//        return formatter
//    }()
    
    public var body: some View {
        let published = datePublished.formattedIsoString() ?? ""
        if let sec = durationSeconds, let duration = EpisodeAttachment.durationFormatter.string(from: TimeInterval(sec)) {
            Text("\(duration) · \(published)")
        } else {
            Text(published)
        }
    }
}

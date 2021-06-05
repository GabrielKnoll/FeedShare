//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import PartialSheet
import Shared
import SwiftUI

public struct FeedEmpty: View {
    @EnvironmentObject var viewerModel: ViewerModel
    let type: FeedType

    func inviteFriends() {
        guard let data = URL(string: "https://findtruffle.com") else { return }
        let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }

    public var body: some View {
        switch type {
        case let .User(id):
            if id == viewerModel.viewer?.user.id {
                EmptyState(
                    title: "You haven't shared anything",
                    message: "Episodes you shared with your followers will appear here."
                )
            } else {
                EmptyState(
                    title: "Nothing shared",
                    message: "The user hasn't yet shared anything."
                )
            }

        case .Personal:
            EmptyState(
                title: "It's quiet here...",
                message: "Be the first of your friends to share an episode or explore the Global feed."
            )
        case .Global:
            Text("")
        }
    }
}

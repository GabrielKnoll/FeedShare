//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Shared
import SwiftUI
import URLImage

public struct SettingsClient: View {
    @EnvironmentObject var viewerModel: ViewerModel
    //    @State var isActive = false
    @State private var showingActionSheet = false

    public var body: some View {
        Button(action: {
            showingActionSheet = true
        }) {
            HStack {
                if let url = URL(string: viewerModel.viewerClient?.icon ?? "") {
                    URLImage(
                        url: url,
                        content: { proxy in
                            proxy
                                .resizable()
                                .frame(width: 30, height: 30)
                                .cornerRadius(7)
                                .aspectRatio(contentMode: .fill)
                                .clipped()
                        }
                    )
                }
                Text(viewerModel.viewerClient?.displayName ?? "Other")
                    .font(Typography.bodyMedium)
                    .foregroundColor(Color(R.color.primaryColor.name))

                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(Color(R.color.secondaryColor.name))
                    .font(Typography.body)
            }
            .padding(.horizontal, 10)
        }
        .buttonStyle(InputButton())
        .actionSheet(isPresented: $showingActionSheet) {
            var buttons = viewerModel.podcastClients.map { client in
                Alert.Button.default(Text(client.displayName), action: { viewerModel.viewerClient = client })
            }
            buttons.append(Alert.Button.default(Text("other"), action: { viewerModel.viewerClient = nil }))
            buttons.append(Alert.Button.cancel())

            return ActionSheet(
                title: Text("Select Your Podcast App"),
                buttons: buttons
            )
        }
    }
}

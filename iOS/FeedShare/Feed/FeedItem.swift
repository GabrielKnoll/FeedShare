//
//  ShareRow.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import PartialSheet
import Shared
import SwiftUI
import URLImage

public struct FeedItem: View {
    let data: ShareFragment
    @EnvironmentObject var viewerModel: ViewerModel
    @State private var episodePresented = false
    @State private var showingActionSheet = false
    @State private var showingAddToFeedError = false
    
    public var body: some View {
        NavigationLink(destination: EpisodeOverlay(attachment: data.episode.fragments.episodeAttachmentFragment)) {
            VStack(alignment: .leading, spacing: 15) {
                EpisodeAttachment(data: data.episode.fragments.episodeAttachmentFragment)
                
                if let message = data.message {
                    Text(message).font(Typography.body)
                }
                HStack(alignment: .center, spacing: 5) {
                    ProfilePicture(url: data.author.profilePicture, size: 28.0)
                        .padding(.trailing, 4)
                    if let displayName = data.author.displayName {
                        Text(displayName)
                            .font(Typography.meta)
                            .lineLimit(1)
                    }
                    Text("·")
                        .foregroundColor(Color(R.color.secondaryColor.name))
                        .font(Typography.meta)
                    RelativeTime(data.createdAt)
                        .foregroundColor(Color(R.color.secondaryColor.name))
                        .font(Typography.meta)
                        .lineLimit(1)
                    if data.isInGlobalFeed != true {
                        Image(systemName: "lock.fill")
                            .foregroundColor(Color(R.color.secondaryColor.name))
                            .font(.system(size: 13))
                    }
                    Spacer()
                    
                    Button(action: {
                        showingActionSheet = true
                    }) {
                        Image(systemName: "ellipsis")
                            .foregroundColor(Color(R.color.secondaryColor.name))
                            .font(.system(size: 16))
                            .frame(width: 44, height: 44, alignment: .center)
                            .padding(.vertical, -8/*@END_MENU_TOKEN@*/)
                            .padding(.trailing, -8/*@END_MENU_TOKEN@*/)
                    }
                }
                .font(Typography.bodyMedium)
            }
            .actionSheet(isPresented: $showingActionSheet) {
                var buttons = [
                    Alert.Button.cancel()
                ]
                
//                if !(data.isInPersonalFeed ?? false) {
                    buttons.append(Alert.Button.default(Text("Add to Personal Feed"), action: {
                        FeedModel.addToPersonalFeed(id: data.id) { share in
                            self.showingActionSheet = false
                            if share == nil {
                                self.showingAddToFeedError = true
                            } else {
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            }
                        }
                    }))
//                }
                
//                if data.author.id == viewerModel.viewer?.user.id {
//                    if data.isInGlobalFeed ?? false {
//                        buttons.append(Alert.Button.destructive(Text("Hide from Global Feed"), action: {
//
//                        }))
//                    }
//
//                    buttons.append(Alert.Button.destructive(Text("Delete"), action: {
//
//                    }))
//                }

                return ActionSheet(
                    title: Text(data.episode.fragments.episodeAttachmentFragment.title),
                    message: Text(data.episode.fragments.episodeAttachmentFragment.podcast.title),
                    buttons: buttons
                )
            }
            .alert(isPresented: $showingAddToFeedError, content: {
                Alert(
                    title: Text("Failed to Add"),
                    message: Text("Adding this episode to your Peronsal Feed failed. Maybe try again."),
                    dismissButton: .default(Text("OK"))
                )
            })
        }.buttonStyle(FeedItemButtonStyle())
    }
}

struct FeedItemButtonStyle: ButtonStyle {
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .foregroundColor(Color(R.color.primaryColor.name))
            .padding(15)
            .background(Color(.systemBackground))
            .cornerRadius(20)
            
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .shadow(
                color: Color(R.color.primaryColor.name).opacity(0.05),
                radius: configuration.isPressed ? 2 : 4,
                x: 0,
                y: configuration.isPressed ? 0 : 2
            )
            .animation(.easeInOut(duration: 0.15))
    }
}

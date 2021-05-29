//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import JGProgressHUD_SwiftUI
import MarkdownUI
import Shared
import SkeletonUI
import SwiftUI

public struct EpisodeOverlay: View {
    let attachment: EpisodeAttachmentFragment

    @ObservedObject var data: EpisodeOverlayModel
    @EnvironmentObject var viewerModel: ViewerModel
    @EnvironmentObject var hudCoordinator: JGProgressHUDCoordinator
    @State var isLoaded = true
    @State var safariViewPresented = false
    @State var url: URL?

    init(attachment: EpisodeAttachmentFragment) {
        self.attachment = attachment
        data = EpisodeOverlayModel(id: attachment.id)
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                PodcastHeader(
                    title: attachment.title,
                    title2: attachment.podcast.title,
                    artwork: data.fragment?.artwork ?? data.fragment?.podcast.artwork ?? attachment.artwork ?? attachment.podcast.artwork
                )

                Details(attachment: attachment)

                if let duration = attachment.durationSeconds {
                    Text(EpisodeAttachment.durationFormatter.string(from: TimeInterval(duration)))
                        .font(Typography.bodyBold)
                }

                VStack(spacing: 0) {
                    Divider().background(Color(R.color.tertiaryColor.name)).frame(height: 1)
                    if let client = viewerModel.viewerClient {
                        Button("Subscribe in \(client.displayName)", action: {
                            SubscribeButton.openURL(client, feed: data.fragment?.podcast.feed)
                        })
                            .buttonStyle(RowButton())
                    } else {
                        Button("Copy Podcast Feed", action: {
                            UIPasteboard.general.string = data.fragment?.podcast.feed
                            hudCoordinator.showHUD {
                                let hud = JGProgressHUD()
                                hud.square = true
                                hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                                hud.textLabel.text = "Copied Feed URL"
                                hud.cornerRadius = 15.0
                                return hud
                            }
                            
                        })
                            .buttonStyle(RowButton())
                    }

                    if url != nil {
                        Button("Website", action: {
                            self.safariViewPresented = true
                        })
                            .buttonStyle(RowButton())
                    }
                }

                Markdown(Document(data.fragment?.description ?? ""))
                    .markdownStyle(
                        DefaultMarkdownStyle(
                            font: R.font.interRegular(size: 16.0)!,
                            foregroundColor: R.color.primaryColor()!,
                            headingFontSizeMultiples: [1.0]
                        )
                    )
                    .accentColor(Color(R.color.brandColor.name))
                    .skeleton(with: data.fragment?.description == nil)
                    .shape(type: .capsule)
                    .multiline(lines: 8, scales: [
                        0: 0.85,
                        1: 0.91,
                        2: 0.82,
                        3: 0.95,
                        4: 0.73,
                        5: 0.87,
                        6: 0.82,
                        7: 0.90,
                    ])

                Spacer()
            }
            .padding(20)
            .navigationBarTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .foregroundColor(Color(R.color.primaryColor.name))
            .sheet(isPresented: self.$safariViewPresented) {
                SafariView(url: $url)
            }
            .onReceive(data.$fragment, perform: { fragment in
                url = URL(string: fragment?.url ?? fragment?.podcast.url ?? "")
            })
        }
    }
}

public struct Details: View {
    let attachment: EpisodeAttachmentFragment

    public var body: some View {
        Text("Published by ").font(Typography.body) +
            Text(attachment.podcast.publisher).font(Typography.bodyBold) +
            Text(" on ").font(Typography.body) +
            Text(attachment.datePublished.formattedIsoString()).font(Typography.bodyBold)
    }
}

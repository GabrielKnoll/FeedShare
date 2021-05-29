//
//  ShareRow.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import JGProgressHUD_SwiftUI
import Shared
import SwiftUI
import URLImage

public struct FeedItem: View {
    let data: ShareFragment
    @EnvironmentObject var viewerModel: ViewerModel
    @EnvironmentObject var hudCoordinator: JGProgressHUDCoordinator
    @State private var isPressed = false
    @State private var showProfile = false
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            
            NavigationLink(
                destination: EpisodeOverlay(attachment: data.episode.fragments.episodeAttachmentFragment)
                    .environmentObject(viewerModel),
                label: {
                    VStack(alignment: .leading, spacing: 0) {
                        EpisodeAttachment(data: data.episode.fragments.episodeAttachmentFragment)
                        
                        if let message = data.message {
                            Text(message).font(Typography.body).padding(.top, 15)
                        }
                    }
                })
                .buttonStyle(PressedButtonStyle {
                    DispatchQueue.main.async {
                        self.isPressed = true
                    }
                    
                } touchUp: {
                    DispatchQueue.main.async {
                        self.isPressed = false
                    }
                })
                .background(
                    NavigationLink(destination: Profile(userId: data.author.id), isActive: $showProfile) {
                        EmptyView()
                    }
                )
            
            HStack(alignment: .center, spacing: 5) {
                Button(action: {
                    showProfile = true
                }, label: {
                    HStack(alignment: .center, spacing: 5, content: {
                        ProfilePicture(url: data.author.profilePicture, size: 28.0)
                            .padding(.trailing, 4)
                        if let displayName = data.author.displayName {
                            Text(displayName)
                                .font(Typography.meta)
                                .lineLimit(1)
                        }
                    })
                })
                
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
                
                Menu {
                    Button(action: {
                        showProfile = true
                    }) {
                        Label((data.author.displayName ?? "User Profile"), systemImage: "person.crop.circle")
                    }
                    
                    if !(data.isInPersonalFeed ?? true) {
                        Button(action: {
                            FeedModel.addToPersonalFeed(id: data.id) { share in
                                hudCoordinator.showHUD {
                                    let hud = JGProgressHUD()
                                    hud.square = true
                                    hud.indicatorView = (share != nil) ? JGProgressHUDSuccessIndicatorView() : JGProgressHUDErrorIndicatorView()
                                    hud.textLabel.text = (share != nil) ? "Added Episode\nto Personal Feed" : "Failed to Add\nto Personal Feed"
                                    let animation = JGProgressHUDFadeAnimation()
                                    animation.duration = 0.2
                                    hud.animation = animation
                                    hud.cornerRadius = 15.0
                                    hud.dismiss(afterDelay: 4)
                                    return hud
                                }
                            }
                        }) {
                            Label("Add to Personal Feed", systemImage: "plus.circle")
                        }
                    }
                } label: {
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
        .foregroundColor(Color(R.color.primaryColor.name))
        .padding(15)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .scaleEffect(isPressed ? 0.98 : 1)
        .shadow(
            color: Color(R.color.primaryColor.name).opacity(0.05),
            radius: isPressed ? 2 : 4,
            x: 0,
            y: isPressed ? 0 : 2
        )
        .animation(.easeInOut(duration: 0.15))
    }
}

struct PressedButtonStyle: ButtonStyle {
    let touchDown: () -> Void
    let touchUp: () -> Void
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? self.handlePressed() : handleReleased())
    }
    
    private func handlePressed() -> Color {
        touchDown()
        return Color.clear
    }
    
    private func handleReleased() -> Color {
        touchUp()
        return Color.clear
    }
}

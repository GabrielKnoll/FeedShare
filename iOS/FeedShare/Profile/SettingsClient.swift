//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Shared
import SwiftUI

public struct SettingsClient: View {
    @EnvironmentObject var viewerModel: ViewerModel
    @State var isActive = false
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text("Your Podcast client").bold()
            NavigationLink(
                destination: SettingsClientList(),
                isActive: $isActive
            ) { EmptyView() }.hidden()
            PodcastClientRow(
                icon: viewerModel.viewerClient?.icon,
                name: viewerModel.viewerClient?.displayName ?? "Other"
            ) {
                isActive = true
            }
        }
        
    }
}

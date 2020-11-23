import SwiftUI
import URLImage

public struct OnboardingPodcastClient: View {
    @StateObject var model = OnboardingPodcastClientModel()
    @EnvironmentObject var viewerModel: ViewerModel
    var onNext: () -> Void
    
    public var body: some View {
        VStack {
            Text("Which Podcast client are you using?")
            ForEach(model.podcastClients, id: \.id) { client in
                Button(action: {
                    viewerModel.viewerClient = client
                    onNext()
                }) {
                    HStack {
                        URLImage(URL(string: client.icon)!, placeholder: Image(systemName: "circle")) { proxy in
                            proxy.image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipped()
                        }.frame(width: 44.0, height: 44.0).cornerRadius(10)
                        Text(client.displayName)
                        Spacer()
                    }.padding(10)
                }
            }
        }
    }
}

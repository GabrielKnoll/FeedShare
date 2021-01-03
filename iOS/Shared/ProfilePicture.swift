//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Combine
import SwiftUI
import URLImage

public class ProfilePictureModel: ObservableObject {
    @Published var img: Image?
    
    private var remoteImage: RemoteImage?
    private var cancellable: AnyCancellable?
    
    init(url: String?) {
        if let u = url, let uu = URL(string: u) {
            self.remoteImage = URLImageService.shared.makeRemoteImage(url: uu)
            self.cancellable = remoteImage?.$loadingState.sink { state in
                switch state {
                case .initial: break
                case .inProgress: break
                case .success(let image):
                    self.img = image.image
                case .failure: break
                }
            }
            
            remoteImage?.load()
        }
    }
}

public struct ProfilePicture: View {
    private let size: CGFloat
    @State private var img: Image?
    @ObservedObject var model: ProfilePictureModel
    
    public init(url: String?, size: Double) {
        model = ProfilePictureModel(url: url)
        self.size = CGFloat(size)
    }
    
    public var body: some View {
        VStack {
            model.img?
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
        .skeleton(with: model.img == nil)
        .frame(width: size, height: size)
        .background(Color.secondary)
        .cornerRadius(CGFloat(size / 2))
    }
}

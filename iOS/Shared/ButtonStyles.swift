//
//  ButtonStyles.swift
//  FeedShare
//
//  Created by Daniel Büchele on 12/26/20.
//

import Foundation
import SwiftUI

public struct FilledButton: ButtonStyle {
    
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        FilledButtonView(configuration: configuration)
    }

    struct FilledButtonView: View {
        let configuration: ButtonStyle.Configuration
        
        @Environment(\.isEnabled) private var isEnabled: Bool
        var body: some View {
            configuration.label
                .font(Typography.button)
                .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 44)
                .lineLimit(1)
                .background(Color(R.color.brandColor.name))
                .foregroundColor(.white)
                .cornerRadius(10)
                .font(Typography.button)
                .scaleEffect(configuration.isPressed && isEnabled ? 0.96 : 1)
                .animation(Animation.spring().speed(2))
        }
    }
}

public struct LinkButton: ButtonStyle {
    
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .font(Typography.caption)
            .lineLimit(1)
            .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 44)
            .foregroundColor(Color(configuration.isPressed ? R.color.tertiaryColor.name : R.color.secondaryColor.name))
    }
}

public struct InputButton: ButtonStyle {
    
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        FilledButtonView(configuration: configuration)
    }
    
    struct FilledButtonView: View {
        let configuration: ButtonStyle.Configuration
        
        @Environment(\.isEnabled) private var isEnabled: Bool
        var body: some View {
            configuration.label
                .font(Typography.button)
                .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                .lineLimit(1)
                .background(Color(configuration.isPressed ? R.color.washColor.name : R.color.lightWashColor.name))
                .foregroundColor(.white)
                .cornerRadius(10)
                .font(Typography.button)
        }
    }
}

public struct RowButton: ButtonStyle {
    
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        FilledButtonView(configuration: configuration)
    }

    struct FilledButtonView: View {
        let configuration: ButtonStyle.Configuration
        
        @Environment(\.isEnabled) private var isEnabled: Bool
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center) {
                    configuration.label
                        .font(Typography.button)
                        .frame(minHeight: 44)
                    
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color(R.color.secondaryColor.name))
                    
                }
                .contentShape(Rectangle())
                .foregroundColor(Color(R.color.primaryColor.name))
                .opacity(configuration.isPressed ? 0.7 : 1)
                Divider().background(Color(R.color.tertiaryColor.name))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: {}) {
            Image(systemName: "pencil.circle.fill")
            Text("test")
        }.buttonStyle(RowButton())
    }
}

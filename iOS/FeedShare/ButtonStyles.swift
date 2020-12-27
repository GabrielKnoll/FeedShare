//
//  ButtonStyles.swift
//  FeedShare
//
//  Created by Daniel Büchele on 12/26/20.
//

import Foundation
import Shared
import SwiftUI

public struct FilledButton: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            //.foregroundColor(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 30)
            .font(.system(size: 17, weight: .semibold))
            .background(Color(R.color.accent.name))
            .cornerRadius(80)
    }
}

public struct SecondaryButton: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .foregroundColor(.secondary)
            .padding(10)
            .font(.system(size: 15, weight: .semibold))
    }
}

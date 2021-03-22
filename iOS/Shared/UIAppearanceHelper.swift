//
//  UIAppearance.swift
//  Shared
//
//  Created by Daniel Büchele on 3/2/21.
//

import Foundation
import SwiftUI

public enum UIAppearanceHelper {
    public static func setup() {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font: R.font.interBold(size: 35),
            .foregroundColor: R.color.primaryColor(),
        ]

        UINavigationBar.appearance().tintColor = R.color.primaryColor()!
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().shadowImage = nil

        UINavigationBar.appearance().titleTextAttributes = [
            .font: R.font.interSemiBold(size: 17),
            .foregroundColor: R.color.primaryColor(),
        ]

        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = R.color.primaryColor()
    }
}

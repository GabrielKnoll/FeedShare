//
//  NetworkManager.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 26.09.20.
//

import Foundation

public struct NetworkManager {
	public var launchListData: () -> [Share]

	public init(launchListData: (@escaping () -> [Share])) {
		self.launchListData = launchListData
	}
}

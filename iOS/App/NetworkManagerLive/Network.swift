//
//  Network.swift
//  FeedShare
//
//  Created by Daniel Büchele on 9/19/20.
//

import Apollo
import ApolloSQLite
import Foundation

final class Network {
  static let shared = Network()
  private lazy var networkTransport: HTTPNetworkTransport = {

	//swiftlint:disable:next force_unwrapping
	let transport = HTTPNetworkTransport(url: URL(string: "https://feed.buechele.cc/graphql")!)
	transport.delegate = self

	return transport
  }()

  private lazy var store: ApolloStore = {
	//swiftlint:disable force_unwrapping
	let documentsPath = NSSearchPathForDirectoriesInDomains(
	  .documentDirectory,
	  .userDomainMask,
	  true).first!
	//swiftlint:enable force_unwrapping
	let documentsURL = URL(fileURLWithPath: documentsPath)
	let sqliteFileURL = documentsURL.appendingPathComponent("apollo.sqlite")
	// swiftlint:disable:next force_try
	let sqliteCache = try! SQLiteNormalizedCache(fileURL: sqliteFileURL)
	return ApolloStore(cache: sqliteCache)
  }()

	private(set) lazy var apollo: ApolloClient = {
		let client = ApolloClient(networkTransport: self.networkTransport, store: self.store)
		client.cacheKeyForObject = { $0["id"] }
		return client
	  }()
}

extension Network: HTTPNetworkTransportPreflightDelegate {
  func networkTransport(_ networkTransport: HTTPNetworkTransport, shouldSend request: URLRequest) -> Bool {
	return true
  }

  func networkTransport(_ networkTransport: HTTPNetworkTransport, willSend request: inout URLRequest) {
	var headers = request.allHTTPHeaderFields ?? [String: String]()
	headers["Authorization"] = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJhMDRhZjI4Ni00ZWM5LTQzMzYtYmRkMy01MDY4MDNiYjFmNTEifQ.0t_u5vYM_kRpNY03YXMT7S1-Fzn1OGE1EWJbdEnmCnA"
	request.allHTTPHeaderFields = headers
  }
}

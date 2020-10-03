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

	let transport = HTTPNetworkTransport(url: URL(string: "https://feed.buechele.cc/graphql")!)
	transport.delegate = self

	return transport
  }()

  private lazy var store: ApolloStore = {
	let documentsPath = NSSearchPathForDirectoriesInDomains(
	  .documentDirectory,
	  .userDomainMask,
	  true).first!
	let documentsURL = URL(fileURLWithPath: documentsPath)
	let sqliteFileURL = documentsURL.appendingPathComponent("apollo.sqlite")
	// swiftlint:disable:next force_try
	let sqliteCache = try! SQLiteNormalizedCache(fileURL: sqliteFileURL)
	return ApolloStore(cache: sqliteCache)
  }()

  private(set) lazy var apollo = ApolloClient(networkTransport: self.networkTransport, store: self.store)
}

extension Network: HTTPNetworkTransportPreflightDelegate {
  func networkTransport(_ networkTransport: HTTPNetworkTransport, shouldSend request: URLRequest) -> Bool {
	return true
  }

  func networkTransport(_ networkTransport: HTTPNetworkTransport, willSend request: inout URLRequest) {
	var headers = request.allHTTPHeaderFields ?? [String: String]()
	headers["Authorization"] = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoiMSJ9.c_rZK1KlP58-R51c2SfCv7JQYWfnSlU3whNvAw3-dqw"
	request.allHTTPHeaderFields = headers
  }
}

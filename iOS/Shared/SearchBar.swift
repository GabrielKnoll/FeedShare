//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import SwiftUI

struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    let disabled: Bool?
    let placeholder: String?
    var action: (_ searchText: String) -> Void
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        var action: (_ searchText: String) -> Void
        
        init(text: Binding<String>, action: @escaping (_ searchText: String) -> Void) {
            _text = text
            self.action = action
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            self.action(text)
        }
    }
    
    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text, action: self.action)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        searchBar.becomeFirstResponder()
        searchBar.isUserInteractionEnabled = !(disabled ?? false)
        searchBar.placeholder = placeholder
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
        uiView.placeholder = placeholder
        uiView.isUserInteractionEnabled = !(disabled ?? false)
    }
}

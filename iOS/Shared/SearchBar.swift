//
//  FeedStream.swift
//  FeedShare
//
//  Created by Gabriel Knoll on 19.09.20.
//

import Introspect
import SwiftUI

public struct SearchBar: View {
    @Binding var text: String

    @State var focusDismissed: Bool = false

    let disabled: Bool
    let placeholder: String
    let focused: Bool
    let onCommit: () -> Void

    weak var textField: UITextField?

    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(R.color.lightWashColor.name))

            HStack(alignment: .center, spacing: 8) {
                Image(systemName: "magnifyingglass")
                ZStack(alignment: .leading) {
                    if text.isEmpty {
                        Text(placeholder)
                            .foregroundColor(Color(R.color.secondaryColor.name))
                    }
                    TextField(
                        "",
                        text: $text,
                        onEditingChanged: { editingChanged in
                            if editingChanged {
                                focusDismissed = false
                            }
                        }, onCommit: {
                            if !text.isEmpty {
                                focusDismissed = true
                                onCommit()
                            }
                        }
                    )
                    .disabled(disabled)
                    .frame(height: 50)
                    .introspectTextField(customize: { textField in
                        if focused, !disabled, !focusDismissed {
                            textField.becomeFirstResponder()
                        } else {
                            textField.resignFirstResponder()
                        }
                        textField.returnKeyType = .search
                        textField.addConstraint(textField.heightAnchor.constraint(equalToConstant: 50))
                    })
                }

                if !text.isEmpty, !disabled {
                    Button(action: {
                        text = ""
                        focusDismissed = false
                        self.textField?.becomeFirstResponder()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color(R.color.secondaryColor.name))
                    }
                }
            }
            .font(Typography.bodyMedium)
            .padding(.horizontal, 12)
            .foregroundColor(Color(disabled ? R.color.secondaryColor.name : R.color.primaryColor.name)
            )
        }
        .frame(height: 50)
    }
}

struct SearchBar_Previews: PreviewProvider {
    @State static var value = ""

    static var previews: some View {
        SearchBar(text: $value, disabled: false, placeholder: "Search Podcasts...", focused: false) {
            print(value)
        }
    }
}

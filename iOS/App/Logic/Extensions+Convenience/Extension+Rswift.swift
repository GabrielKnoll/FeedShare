//
//  Extension+Rswift.swift
//  Logic
//
//  Created by Gabriel Knoll on 03.10.20.
//

import Foundation
import Rswift
import SwiftUI

public extension FontResource {
	func font(size: CGFloat) -> Font {
		Font.custom(fontName, size: size)
	}
}

public extension ColorResource {
	var color: Color {
		Color(name)
	}
}

public extension StringResource {
	var localizedStringKey: LocalizedStringKey {
		LocalizedStringKey(key)
	}

	var text: Text {
		Text(localizedStringKey)
	}
}

public extension ImageResource {
	var image: Image {
		Image(name)
	}
}

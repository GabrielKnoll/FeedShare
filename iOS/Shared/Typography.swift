//
//  FontExtension.swift
//  Shared
//
//  Created by Daniel Büchele on 12/31/20.
//

import SwiftUI

public enum Typography {
    public static var title: Font {
        // bold, 35
        Font.custom(R.font.interBold.fontName, size: 35)
    }

    public static var title2: Font {
        Font.custom(R.font.interBold.fontName, size: 22)
    }

    public static var title3: Font {
        Font.custom(R.font.interRegular.fontName, size: 20)
    }

    public static var button: Font {
        // semi-bold, 17
        Font.custom(R.font.interSemiBold.fontName, size: 17)
    }

    public static var body: Font {
        // regular, 15
        Font.custom(R.font.interRegular.fontName, size: 16)
    }

    public static var bodyMedium: Font {
        // medium, 15
        Font.custom(R.font.interMedium.fontName, size: 16)
    }

    public static var bodyBold: Font {
        Font.custom(R.font.interSemiBold.fontName, size: 16)
    }

    public static var caption: Font {
        // semi-bold, 15
        Font.custom(R.font.interSemiBold.fontName, size: 15)
    }

    public static var headline: Font {
        // bold, 18
        Font.custom(R.font.interBold.fontName, size: 18)
    }

    public static var meta: Font {
        // medium, 14
        Font.custom(R.font.interMedium.fontName, size: 14)
    }

//    static var headline: Font {
//        return Font.custom(R.font.tiemposHeadlineSemibold.fontName, size: UIFont.preferredFont(forTextStyle: .headline).pointSize)
//    }
}

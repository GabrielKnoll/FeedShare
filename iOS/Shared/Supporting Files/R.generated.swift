//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
public struct R: Rswift.Validatable {
    fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap { Locale(identifier: $0) } ?? Locale.current
    fileprivate static let hostingBundle = Bundle(for: R.Class.self)

    /// Find first language and bundle for which the table exists
    fileprivate static func localeBundle(tableName: String, preferredLanguages: [String]) -> (Foundation.Locale, Foundation.Bundle)? {
        // Filter preferredLanguages to localizations, use first locale
        var languages = preferredLanguages
            .map { Locale(identifier: $0) }
            .prefix(1)
            .flatMap { locale -> [String] in
                if hostingBundle.localizations.contains(locale.identifier) {
                    if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
                        return [locale.identifier, language]
                    } else {
                        return [locale.identifier]
                    }
                } else if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
                    return [language]
                } else {
                    return []
                }
            }

        // If there's no languages, use development language as backstop
        if languages.isEmpty {
            if let developmentLocalization = hostingBundle.developmentLocalization {
                languages = [developmentLocalization]
            }
        } else {
            // Insert Base as second item (between locale identifier and languageCode)
            languages.insert("Base", at: 1)

            // Add development language as backstop
            if let developmentLocalization = hostingBundle.developmentLocalization {
                languages.append(developmentLocalization)
            }
        }

        // Find first language for which table exists
        // Note: key might not exist in chosen language (in that case, key will be shown)
        for language in languages {
            if let lproj = hostingBundle.url(forResource: language, withExtension: "lproj"),
               let lbundle = Bundle(url: lproj)
            {
                let strings = lbundle.url(forResource: tableName, withExtension: "strings")
                let stringsdict = lbundle.url(forResource: tableName, withExtension: "stringsdict")

                if strings != nil || stringsdict != nil {
                    return (Locale(identifier: language), lbundle)
                }
            }
        }

        // If table is available in main bundle, don't look for localized resources
        let strings = hostingBundle.url(forResource: tableName, withExtension: "strings", subdirectory: nil, localization: nil)
        let stringsdict = hostingBundle.url(forResource: tableName, withExtension: "stringsdict", subdirectory: nil, localization: nil)

        if strings != nil || stringsdict != nil {
            return (applicationLocale, hostingBundle)
        }

        // If table is not found for requested languages, key will be shown
        return nil
    }

    /// Load string from Info.plist file
    fileprivate static func infoPlistString(path: [String], key: String) -> String? {
        var dict = hostingBundle.infoDictionary
        for step in path {
            guard let obj = dict?[step] as? [String: Any] else { return nil }
            dict = obj
        }
        return dict?[key] as? String
    }

    public static func validate() throws {
        try font.validate()
        try intern.validate()
    }

    /// This `R.color` struct is generated, and contains static references to 8 colors.
    public struct color {
        /// Color `BackgroundColor`.
        public static let backgroundColor = Rswift.ColorResource(bundle: R.hostingBundle, name: "BackgroundColor")
        /// Color `BrandColor`.
        public static let brandColor = Rswift.ColorResource(bundle: R.hostingBundle, name: "BrandColor")
        /// Color `DangerColor`.
        public static let dangerColor = Rswift.ColorResource(bundle: R.hostingBundle, name: "DangerColor")
        /// Color `LightWashColor`.
        public static let lightWashColor = Rswift.ColorResource(bundle: R.hostingBundle, name: "LightWashColor")
        /// Color `PrimaryColor`.
        public static let primaryColor = Rswift.ColorResource(bundle: R.hostingBundle, name: "PrimaryColor")
        /// Color `SecondaryColor`.
        public static let secondaryColor = Rswift.ColorResource(bundle: R.hostingBundle, name: "SecondaryColor")
        /// Color `TertiaryColor`.
        public static let tertiaryColor = Rswift.ColorResource(bundle: R.hostingBundle, name: "TertiaryColor")
        /// Color `WashColor`.
        public static let washColor = Rswift.ColorResource(bundle: R.hostingBundle, name: "WashColor")

        #if os(iOS) || os(tvOS)
            /// `UIColor(named: "BackgroundColor", bundle: ..., traitCollection: ...)`
            @available(tvOS 11.0, *)
            @available(iOS 11.0, *)
            public static func backgroundColor(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
                UIKit.UIColor(resource: R.color.backgroundColor, compatibleWith: traitCollection)
            }
        #endif

        #if os(iOS) || os(tvOS)
            /// `UIColor(named: "BrandColor", bundle: ..., traitCollection: ...)`
            @available(tvOS 11.0, *)
            @available(iOS 11.0, *)
            public static func brandColor(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
                UIKit.UIColor(resource: R.color.brandColor, compatibleWith: traitCollection)
            }
        #endif

        #if os(iOS) || os(tvOS)
            /// `UIColor(named: "DangerColor", bundle: ..., traitCollection: ...)`
            @available(tvOS 11.0, *)
            @available(iOS 11.0, *)
            public static func dangerColor(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
                UIKit.UIColor(resource: R.color.dangerColor, compatibleWith: traitCollection)
            }
        #endif

        #if os(iOS) || os(tvOS)
            /// `UIColor(named: "LightWashColor", bundle: ..., traitCollection: ...)`
            @available(tvOS 11.0, *)
            @available(iOS 11.0, *)
            public static func lightWashColor(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
                UIKit.UIColor(resource: R.color.lightWashColor, compatibleWith: traitCollection)
            }
        #endif

        #if os(iOS) || os(tvOS)
            /// `UIColor(named: "PrimaryColor", bundle: ..., traitCollection: ...)`
            @available(tvOS 11.0, *)
            @available(iOS 11.0, *)
            public static func primaryColor(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
                UIKit.UIColor(resource: R.color.primaryColor, compatibleWith: traitCollection)
            }
        #endif

        #if os(iOS) || os(tvOS)
            /// `UIColor(named: "SecondaryColor", bundle: ..., traitCollection: ...)`
            @available(tvOS 11.0, *)
            @available(iOS 11.0, *)
            public static func secondaryColor(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
                UIKit.UIColor(resource: R.color.secondaryColor, compatibleWith: traitCollection)
            }
        #endif

        #if os(iOS) || os(tvOS)
            /// `UIColor(named: "TertiaryColor", bundle: ..., traitCollection: ...)`
            @available(tvOS 11.0, *)
            @available(iOS 11.0, *)
            public static func tertiaryColor(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
                UIKit.UIColor(resource: R.color.tertiaryColor, compatibleWith: traitCollection)
            }
        #endif

        #if os(iOS) || os(tvOS)
            /// `UIColor(named: "WashColor", bundle: ..., traitCollection: ...)`
            @available(tvOS 11.0, *)
            @available(iOS 11.0, *)
            public static func washColor(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
                UIKit.UIColor(resource: R.color.washColor, compatibleWith: traitCollection)
            }
        #endif

        #if os(watchOS)
            /// `UIColor(named: "BackgroundColor", bundle: ..., traitCollection: ...)`
            @available(watchOSApplicationExtension 4.0, *)
            public static func backgroundColor(_: Void = ()) -> UIKit.UIColor? {
                UIKit.UIColor(named: R.color.backgroundColor.name)
            }
        #endif

        #if os(watchOS)
            /// `UIColor(named: "BrandColor", bundle: ..., traitCollection: ...)`
            @available(watchOSApplicationExtension 4.0, *)
            public static func brandColor(_: Void = ()) -> UIKit.UIColor? {
                UIKit.UIColor(named: R.color.brandColor.name)
            }
        #endif

        #if os(watchOS)
            /// `UIColor(named: "DangerColor", bundle: ..., traitCollection: ...)`
            @available(watchOSApplicationExtension 4.0, *)
            public static func dangerColor(_: Void = ()) -> UIKit.UIColor? {
                UIKit.UIColor(named: R.color.dangerColor.name)
            }
        #endif

        #if os(watchOS)
            /// `UIColor(named: "LightWashColor", bundle: ..., traitCollection: ...)`
            @available(watchOSApplicationExtension 4.0, *)
            public static func lightWashColor(_: Void = ()) -> UIKit.UIColor? {
                UIKit.UIColor(named: R.color.lightWashColor.name)
            }
        #endif

        #if os(watchOS)
            /// `UIColor(named: "PrimaryColor", bundle: ..., traitCollection: ...)`
            @available(watchOSApplicationExtension 4.0, *)
            public static func primaryColor(_: Void = ()) -> UIKit.UIColor? {
                UIKit.UIColor(named: R.color.primaryColor.name)
            }
        #endif

        #if os(watchOS)
            /// `UIColor(named: "SecondaryColor", bundle: ..., traitCollection: ...)`
            @available(watchOSApplicationExtension 4.0, *)
            public static func secondaryColor(_: Void = ()) -> UIKit.UIColor? {
                UIKit.UIColor(named: R.color.secondaryColor.name)
            }
        #endif

        #if os(watchOS)
            /// `UIColor(named: "TertiaryColor", bundle: ..., traitCollection: ...)`
            @available(watchOSApplicationExtension 4.0, *)
            public static func tertiaryColor(_: Void = ()) -> UIKit.UIColor? {
                UIKit.UIColor(named: R.color.tertiaryColor.name)
            }
        #endif

        #if os(watchOS)
            /// `UIColor(named: "WashColor", bundle: ..., traitCollection: ...)`
            @available(watchOSApplicationExtension 4.0, *)
            public static func washColor(_: Void = ()) -> UIKit.UIColor? {
                UIKit.UIColor(named: R.color.washColor.name)
            }
        #endif

        fileprivate init() {}
    }

    /// This `R.file` struct is generated, and contains static references to 7 files.
    public struct file {
        /// Resource file `IBMPlexSans-Medium.ttf`.
        public static let ibmPlexSansMediumTtf = Rswift.FileResource(bundle: R.hostingBundle, name: "IBMPlexSans-Medium", pathExtension: "ttf")
        /// Resource file `IBMPlexSans-Regular.ttf`.
        public static let ibmPlexSansRegularTtf = Rswift.FileResource(bundle: R.hostingBundle, name: "IBMPlexSans-Regular", pathExtension: "ttf")
        /// Resource file `Inter-Bold.otf`.
        public static let interBoldOtf = Rswift.FileResource(bundle: R.hostingBundle, name: "Inter-Bold", pathExtension: "otf")
        /// Resource file `Inter-Medium.otf`.
        public static let interMediumOtf = Rswift.FileResource(bundle: R.hostingBundle, name: "Inter-Medium", pathExtension: "otf")
        /// Resource file `Inter-Regular.otf`.
        public static let interRegularOtf = Rswift.FileResource(bundle: R.hostingBundle, name: "Inter-Regular", pathExtension: "otf")
        /// Resource file `Inter-SemiBold.otf`.
        public static let interSemiBoldOtf = Rswift.FileResource(bundle: R.hostingBundle, name: "Inter-SemiBold", pathExtension: "otf")
        /// Resource file `TiemposHeadline-Semibold.otf`.
        public static let tiemposHeadlineSemiboldOtf = Rswift.FileResource(bundle: R.hostingBundle, name: "TiemposHeadline-Semibold", pathExtension: "otf")

        /// `bundle.url(forResource: "IBMPlexSans-Medium", withExtension: "ttf")`
        public static func ibmPlexSansMediumTtf(_: Void = ()) -> Foundation.URL? {
            let fileResource = R.file.ibmPlexSansMediumTtf
            return fileResource.bundle.url(forResource: fileResource)
        }

        /// `bundle.url(forResource: "IBMPlexSans-Regular", withExtension: "ttf")`
        public static func ibmPlexSansRegularTtf(_: Void = ()) -> Foundation.URL? {
            let fileResource = R.file.ibmPlexSansRegularTtf
            return fileResource.bundle.url(forResource: fileResource)
        }

        /// `bundle.url(forResource: "Inter-Bold", withExtension: "otf")`
        public static func interBoldOtf(_: Void = ()) -> Foundation.URL? {
            let fileResource = R.file.interBoldOtf
            return fileResource.bundle.url(forResource: fileResource)
        }

        /// `bundle.url(forResource: "Inter-Medium", withExtension: "otf")`
        public static func interMediumOtf(_: Void = ()) -> Foundation.URL? {
            let fileResource = R.file.interMediumOtf
            return fileResource.bundle.url(forResource: fileResource)
        }

        /// `bundle.url(forResource: "Inter-Regular", withExtension: "otf")`
        public static func interRegularOtf(_: Void = ()) -> Foundation.URL? {
            let fileResource = R.file.interRegularOtf
            return fileResource.bundle.url(forResource: fileResource)
        }

        /// `bundle.url(forResource: "Inter-SemiBold", withExtension: "otf")`
        public static func interSemiBoldOtf(_: Void = ()) -> Foundation.URL? {
            let fileResource = R.file.interSemiBoldOtf
            return fileResource.bundle.url(forResource: fileResource)
        }

        /// `bundle.url(forResource: "TiemposHeadline-Semibold", withExtension: "otf")`
        public static func tiemposHeadlineSemiboldOtf(_: Void = ()) -> Foundation.URL? {
            let fileResource = R.file.tiemposHeadlineSemiboldOtf
            return fileResource.bundle.url(forResource: fileResource)
        }

        fileprivate init() {}
    }

    /// This `R.font` struct is generated, and contains static references to 7 fonts.
    public struct font: Rswift.Validatable {
        /// Font `IBMPlexSans-Medium`.
        public static let ibmPlexSansMedium = Rswift.FontResource(fontName: "IBMPlexSans-Medium")
        /// Font `IBMPlexSans`.
        public static let ibmPlexSans = Rswift.FontResource(fontName: "IBMPlexSans")
        /// Font `Inter-Bold`.
        public static let interBold = Rswift.FontResource(fontName: "Inter-Bold")
        /// Font `Inter-Medium`.
        public static let interMedium = Rswift.FontResource(fontName: "Inter-Medium")
        /// Font `Inter-Regular`.
        public static let interRegular = Rswift.FontResource(fontName: "Inter-Regular")
        /// Font `Inter-SemiBold`.
        public static let interSemiBold = Rswift.FontResource(fontName: "Inter-SemiBold")
        /// Font `TiemposHeadline-Semibold`.
        public static let tiemposHeadlineSemibold = Rswift.FontResource(fontName: "TiemposHeadline-Semibold")

        /// `UIFont(name: "IBMPlexSans", size: ...)`
        public static func ibmPlexSans(size: CGFloat) -> UIKit.UIFont? {
            UIKit.UIFont(resource: ibmPlexSans, size: size)
        }

        /// `UIFont(name: "IBMPlexSans-Medium", size: ...)`
        public static func ibmPlexSansMedium(size: CGFloat) -> UIKit.UIFont? {
            UIKit.UIFont(resource: ibmPlexSansMedium, size: size)
        }

        /// `UIFont(name: "Inter-Bold", size: ...)`
        public static func interBold(size: CGFloat) -> UIKit.UIFont? {
            UIKit.UIFont(resource: interBold, size: size)
        }

        /// `UIFont(name: "Inter-Medium", size: ...)`
        public static func interMedium(size: CGFloat) -> UIKit.UIFont? {
            UIKit.UIFont(resource: interMedium, size: size)
        }

        /// `UIFont(name: "Inter-Regular", size: ...)`
        public static func interRegular(size: CGFloat) -> UIKit.UIFont? {
            UIKit.UIFont(resource: interRegular, size: size)
        }

        /// `UIFont(name: "Inter-SemiBold", size: ...)`
        public static func interSemiBold(size: CGFloat) -> UIKit.UIFont? {
            UIKit.UIFont(resource: interSemiBold, size: size)
        }

        /// `UIFont(name: "TiemposHeadline-Semibold", size: ...)`
        public static func tiemposHeadlineSemibold(size: CGFloat) -> UIKit.UIFont? {
            UIKit.UIFont(resource: tiemposHeadlineSemibold, size: size)
        }

        public static func validate() throws {
            if R.font.ibmPlexSans(size: 42) == nil { throw Rswift.ValidationError(description: "[R.swift] Font 'IBMPlexSans' could not be loaded, is 'IBMPlexSans-Regular.ttf' added to the UIAppFonts array in this targets Info.plist?") }
            if R.font.ibmPlexSansMedium(size: 42) == nil { throw Rswift.ValidationError(description: "[R.swift] Font 'IBMPlexSans-Medium' could not be loaded, is 'IBMPlexSans-Medium.ttf' added to the UIAppFonts array in this targets Info.plist?") }
            if R.font.interBold(size: 42) == nil { throw Rswift.ValidationError(description: "[R.swift] Font 'Inter-Bold' could not be loaded, is 'Inter-Bold.otf' added to the UIAppFonts array in this targets Info.plist?") }
            if R.font.interMedium(size: 42) == nil { throw Rswift.ValidationError(description: "[R.swift] Font 'Inter-Medium' could not be loaded, is 'Inter-Medium.otf' added to the UIAppFonts array in this targets Info.plist?") }
            if R.font.interRegular(size: 42) == nil { throw Rswift.ValidationError(description: "[R.swift] Font 'Inter-Regular' could not be loaded, is 'Inter-Regular.otf' added to the UIAppFonts array in this targets Info.plist?") }
            if R.font.interSemiBold(size: 42) == nil { throw Rswift.ValidationError(description: "[R.swift] Font 'Inter-SemiBold' could not be loaded, is 'Inter-SemiBold.otf' added to the UIAppFonts array in this targets Info.plist?") }
            if R.font.tiemposHeadlineSemibold(size: 42) == nil { throw Rswift.ValidationError(description: "[R.swift] Font 'TiemposHeadline-Semibold' could not be loaded, is 'TiemposHeadline-Semibold.otf' added to the UIAppFonts array in this targets Info.plist?") }
        }

        fileprivate init() {}
    }

    /// This `R.image` struct is generated, and contains static references to 3 images.
    public struct image {
        /// Image `Composer`.
        public static let composer = Rswift.ImageResource(bundle: R.hostingBundle, name: "Composer")
        /// Image `Logo`.
        public static let logo = Rswift.ImageResource(bundle: R.hostingBundle, name: "Logo")
        /// Image `Twitter`.
        public static let twitter = Rswift.ImageResource(bundle: R.hostingBundle, name: "Twitter")

        #if os(iOS) || os(tvOS)
            /// `UIImage(named: "Composer", bundle: ..., traitCollection: ...)`
            public static func composer(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
                UIKit.UIImage(resource: R.image.composer, compatibleWith: traitCollection)
            }
        #endif

        #if os(iOS) || os(tvOS)
            /// `UIImage(named: "Logo", bundle: ..., traitCollection: ...)`
            public static func logo(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
                UIKit.UIImage(resource: R.image.logo, compatibleWith: traitCollection)
            }
        #endif

        #if os(iOS) || os(tvOS)
            /// `UIImage(named: "Twitter", bundle: ..., traitCollection: ...)`
            public static func twitter(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
                UIKit.UIImage(resource: R.image.twitter, compatibleWith: traitCollection)
            }
        #endif

        fileprivate init() {}
    }

    /// This `R.string` struct is generated, and contains static references to 1 localization tables.
    public struct string {
        /// This `R.string.localizable` struct is generated, and contains static references to 1 localization keys.
        public struct localizable {
            /// en translation: I've just listend to this episode of Luftpost Podcast. The guest really gave some exiting insights into travelling in Senegal!
            ///
            /// Locales: en
            public static let testShareMessage = Rswift.StringResource(key: "test.share.message", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)

            /// en translation: I've just listend to this episode of Luftpost Podcast. The guest really gave some exiting insights into travelling in Senegal!
            ///
            /// Locales: en
            public static func testShareMessage(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("test.share.message", bundle: hostingBundle, comment: "")
                }

                guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
                    return "test.share.message"
                }

                return NSLocalizedString("test.share.message", bundle: bundle, comment: "")
            }

            fileprivate init() {}
        }

        fileprivate init() {}
    }

    fileprivate struct intern: Rswift.Validatable {
        fileprivate static func validate() throws {
            // There are no resources to validate
        }

        fileprivate init() {}
    }

    fileprivate class Class {}

    fileprivate init() {}
}

public struct _R {
    private init() {}
}

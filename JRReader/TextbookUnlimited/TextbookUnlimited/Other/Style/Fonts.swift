//
//  Fonts.swift
//  TextbookUnlimited
//
//  Created by xhgc01 on 2018/8/8.
//  Copyright © 2018年 xhgc. All rights reserved.
//

import Foundation

struct Fonts {

    // MARK: - oldFont
    static let fourteen = UIFont.systemFont(ofSize: 14)
    static let fifteen = UIFont.systemFont(ofSize: 15)
    static let sixteen = UIFont.systemFont(ofSize: 16)

    // MARK: - Bold
    static let fourteenBold = UIFont.boldSystemFont(ofSize: 14)
    static let fifteenBold = UIFont.boldSystemFont(ofSize: 15)
    static let sixteenBold = UIFont.boldSystemFont(ofSize: 16)
    static let eighteenBold = UIFont.boldSystemFont(ofSize: 18)

    // MARK: - Regular
    static let tenRegular = Font.pingFangSCRegular.of(size: 10)
    static let fourteenRegular = Font.pingFangSCRegular.of(size: 14)
    static let fifteenRegular = Font.pingFangSCRegular.of(size: 15)
    static let sixteenRegular = Font.pingFangSCRegular.of(size: 16)
    static let eighteenRegular = Font.pingFangSCRegular.of(size: 18)

    // MARK: - Light
    static let fourteenLight = Font.pingFangSCLight.of(size: 14)
    static let fifteenLight = Font.pingFangSCLight.of(size: 15)
    static let sixteenLight = Font.pingFangSCLight.of(size: 16)

    // MARK: - size
    static let titleSize = 16
    static let optionSize = 15
    static let tipSize = 12
}

extension UIFont {
    /// Create a UIFont object with a `Font` enum
    public convenience init?(font: Font, size: CGFloat) {
        let fontIdentifier: String = font.rawValue
        self.init(name: fontIdentifier, size: size)
    }
}

public protocol FontRepresentable: RawRepresentable {}

extension FontRepresentable where Self.RawValue == String {
    /// An alternative way to get a particular `UIFont` instance from a `Font`
    /// value.
    ///
    /// - parameter of size: The desired size of the font.
    ///
    /// - returns a `UIFont` instance of the desired font family and size, or
    /// `nil` if the font family or size isn't installed.
    public func of(size: CGFloat) -> UIFont {
        return UIFont(name: rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

public enum Font: String, FontRepresentable {

    #if os(iOS)
    /*
     📱📱📱📱📱📱📱📱📱📱📱📱📱📱📱📱📱📱📱📱📱📱📱📱📱📱
     iOS Fonts
     📱📱📱📱📱📱📱📱📱📱📱📱📱📱📱📱📱📱📱📱📱📱📱📱📱📱
     */

    // Academy Engraved LET
    case academyEngravedLetPlain = "AcademyEngravedLetPlain"

    // Al Nile
    case alNileBold = "AlNile-Bold"
    case alNile = "AlNile"

    // American Typewriter
    case americanTypewriterCondensedLight = "AmericanTypewriter-CondensedLight"
    case americanTypewriter = "AmericanTypewriter"
    case americanTypewriterCondensedBold = "AmericanTypewriter-CondensedBold"
    case americanTypewriterLight = "AmericanTypewriter-Light"
    case americanTypewriterSemibold = "AmericanTypewriter-Semibold"
    case americanTypewriterBold = "AmericanTypewriter-Bold"
    case americanTypewriterCondensed = "AmericanTypewriter-Condensed"

    // Apple Color Emoji
    case appleColorEmoji = "AppleColorEmoji"

    // Apple SD Gothic Neo
    case appleSDGothicNeoBold = "AppleSDGothicNeo-Bold"
    case appleSDGothicNeoUltraLight = "AppleSDGothicNeo-UltraLight"
    case appleSDGothicNeoThin = "AppleSDGothicNeo-Thin"
    case appleSDGothicNeoRegular = "AppleSDGothicNeo-Regular"
    case appleSDGothicNeoLight = "AppleSDGothicNeo-Light"
    case appleSDGothicNeoMedium = "AppleSDGothicNeo-Medium"
    case appleSDGothicNeoSemiBold = "AppleSDGothicNeo-SemiBold"

    // Arial
    case arialMT = "ArialMT"
    case arialBoldItalicMT = "Arial-BoldItalicMT"
    case arialBoldMT = "Arial-BoldMT"
    case arialItalicMT = "Arial-ItalicMT"

    // Arial Hebrew
    case arialHebrewBold = "ArialHebrew-Bold"
    case arialHebrewLight = "ArialHebrew-Light"
    case arialHebrew = "ArialHebrew"

    // Arial Rounded MT Bold
    case arialRoundedMTBold = "ArialRoundedMTBold"

    // Avenir
    case avenirMedium = "Avenir-Medium"
    case avenirHeavyOblique = "Avenir-HeavyOblique"
    case avenirBook = "Avenir-Book"
    case avenirLight = "Avenir-Light"
    case avenirRoman = "Avenir-Roman"
    case avenirBookOblique = "Avenir-BookOblique"
    case avenirMediumOblique = "Avenir-MediumOblique"
    case avenirBlack = "Avenir-Black"
    case avenirBlackOblique = "Avenir-BlackOblique"
    case avenirHeavy = "Avenir-Heavy"
    case avenirLightOblique = "Avenir-LightOblique"
    case avenirOblique = "Avenir-Oblique"

    // Avenir Next
    case avenirNextUltraLight = "AvenirNext-UltraLight"
    case avenirNextUltraLightItalic = "AvenirNext-UltraLightItalic"
    case avenirNextBold = "AvenirNext-Bold"
    case avenirNextBoldItalic = "AvenirNext-BoldItalic"
    case avenirNextDemiBold = "AvenirNext-DemiBold"
    case avenirNextDemiBoldItalic = "AvenirNext-DemiBoldItalic"
    case avenirNextMedium = "AvenirNext-Medium"
    case avenirNextHeavyItalic = "AvenirNext-HeavyItalic"
    case avenirNextHeavy = "AvenirNext-Heavy"
    case avenirNextItalic = "AvenirNext-Italic"
    case avenirNextRegular = "AvenirNext-Regular"
    case avenirNextMediumItalic = "AvenirNext-MediumItalic"

    // Avenir Next Condensed
    case avenirNextCondensedBoldItalic = "AvenirNextCondensed-BoldItalic"
    case avenirNextCondensedHeavy = "AvenirNextCondensed-Heavy"
    case avenirNextCondensedMedium = "AvenirNextCondensed-Medium"
    case avenirNextCondensedRegular = "AvenirNextCondensed-Regular"
    case avenirNextCondensedHeavyItalic = "AvenirNextCondensed-HeavyItalic"
    case avenirNextCondensedMediumItalic = "AvenirNextCondensed-MediumItalic"
    case avenirNextCondensedItalic = "AvenirNextCondensed-Italic"
    case avenirNextCondensedUltraLightItalic = "AvenirNextCondensed-UltraLightItalic"
    case avenirNextCondensedUltraLight = "AvenirNextCondensed-UltraLight"
    case avenirNextCondensedDemiBold = "AvenirNextCondensed-DemiBold"
    case avenirNextCondensedBold = "AvenirNextCondensed-Bold"
    case avenirNextCondensedDemiBoldItalic = "AvenirNextCondensed-DemiBoldItalic"

    // Baskerville
    case baskervilleItalic = "Baskerville-Italic"
    case baskervilleSemiBold = "Baskerville-SemiBold"
    case baskervilleBoldItalic = "Baskerville-BoldItalic"
    case baskervilleSemiBoldItalic = "Baskerville-SemiBoldItalic"
    case baskervilleBold = "Baskerville-Bold"
    case baskerville = "Baskerville"

    // Bodoni 72
    case bodoniSvtyTwoITCTTBold = "BodoniSvtyTwoITCTT-Bold"
    case bodoniSvtyTwoITCTTBook = "BodoniSvtyTwoITCTT-Book"
    case bodoniSvtyTwoITCTTBookIta = "BodoniSvtyTwoITCTT-BookIta"

    // Bodoni 72 Oldstyle
    case bodoniSvtyTwoOSITCTTBook = "BodoniSvtyTwoOSITCTT-Book"
    case bodoniSvtyTwoOSITCTTBold = "BodoniSvtyTwoOSITCTT-Bold"
    case bodoniSvtyTwoOSITCTTBookIt = "BodoniSvtyTwoOSITCTT-BookIt"

    // Bodoni 72 Smallcaps
    case bodoniSvtyTwoSCITCTTBook = "BodoniSvtyTwoSCITCTT-Book"

    // Bodoni Ornaments
    case bodoniOrnamentsITCTT = "BodoniOrnamentsITCTT"

    // Bradley Hand
    case bradleyHandITCTTBold = "BradleyHandITCTT-Bold"

    // Chalkboard SE
    case chalkboardSEBold = "ChalkboardSE-Bold"
    case chalkboardSELight = "ChalkboardSE-Light"
    case chalkboardSERegular = "ChalkboardSE-Regular"

    // Chalkduster
    case chalkduster = "Chalkduster"

    // Cochin
    case cochinBold = "Cochin-Bold"
    case cochin = "Cochin"
    case cochinItalic = "Cochin-Italic"
    case cochinBoldItalic = "Cochin-BoldItalic"

    // Copperplate
    case copperplateLight = "Copperplate-Light"
    case copperplate = "Copperplate"
    case copperplateBold = "Copperplate-Bold"

    // Courier
    case courierBoldOblique = "Courier-BoldOblique"
    case courier = "Courier"
    case courierBold = "Courier-Bold"
    case courierOblique = "Courier-Oblique"

    // Courier New
    case courierNewPSBoldMT = "CourierNewPS-BoldMT"
    case courierNewPSItalicMT = "CourierNewPS-ItalicMT"
    case courierNewPSMT = "CourierNewPSMT"
    case courierNewPSBoldItalicMT = "CourierNewPS-BoldItalicMT"

    // Damascus
    case damascusLight = "DamascusLight"
    case damascusBold = "DamascusBold"
    case damascusSemiBold = "DamascusSemiBold"
    case damascusMedium = "DamascusMedium"
    case damascus = "Damascus"

    // Devanagari Sangam MN
    case devanagariSangamMN = "DevanagariSangamMN"
    case devanagariSangamMNBold = "DevanagariSangamMN-Bold"

    // Didot
    case didotItalic = "Didot-Italic"
    case didotBold = "Didot-Bold"
    case didot = "Didot"

    // Euphemia UCAS
    case euphemiaUCASItalic = "EuphemiaUCAS-Italic"
    case euphemiaUCAS = "EuphemiaUCAS"
    case euphemiaUCASBold = "EuphemiaUCAS-Bold"

    // Farah
    case farah = "Farah"

    // Futura
    case futuraCondensedMedium = "Futura-CondensedMedium"
    case futuraCondensedExtraBold = "Futura-CondensedExtraBold"
    case futuraMedium = "Futura-Medium"
    case futuraMediumItalic = "Futura-MediumItalic"
    case futuraBold = "Futura-Bold"

    // Geeza Pro
    case geezaPro = "GeezaPro"
    case geezaProBold = "GeezaPro-Bold"

    // Georgia
    case georgiaBoldItalic = "Georgia-BoldItalic"
    case georgia = "Georgia"
    case georgiaItalic = "Georgia-Italic"
    case georgiaBold = "Georgia-Bold"

    // Gill Sans
    case gillSansItalic = "GillSans-Italic"
    case gillSansBold = "GillSans-Bold"
    case gillSansBoldItalic = "GillSans-BoldItalic"
    case gillSansLightItalic = "GillSans-LightItalic"
    case gillSans = "GillSans"
    case gillSansLight = "GillSans-Light"
    case gillSansSemiBold = "GillSans-SemiBold"
    case gillSansSemiBoldItalic = "GillSans-SemiBoldItalic"
    case gillSansUltraBold = "GillSans-UltraBold"

    // Gujarati Sangam MN
    case gujaratiSangamMNBold = "GujaratiSangamMN-Bold"
    case gujaratiSangamMN = "GujaratiSangamMN"

    // Gurmukhi MN
    case gurmukhiMNBold = "GurmukhiMN-Bold"
    case gurmukhiMN = "GurmukhiMN"

    // Helvetica
    case helveticaBold = "Helvetica-Bold"
    case helvetica = "Helvetica"
    case helveticaLightOblique = "Helvetica-LightOblique"
    case helveticaOblique = "Helvetica-Oblique"
    case helveticaBoldOblique = "Helvetica-BoldOblique"
    case helveticaLight = "Helvetica-Light"

    // Helvetica Neue
    case helveticaNeueItalic = "HelveticaNeue-Italic"
    case helveticaNeueBold = "HelveticaNeue-Bold"
    case helveticaNeueUltraLight = "HelveticaNeue-UltraLight"
    case helveticaNeueCondensedBlack = "HelveticaNeue-CondensedBlack"
    case helveticaNeueBoldItalic = "HelveticaNeue-BoldItalic"
    case helveticaNeueCondensedBold = "HelveticaNeue-CondensedBold"
    case helveticaNeueMedium = "HelveticaNeue-Medium"
    case helveticaNeueLight = "HelveticaNeue-Light"
    case helveticaNeueThin = "HelveticaNeue-Thin"
    case helveticaNeueThinItalic = "HelveticaNeue-ThinItalic"
    case helveticaNeueLightItalic = "HelveticaNeue-LightItalic"
    case helveticaNeueUltraLightItalic = "HelveticaNeue-UltraLightItalic"
    case helveticaNeueMediumItalic = "HelveticaNeue-MediumItalic"
    case helveticaNeue = "HelveticaNeue"

    // Hiragino Mincho ProN
    case hiraMinProNW6 = "HiraMinProN-W6"
    case hiraMinProNW3 = "HiraMinProN-W3"

    // Hiragino Sans
    case hiraginoSansW3 = "HiraginoSans-W3"
    case hiraginoSansW6 = "HiraginoSans-W6"

    // Hoefler Text
    case hoeflerTextItalic = "HoeflerText-Italic"
    case hoeflerTextRegular = "HoeflerText-Regular"
    case hoeflerTextBlack = "HoeflerText-Black"
    case hoeflerTextBlackItalic = "HoeflerText-BlackItalic"

    // Kailasa
    case kailasaBold = "Kailasa-Bold"
    case kailasa = "Kailasa"

    // Kannada Sangam MN
    case kannadaSangamMN = "KannadaSangamMN"
    case kannadaSangamMNBold = "KannadaSangamMN-Bold"

    // Khmer Sangam MN
    case khmerSangamMN = "KhmerSangamMN"

    // Kohinoor Bangla
    case kohinoorBanglaSemibold = "KohinoorBangla-Semibold"
    case kohinoorBanglaRegular = "KohinoorBangla-Regular"
    case kohinoorBanglaLight = "KohinoorBangla-Light"

    // Kohinoor Devanagari
    case kohinoorDevanagariLight = "KohinoorDevanagari-Light"
    case kohinoorDevanagariRegular = "KohinoorDevanagari-Regular"
    case kohinoorDevanagariSemibold = "KohinoorDevanagari-Semibold"

    // Kohinoor Telugu
    case kohinoorTeluguRegular = "KohinoorTelugu-Regular"
    case kohinoorTeluguMedium = "KohinoorTelugu-Medium"
    case kohinoorTeluguLight = "KohinoorTelugu-Light"

    // Lao Sangam MN
    case laoSangamMN = "LaoSangamMN"

    // Malayalam Sangam MN
    case malayalamSangamMNBold = "MalayalamSangamMN-Bold"
    case malayalamSangamMN = "MalayalamSangamMN"

    // Marker Felt
    case markerFeltThin = "MarkerFelt-Thin"
    case markerFeltWide = "MarkerFelt-Wide"

    // Menlo
    case menloItalic = "Menlo-Italic"
    case menloBold = "Menlo-Bold"
    case menloRegular = "Menlo-Regular"
    case menloBoldItalic = "Menlo-BoldItalic"

    // Mishafi
    case diwanMishafi = "DiwanMishafi"

    // Myanmar Sangam MN
    case myanmarSangamMNBold = "MyanmarSangamMN-Bold"
    case myanmarSangamMN = "MyanmarSangamMN"

    // Noteworthy
    case noteworthyLight = "Noteworthy-Light"
    case noteworthyBold = "Noteworthy-Bold"

    // Optima
    case optimaRegular = "Optima-Regular"
    case optimaExtraBlack = "Optima-ExtraBlack"
    case optimaBoldItalic = "Optima-BoldItalic"
    case optimaItalic = "Optima-Italic"
    case optimaBold = "Optima-Bold"

    // Oriya Sangam MN
    case oriyaSangamMN = "OriyaSangamMN"
    case oriyaSangamMNBold = "OriyaSangamMN-Bold"

    // Palatino
    case palatinoBold = "Palatino-Bold"
    case palatinoRoman = "Palatino-Roman"
    case palatinoBoldItalic = "Palatino-BoldItalic"
    case palatinoItalic = "Palatino-Italic"

    // Papyrus
    case papyrus = "Papyrus"
    case papyrusCondensed = "Papyrus-Condensed"

    // Party LET
    case partyLetPlain = "PartyLetPlain"

    // PingFang HK
    case pingFangHKUltralight = "PingFangHK-Ultralight"
    case pingFangHKSemibold = "PingFangHK-Semibold"
    case pingFangHKThin = "PingFangHK-Thin"
    case pingFangHKLight = "PingFangHK-Light"
    case pingFangHKRegular = "PingFangHK-Regular"
    case pingFangHKMedium = "PingFangHK-Medium"

    // PingFang SC
    case pingFangSCUltralight = "PingFangSC-Ultralight"
    case pingFangSCRegular = "PingFangSC-Regular"
    case pingFangSCSemibold = "PingFangSC-Semibold"
    case pingFangSCThin = "PingFangSC-Thin"
    case pingFangSCLight = "PingFangSC-Light"
    case pingFangSCMedium = "PingFangSC-Medium"

    // PingFang TC
    case pingFangTCMedium = "PingFangTC-Medium"
    case pingFangTCRegular = "PingFangTC-Regular"
    case pingFangTCLight = "PingFangTC-Light"
    case pingFangTCUltralight = "PingFangTC-Ultralight"
    case pingFangTCSemibold = "PingFangTC-Semibold"
    case pingFangTCThin = "PingFangTC-Thin"

    // Savoye LET
    case savoyeLetPlain = "SavoyeLetPlain"

    // Sinhala Sangam MN
    case sinhalaSangamMNBold = "SinhalaSangamMN-Bold"
    case sinhalaSangamMN = "SinhalaSangamMN"

    // Snell Roundhand
    case snellRoundhandBold = "SnellRoundhand-Bold"
    case snellRoundhand = "SnellRoundhand"
    case snellRoundhandBlack = "SnellRoundhand-Black"

    // Symbol
    case symbol = "Symbol"

    // Tamil Sangam MN
    case tamilSangamMN = "TamilSangamMN"
    case tamilSangamMNBold = "TamilSangamMN-Bold"

    // Thonburi
    case thonburi = "Thonburi"
    case thonburiBold = "Thonburi-Bold"
    case thonburiLight = "Thonburi-Light"

    // Times New Roman
    case timesNewRomanPSMT = "TimesNewRomanPSMT"
    case timesNewRomanPSBoldItalicMT = "TimesNewRomanPS-BoldItalicMT"
    case timesNewRomanPSItalicMT = "TimesNewRomanPS-ItalicMT"
    case timesNewRomanPSBoldMT = "TimesNewRomanPS-BoldMT"

    // Trebuchet MS
    case trebuchetBoldItalic = "Trebuchet-BoldItalic"
    case trebuchetMS = "TrebuchetMS"
    case trebuchetMSBold = "TrebuchetMS-Bold"
    case trebuchetMSItalic = "TrebuchetMS-Italic"

    // Verdana
    case verdanaItalic = "Verdana-Italic"
    case verdanaBoldItalic = "Verdana-BoldItalic"
    case verdana = "Verdana"
    case verdanaBold = "Verdana-Bold"

    // Zapf Dingbats
    case zapfDingbatsITC = "ZapfDingbatsITC"

    // Zapfino
    case zapfino = "Zapfino"

    #elseif os(tvOS)
    /*
     📺📺📺📺📺📺📺📺📺📺📺📺📺📺📺📺📺📺📺📺📺📺
     tvOS Fonts
     📺📺📺📺📺📺📺📺📺📺📺📺📺📺📺📺📺📺📺📺📺📺
     */

    // American Typewriter
    case americanTypewriterBold = "AmericanTypewriter-Bold"
    case americanTypewriterCondensedLight = "AmericanTypewriter-CondensedLight"
    case americanTypewriterSemibold = "AmericanTypewriter-Semibold"
    case americanTypewriterCondensedBold = "AmericanTypewriter-CondensedBold"
    case americanTypewriter = "AmericanTypewriter"
    case americanTypewriterLight = "AmericanTypewriter-Light"
    case americanTypewriterCondensed = "AmericanTypewriter-Condensed"

    // Apple Color Emoji
    case appleColorEmoji = "AppleColorEmoji"

    // Apple SD Gothic Neo
    case appleSDGothicNeoThin = "AppleSDGothicNeo-Thin"
    case appleSDGothicNeoSemiBold = "AppleSDGothicNeo-SemiBold"
    case appleSDGothicNeoLight = "AppleSDGothicNeo-Light"
    case appleSDGothicNeoMedium = "AppleSDGothicNeo-Medium"
    case appleSDGothicNeoBold = "AppleSDGothicNeo-Bold"
    case appleSDGothicNeoUltraLight = "AppleSDGothicNeo-UltraLight"
    case appleSDGothicNeoRegular = "AppleSDGothicNeo-Regular"

    // Arial Hebrew
    case arialHebrewLight = "ArialHebrew-Light"
    case arialHebrew = "ArialHebrew"
    case arialHebrewBold = "ArialHebrew-Bold"

    // Avenir
    case avenirBook = "Avenir-Book"
    case avenirHeavy = "Avenir-Heavy"
    case avenirBlackOblique = "Avenir-BlackOblique"
    case avenirBlack = "Avenir-Black"
    case avenirLightOblique = "Avenir-LightOblique"
    case avenirLight = "Avenir-Light"
    case avenirBookOblique = "Avenir-BookOblique"
    case avenirMedium = "Avenir-Medium"
    case avenirHeavyOblique = "Avenir-HeavyOblique"
    case avenirOblique = "Avenir-Oblique"
    case avenirRoman = "Avenir-Roman"
    case avenirMediumOblique = "Avenir-MediumOblique"

    // Avenir Next
    case avenirNextDemiBold = "AvenirNext-DemiBold"
    case avenirNextUltraLight = "AvenirNext-UltraLight"
    case avenirNextRegular = "AvenirNext-Regular"
    case avenirNextHeavyItalic = "AvenirNext-HeavyItalic"
    case avenirNextBoldItalic = "AvenirNext-BoldItalic"
    case avenirNextMediumItalic = "AvenirNext-MediumItalic"
    case avenirNextItalic = "AvenirNext-Italic"
    case avenirNextHeavy = "AvenirNext-Heavy"
    case avenirNextDemiBoldItalic = "AvenirNext-DemiBoldItalic"
    case avenirNextBold = "AvenirNext-Bold"
    case avenirNextUltraLightItalic = "AvenirNext-UltraLightItalic"
    case avenirNextMedium = "AvenirNext-Medium"

    // Baskerville
    case baskervilleSemiBoldItalic = "Baskerville-SemiBoldItalic"
    case baskervilleSemiBold = "Baskerville-SemiBold"
    case baskerville = "Baskerville"
    case baskervilleBoldItalic = "Baskerville-BoldItalic"
    case baskervilleItalic = "Baskerville-Italic"
    case baskervilleBold = "Baskerville-Bold"

    // Copperplate
    case copperplate = "Copperplate"
    case copperplateLight = "Copperplate-Light"
    case copperplateBold = "Copperplate-Bold"

    // Courier
    case courierBoldOblique = "Courier-BoldOblique"
    case courier = "Courier"
    case courierBold = "Courier-Bold"
    case courierOblique = "Courier-Oblique"

    // Courier New
    case courierNewPSMT = "CourierNewPSMT"
    case courierNewPSBoldItalicMT = "CourierNewPS-BoldItalicMT"
    case courierNewPSBoldMT = "CourierNewPS-BoldMT"
    case courierNewPSItalicMT = "CourierNewPS-ItalicMT"

    // Euphemia UCAS
    case euphemiaUCAS = "EuphemiaUCAS"
    case euphemiaUCASBold = "EuphemiaUCAS-Bold"
    case euphemiaUCASItalic = "EuphemiaUCAS-Italic"

    // Futura
    case futuraBold = "Futura-Bold"
    case futuraMediumItalic = "Futura-MediumItalic"
    case futuraCondensedExtraBold = "Futura-CondensedExtraBold"
    case futuraCondensedMedium = "Futura-CondensedMedium"
    case futuraMedium = "Futura-Medium"

    // Geeza Pro
    case geezaProBold = "GeezaPro-Bold"
    case geezaPro = "GeezaPro"

    // Gujarati Sangam MN
    case gujaratiSangamMNBold = "GujaratiSangamMN-Bold"
    case gujaratiSangamMN = "GujaratiSangamMN"

    // Gurmukhi MN
    case gurmukhiMN = "GurmukhiMN"
    case gurmukhiMNBold = "GurmukhiMN-Bold"

    // Helvetica
    case helveticaOblique = "Helvetica-Oblique"
    case helveticaBold = "Helvetica-Bold"
    case helveticaLightOblique = "Helvetica-LightOblique"
    case helveticaBoldOblique = "Helvetica-BoldOblique"
    case helveticaLight = "Helvetica-Light"
    case helvetica = "Helvetica"

    // Helvetica Neue
    case helveticaNeueUltraLight = "HelveticaNeue-UltraLight"
    case helveticaNeueUltraLightItalic = "HelveticaNeue-UltraLightItalic"
    case helveticaNeueLightItalic = "HelveticaNeue-LightItalic"
    case helveticaNeue = "HelveticaNeue"
    case helveticaNeueLight = "HelveticaNeue-Light"
    case helveticaNeueMediumItalic = "HelveticaNeue-MediumItalic"
    case helveticaNeueCondensedBold = "HelveticaNeue-CondensedBold"
    case helveticaNeueCondensedBlack = "HelveticaNeue-CondensedBlack"
    case helveticaNeueThinItalic = "HelveticaNeue-ThinItalic"
    case helveticaNeueThin = "HelveticaNeue-Thin"
    case helveticaNeueMedium = "HelveticaNeue-Medium"
    case helveticaNeueItalic = "HelveticaNeue-Italic"
    case helveticaNeueBoldItalic = "HelveticaNeue-BoldItalic"
    case helveticaNeueBold = "HelveticaNeue-Bold"

    // Hiragino Maru Gothic ProN
    case hiraMaruProNW4 = "HiraMaruProN-W4"

    // Hiragino Sans
    case hiraginoSansW5 = "HiraginoSans-W5"
    case hiraginoSansW6 = "HiraginoSans-W6"
    case hiraginoSansW3 = "HiraginoSans-W3"

    // Kailasa
    case kailasa = "Kailasa"
    case kailasaBold = "Kailasa-Bold"

    // Kannada Sangam MN
    case kannadaSangamMNBold = "KannadaSangamMN-Bold"
    case kannadaSangamMN = "KannadaSangamMN"

    // Kefa
    case kefaRegular = "Kefa-Regular"

    // Khmer Sangam MN
    case khmerSangamMN = "KhmerSangamMN"

    // Kohinoor Bangla
    case kohinoorBanglaRegular = "KohinoorBangla-Regular"
    case kohinoorBanglaSemibold = "KohinoorBangla-Semibold"
    case kohinoorBanglaLight = "KohinoorBangla-Light"

    // Kohinoor Devanagari
    case kohinoorDevanagariLight = "KohinoorDevanagari-Light"
    case kohinoorDevanagariRegular = "KohinoorDevanagari-Regular"
    case kohinoorDevanagariSemibold = "KohinoorDevanagari-Semibold"

    // Kohinoor Telugu
    case kohinoorTeluguLight = "KohinoorTelugu-Light"
    case kohinoorTeluguMedium = "KohinoorTelugu-Medium"
    case kohinoorTeluguRegular = "KohinoorTelugu-Regular"

    // Lao Sangam MN
    case laoSangamMN = "LaoSangamMN"

    // Malayalam Sangam MN
    case malayalamSangamMN = "MalayalamSangamMN"
    case malayalamSangamMNBold = "MalayalamSangamMN-Bold"

    // Menlo
    case menloBoldItalic = "Menlo-BoldItalic"
    case menloItalic = "Menlo-Italic"
    case menloRegular = "Menlo-Regular"
    case menloBold = "Menlo-Bold"

    // Myanmar Sangam MN
    case myanmarSangamMN = "MyanmarSangamMN"
    case myanmarSangamMNBold = "MyanmarSangamMN-Bold"

    // Noto Nastaliq Urdu
    case notoNastaliqUrdu = "NotoNastaliqUrdu"

    // Oriya Sangam MN
    case oriyaSangamMNBold = "OriyaSangamMN-Bold"
    case oriyaSangamMN = "OriyaSangamMN"

    // PingFang HK
    case pingFangHKRegular = "PingFangHK-Regular"
    case pingFangHKMedium = "PingFangHK-Medium"
    case pingFangHKThin = "PingFangHK-Thin"
    case pingFangHKSemibold = "PingFangHK-Semibold"
    case pingFangHKLight = "PingFangHK-Light"
    case pingFangHKUltralight = "PingFangHK-Ultralight"

    // PingFang SC
    case pingFangSCRegular = "PingFangSC-Regular"
    case pingFangSCUltralight = "PingFangSC-Ultralight"
    case pingFangSCThin = "PingFangSC-Thin"
    case pingFangSCMedium = "PingFangSC-Medium"
    case pingFangSCLight = "PingFangSC-Light"
    case pingFangSCSemibold = "PingFangSC-Semibold"

    // PingFang TC
    case pingFangTCSemibold = "PingFangTC-Semibold"
    case pingFangTCMedium = "PingFangTC-Medium"
    case pingFangTCRegular = "PingFangTC-Regular"
    case pingFangTCUltralight = "PingFangTC-Ultralight"
    case pingFangTCLight = "PingFangTC-Light"
    case pingFangTCThin = "PingFangTC-Thin"

    // Savoye LET
    case savoyeLetPlain = "SavoyeLetPlain"

    // Sinhala Sangam MN
    case sinhalaSangamMNBold = "SinhalaSangamMN-Bold"
    case sinhalaSangamMN = "SinhalaSangamMN"

    // Symbol
    case symbol = "Symbol"

    // Tamil Sangam MN
    case tamilSangamMN = "TamilSangamMN"
    case tamilSangamMNBold = "TamilSangamMN-Bold"

    // Thonburi
    case thonburi = "Thonburi"
    case thonburiBold = "Thonburi-Bold"
    case thonburiLight = "Thonburi-Light"

    // Times New Roman
    case timesNewRomanPSItalicMT = "TimesNewRomanPS-ItalicMT"
    case timesNewRomanPSBoldItalicMT = "TimesNewRomanPS-BoldItalicMT"
    case timesNewRomanPSMT = "TimesNewRomanPSMT"
    case timesNewRomanPSBoldMT = "TimesNewRomanPS-BoldMT"

    // Trebuchet MS
    case trebuchetMSItalic = "TrebuchetMS-Italic"
    case trebuchetMSBold = "TrebuchetMS-Bold"
    case trebuchetBoldItalic = "Trebuchet-BoldItalic"
    case trebuchetMS = "TrebuchetMS"

    // Zapf Dingbats
    case zapfDingbatsITC = "ZapfDingbatsITC"
    #endif
}

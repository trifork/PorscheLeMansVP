//
//  Assets.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 13/05/2024.
//

import SwiftUI

public enum Asset {
    public enum Fonts {
        public static func porscheBold(size: CGFloat) -> Font {
            return .custom("PorscheNext-Bold", fixedSize: size)
        }
        public static func porscheBoldItalic(size: CGFloat) -> Font {
            return .custom("PorscheNext-BoldItalic", fixedSize: size)
        }
        public static func porscheRegular(size: CGFloat) -> Font {
            return .custom("PorscheNext-Regular", fixedSize: size)
        }
        public static func porscheRegularItalic(size: CGFloat) -> Font {
            return .custom("PorscheNext-RegularItalic", fixedSize: size)
        }
        public static func porscheSemiBold(size: CGFloat) -> Font {
            return .custom("PorscheNext-SemiBold", fixedSize: size)
        }
        public static func porscheSemiBoldItalic(size: CGFloat) -> Font {
            return .custom("PorscheNext-SemiBoldItalic", fixedSize: size)
        }
        public static func porscheThin(size: CGFloat) -> Font {
            return .custom("PorscheNext-Thin", fixedSize: size)
        }
        public static func porscheThinItalic(size: CGFloat) -> Font {
            return .custom("PorscheNext-ThinItalic", fixedSize: size)
        }
        public static func digitalNumbersRegular(size: CGFloat) -> Font {
            return Font.custom("DigitalNumbers-Regular", fixedSize: size)
        }
    }    
}

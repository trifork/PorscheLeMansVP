//
//  IconTextView.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 16/05/2024.
//

import SwiftUI

public struct IconTextView: View {
    private let icon: Image
    private let text: String
    private let alignment: IconTextAlignment
    
    public enum IconTextAlignment {
        case horizontal
        case vertical
    }
    
    public init(icon: Image, text: String, alignment: IconTextAlignment) {
        self.icon = icon
        self.text = text
        self.alignment = alignment
    }
    
    public var body: some View {
        switch self.alignment {
        case .horizontal:
            HStack {
                IconTextContentView(icon: icon, text: text, alignment: .leading)
            }
        case .vertical:
            VStack {
                IconTextContentView(icon: icon, text: text, alignment: .center)
            }
        }
    }
}

public struct IconTextContentView: View {
    private let icon: Image
    private let text: String
    private var alignment: Alignment
    
    public init(icon: Image, text: String, alignment: Alignment) {
        self.icon = icon
        self.text = text
        self.alignment = alignment
    }
    
    public var body: some View {
        icon.frame(height: 32)

        Text(text)
            .font(.system(size: 18, weight: .semibold))
            .frame(maxWidth: .infinity, alignment: self.alignment)
            .background(.clear)
    }
}


//
//  ThermometerTextView.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 16/05/2024.
//

import SwiftUI

public struct ThermometerTextView: View {
    private var alignment: ThermometerTextAlignment
    private let isLeft: Bool
    
    public init(alignment: ThermometerTextAlignment) {
        self.alignment = alignment
        self.isLeft = (alignment == .left)
    }
    
    public var body: some View {
        VStack(alignment: isLeft ? .trailing : .leading) {
            Text("100").font(.system(size: 16, weight: .regular))
            Spacer()
            Text("75").font(.system(size: 16, weight: .regular))
            Spacer()
            Text("50").font(.system(size: 16, weight: .regular))
            Spacer()
            Text("25").font(.system(size: 16, weight: .regular))
            Spacer()
            Text("0").font(.system(size: 16, weight: .regular))
        }
    }
}

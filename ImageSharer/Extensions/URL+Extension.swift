//
//  URL+Extension.swift
//  ImageSharer
//
//  Created by Ranjith Kumar on 10/5/18.
//  Copyright © 2018 Drawrect. All rights reserved.
//

import Foundation

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = URL(string: value)!
    }
}




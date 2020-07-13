//
//  ForEach2.swift
//  CoronaKiller
//
//  Created by 한석희 on 2020/07/13.
//  Copyright © 2020 suckyDuke. All rights reserved.
//

import Foundation
import SwiftUI

public extension ForEach where Content: View {
  init<Base: RandomAccessCollection>(
    _ base: Base,
    @ViewBuilder content: @escaping (Base.Index) -> Content
  )
  where
    Data == IndexedCollection<Base>,
    Base.Element: Identifiable,
    ID == Base.Element.ID
  {
    self.init(IndexedCollection(base), id: \.element.id) {
      index, _ in content(index)
    }
  }
}

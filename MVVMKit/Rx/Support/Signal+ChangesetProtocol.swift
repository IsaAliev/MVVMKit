//
//  The MIT License (MIT)
//
//  Copyright (c) 2018 DeclarativeHub/Bond
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

extension OrderedCollectionDiff where Index: Hashable {

    public func transformingIndices<NewIndex>(fromIndexMap: [Index: NewIndex], toIndexMap: [Index: NewIndex]) -> OrderedCollectionDiff<NewIndex> {
        var inserts = self.inserts.compactMap { toIndexMap[$0] }
        var deletes = self.deletes.compactMap { fromIndexMap[$0] }
        let moves = self.moves.compactMap { (move: (from: Index, to: Index)) -> (from: NewIndex, to: NewIndex)? in
            if let mappedFrom = fromIndexMap[move.from], let mappedTo = toIndexMap[move.to] {
                return (from: mappedFrom, to: mappedTo)
            } else {
                return nil
            }
        }
        var updates: [NewIndex] = []
        for index in self.updates {
            if let mappedIndex = toIndexMap[index] {
                if let _ = fromIndexMap[index] {
                    updates.append(mappedIndex)
                } else {
                    inserts.append(mappedIndex)
                }
            } else if let mappedIndex = fromIndexMap[index] {
                deletes.append(mappedIndex)
            }
        }
        return OrderedCollectionDiff<NewIndex>(inserts: inserts, deletes: deletes, updates: updates, moves: moves)
    }
}

extension UnorderedCollectionDiff where Index: Hashable {

    public func transformingIndices<NewIndex>(fromIndexMap: [Index: NewIndex], toIndexMap: [Index: NewIndex]) -> UnorderedCollectionDiff<NewIndex> {
        var inserts = self.inserts.compactMap { toIndexMap[$0] }
        var deletes = self.deletes.compactMap { fromIndexMap[$0] }
        var updates: [NewIndex] = []
        for index in self.updates {
            if let mappedIndex = toIndexMap[index] {
                if let _ = fromIndexMap[index] {
                    updates.append(mappedIndex)
                } else {
                    inserts.append(mappedIndex)
                }
            } else if let mappedIndex = fromIndexMap[index] {
                deletes.append(mappedIndex)
            }
        }
        return UnorderedCollectionDiff<NewIndex>(inserts: inserts, deletes: deletes, updates: updates)
    }
}

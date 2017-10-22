//
//  Array+Extension.swift
//  Everest
//
//  Created by Kavita Gaitonde on 10/22/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import Foundation

extension Array {
    
    func toDictionary<Key: Hashable>(with selectKey: (Element) -> Key) -> [Key:Element] {
        var dict = [Key:Element]()
        for element in self {
            dict[selectKey(element)] = element
        }
        return dict
    }
    
    
}

//
//  CallSiteItem.swift
//  ApkAnalyzer
//
//  Created by Qing Xu on 9/9/19.
//

import Common

struct CallSiteIDItem {
    let call_site_off: UInt32
    
    init?(_ data:DataInputStream) {
        guard let call_site_off = try? data.readU4() else {
            return nil
        }
        
        self.call_site_off = call_site_off
    }
}

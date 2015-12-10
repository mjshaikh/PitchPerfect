//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Mohammed Shaikh on 2015-11-19.
//  Copyright © 2015 Zaytun Lab. All rights reserved.
//

import Foundation

/* Our model class to hold the recorded audio data */

class RecordedAudio {
    var filePathUrl: NSURL!
    var title: String!
    
    /* initializer to set our global variables */
    
    init(filePathUrl: NSURL, title: String){
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
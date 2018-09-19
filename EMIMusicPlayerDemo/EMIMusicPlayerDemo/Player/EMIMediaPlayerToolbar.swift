//
//  EMIMediaPlayerToolbar.swift
//  Orbi
//
//  Created by GWL on 20/08/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit


protocol EMIMediaPlayerToolbarDelegate {
    func mediaPlayer(didTapPlayPauseButton button:UIButton)
}

class EMIMediaPlayerToolbar: UIView {
    
    @IBOutlet weak var buttonShuffle: UIButton!
    @IBOutlet weak var buttonBackward: UIButton!
    @IBOutlet weak var buttonForward: UIButton!
    @IBOutlet weak var buttonPlayPause: UIButton!
    @IBOutlet weak var buttonHeart: UIButton!
 
    var delegate:EMIMediaPlayerToolbarDelegate?
    static let instance = EMIMediaPlayerToolbar()
    
    class func instanceFromNib() -> EMIMediaPlayerToolbar {
        return UINib(nibName: "EMIMediaPlayerToolbar", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EMIMediaPlayerToolbar
    }
    
    
    @IBAction func actionPlayPause(_ sender: UIButton) {
        delegate?.mediaPlayer(didTapPlayPauseButton: sender)
    }
    
    @IBAction func actionLike(_ sender: UIButton) {
        
        
        
    }
    
    @IBAction func actionShuffle(_ sender: Any) {
    }
}

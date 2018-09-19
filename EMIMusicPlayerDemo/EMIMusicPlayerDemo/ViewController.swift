//
//  ViewController.swift
//  EMIMusicPlayerDemo
//
//  Created by Imran Malik on 20/09/18.
//  Copyright © 2018 Era. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mediaPlayer: EMIMediaPlayer!
    let kPlayerStopNatification = Notification.Name("kPlayerStopNatification")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayer()
        NotificationCenter.default.addObserver(self, selector: #selector(stopPlayer), name: kPlayerStopNatification, object: nil)
    }

    fileprivate func setupPlayer(){
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "song", ofType:"mp3")!)
        let song = Song(name: "Dimelo", detail: "Enrique iglesias", url: url, image: #imageLiteral(resourceName: "enrique"))
        mediaPlayer.song = song
    }
    
    @objc fileprivate func stopPlayer(){
        mediaPlayer.player.stop()
    }
    


}


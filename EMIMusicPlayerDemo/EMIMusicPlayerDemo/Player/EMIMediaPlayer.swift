//
//  EMIMediaPlayer.swift
//  Orbi
//
//  Created by GWL on 20/08/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import AVFoundation

class EMIMediaPlayer: UIView {
    
    fileprivate var bgRadius: CGFloat {
        get {
            return self.centerX() - (self.centerX() * 0.15)
        }
    }
    
    fileprivate func centerView() -> CGPoint {
        return CGPoint(x: CGFloat(self.centerX() ), y: CGFloat(self.centerY() ) + 20)
    }
    
    fileprivate func centerY() -> CGFloat {
        return self.bounds.size.height / 2
    }
    
    fileprivate func centerX() -> CGFloat {
        return self.bounds.size.width / 2
    }
    
    fileprivate let endAngle = CGFloat(45.0).toRadians()
    fileprivate let startAngle = CGFloat(135.0).toRadians()
    
    fileprivate var shapeLayer:CAShapeLayer!
    fileprivate var shadowLayer:CALayer!
    
    var lineWidth:CGFloat = 2.0

    
    
    fileprivate var audioImageView:UIImageView? = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    
    fileprivate var labelTimeStart:UILabel? = {
        let label = UILabel(frame: .zero)
        label.text = "0:40"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    fileprivate var labelTimeEnd:UILabel? = {
        let label = UILabel(frame: .zero)
        label.text = "-3:58"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    
    fileprivate var labelSongName:UILabel? = {
        let label = UILabel(frame: .zero)
        label.text = "Waka waka"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    fileprivate var labelSongDetail:UILabel? = {
        let label = UILabel(frame: .zero)
        label.text = "Shakira Isabel Mebarak Ripoll"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    fileprivate var radiusRatio:CGFloat = 0.8
    
    var player:AVAudioPlayer!
    
    fileprivate var displayLink : CADisplayLink! = nil
    
    var song:Song?{
        didSet{
            do
            {
                if let url = song?.url{
                    player = try AVAudioPlayer(contentsOf: url)
                    player.prepareToPlay()
                    let min = Int(player.duration / 60)
                    let sec = Int(player.duration.truncatingRemainder(dividingBy: 60))
                    labelTimeEnd?.text = String(format:"-%02d:%02d",min,sec)
                    labelTimeStart?.text = "0:00"
                    
                    if let name = song?.name {
                        labelSongName?.text = name
                    }
                    
                    if let detail = song?.detail {
                        labelSongDetail?.text = detail
                    }
                    
                    if let image = song?.image {
                        audioImageView?.image = image
                    }
                }
            }
            catch{
                print(error.localizedDescription)
            }
        }
    }
   
    
    fileprivate var toolbar:EMIMediaPlayerToolbar!
    
    
    
    //MARK:- Drawing code goes here
    override func draw(_ rect: CGRect) {
        addTrackLayer()
        addImageView()
        addDurationLabels()
        addMediaToolBar()
        addSongDetailLabels()
    }
    
    private func addTrackLayer(){
        
        var centerArc = centerView()
        centerArc.y = bgRadius
        
        
        let circularPath = UIBezierPath(arcCenter: centerArc, radius: (bgRadius * radiusRatio) , startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        //Its gray layer , behind our blue layer
        let bgLayer = CAShapeLayer()
        bgLayer.frame = bounds
        bgLayer.path = circularPath.cgPath
        bgLayer.strokeColor = UIColor.white.withAlphaComponent(0.3).cgColor
        bgLayer.fillColor = UIColor.clear.cgColor
        bgLayer.lineWidth = lineWidth
        layer.addSublayer(bgLayer)
        
        //Its our main blue layer which we animates
        shapeLayer = CAShapeLayer()
        shapeLayer.frame = bounds
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor(red: 255/255, green: 192/255, blue: 2/255, alpha: 1).cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 0.0
        
        //Its our main blue layer's shadow layer.
        let shadowLayer = CALayer()
        shadowLayer.frame = bounds
        shadowLayer.shadowColor = UIColor(red: 255/255, green: 192/255, blue: 2/255, alpha: 1).cgColor
        shadowLayer.shadowOffset = .zero
        shadowLayer.shadowRadius = 10
        shadowLayer.shadowOpacity = 0.8
        shadowLayer.backgroundColor = UIColor.clear.cgColor
        shadowLayer.insertSublayer(shapeLayer, at: 0)
        shadowLayer.shouldRasterize = true
        shadowLayer.rasterizationScale = 2 * UIScreen.main.scale
        
        layer.addSublayer(shadowLayer)
    }
    
    private func addImageView(){
        var centerImageView = centerView()
        centerImageView.y = bgRadius
        audioImageView?.frame = CGRect(x: centerX(), y: centerY(), width: (bgRadius * radiusRatio ) * 1.6, height: (bgRadius * radiusRatio ) * 1.6)
        audioImageView?.center = centerImageView
        audioImageView?.layer.cornerRadius = (audioImageView?.frame.height)! / 2
        audioImageView?.clipsToBounds = true
        addSubview(audioImageView!)
        animateUserImage()
    }
    
    
    private func animateUserImage(){
        let animation = CATransition()
        //animation.delegate = self
        animation.duration = .infinity
        animation.timingFunction = CAMediaTimingFunction(name : kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = "rippleEffect"
        audioImageView?.layer.add(animation, forKey: nil)
    }
    
    
    private func addDurationLabels(){
        var centerStartLabel = centerView()
        centerStartLabel.y = (bgRadius * 1.8)
        centerStartLabel.x = centerX() - ((bgRadius * radiusRatio) * radiusRatio) + 10
        
        labelTimeStart?.frame = CGRect(x: centerX(), y: centerY(), width: 60, height: 30)
        labelTimeStart?.center = centerStartLabel
        addSubview(labelTimeStart!)
        
        
        var centerEndLabel = centerView()
        centerEndLabel.y = (bgRadius * 1.8)
        centerEndLabel.x = centerX() + ((bgRadius * radiusRatio) * radiusRatio) - 10
        
        labelTimeEnd?.frame = CGRect(x: centerX(), y: centerY(), width: 60, height: 30)
        labelTimeEnd?.center = centerEndLabel
        addSubview(labelTimeEnd!)
    }
    
    private func addMediaToolBar(){
        let height:CGFloat =  70.0
        let yCoordinate = frame.height - height
        
        toolbar = EMIMediaPlayerToolbar.instanceFromNib()
        toolbar.frame = CGRect(x: 0, y: yCoordinate, width: frame.width, height: height)
        addSubview(toolbar)
        toolbar.delegate = self
    }
    
    private func addSongDetailLabels(){
        let height:CGFloat = 20.0
        let yCoordinate = frame.height - (toolbar.frame.height + height)
        labelSongDetail?.frame = CGRect(x: 0, y: yCoordinate, width: frame.width, height: height)
        addSubview(labelSongDetail!)
        

        let yCoordinate2 = frame.height - (toolbar.frame.height + (height * 2))
        labelSongName?.frame = CGRect(x: 0, y: yCoordinate2, width: frame.width, height: height)
        addSubview(labelSongName!)
    }
}

extension EMIMediaPlayer:EMIMediaPlayerToolbarDelegate {
    
    func mediaPlayer(didTapPlayPauseButton button: UIButton) {
        if !self.player.isPlaying{
            playAudio()
            button.setImage(#imageLiteral(resourceName: "iconPauseWhite"), for: .normal)
        }else{
            stopAudioPlayer()
            button.setImage(#imageLiteral(resourceName: "iconPlayWhite"), for: .normal)
        }
    }
    
}



extension EMIMediaPlayer {
    
    fileprivate func stopAudioPlayer(){
        if (player) != nil {
            player.pause()
        }else{
            return;
        }
    }
    
    
    fileprivate func playAudio() {
       
        guard let _ = song else{
            return
        }
        
        self.player.play()
        self.displayLink = CADisplayLink(target: self, selector: #selector(self.updateSliderProgress))
        self.displayLink.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
    }
    
    @objc fileprivate func updateSliderProgress(){
        let progress = player.currentTime / player.duration
        
        if progress != 0.0{
            let min = Int(player.currentTime / 60)
            let sec = Int(player.currentTime.truncatingRemainder(dividingBy: 60))
            
            let ramainingMin = Int((player.duration - player.currentTime) / 60)
            let ramainingSec = Int((player.duration - player.currentTime).truncatingRemainder(dividingBy: 60))
            
            labelTimeStart?.text = String(format:"%02d:%02d",min,sec)//String(format: "%02d:%02d | %02d:%02d", min, sec , totalMin , totalSec )
            labelTimeEnd?.text = String(format:"-%02d:%02d",ramainingMin,ramainingSec)
            
            self.shapeLayer.strokeEnd = CGFloat(progress)
        }
    }
    
    fileprivate func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.pause()
        self.shapeLayer.strokeEnd = 0.0
        displayLink.invalidate()
        //buttonPlay?.setImage(#imageLiteral(resourceName: "playIcon"), for: [])
        //labelTimer.text = String(format: "%@", (message?.duration)!)
    }
}


extension CGFloat {
    func toRadians() -> CGFloat {
        return self * CGFloat(Float.pi) / 180.0
    }
    
    var degrees: CGFloat {
        return self * CGFloat(180.0 / Float.pi)
    }
}


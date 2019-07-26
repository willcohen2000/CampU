//
//  VideoFeedCell.swift
//  CampU
//
//  Created by Will Cohen on 7/19/19.
//  Copyright © 2019 Will Cohen. All rights reserved.
//

import UIKit
import AVKit

class VideoFeedCell: UITableViewCell {

    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var witnessesLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    var player : AVPlayer!
    var avPlayerLayer : AVPlayerLayer!
    
    override func awakeFromNib() {
        super.awakeFromNib();
        profilePictureImageView.layer.cornerRadius = (profilePictureImageView.frame.height / 2);
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avPlayerLayer.frame = videoView.layer.bounds;
    }
    
    func isUnactive() {
        player.pause();
    }
    
    func isActive() {
        player.play();
    }

    func configureCell(link: String) {
        
        player = AVPlayer(url: URL(string: link)!);
        avPlayerLayer = AVPlayerLayer(player: player);
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill;
        player.automaticallyWaitsToMinimizeStalling = false
        videoView.layer.addSublayer(avPlayerLayer);
            
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: .main) { [weak self] _ in
            self?.player?.seek(to: CMTime.zero);
            self?.player?.play();
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated);

    }
    
    @IBAction func flagButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func witnessButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        
    }
    
}

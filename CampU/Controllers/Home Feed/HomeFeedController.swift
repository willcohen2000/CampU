//
//  HomeFeedController.swift
//  CampU
//
//  Created by Will Cohen on 7/19/19.
//  Copyright © 2019 Will Cohen. All rights reserved.
//

import UIKit

class HomeFeedController: UIViewController {

    @IBOutlet weak var campULabel: UILabel!
    @IBOutlet weak var filterSelectionHolderView: UIView!
    @IBOutlet weak var newestFilterButton: UIButton!
    @IBOutlet weak var topTenFilterButton: UIButton!
    @IBOutlet weak var videoFeedTableView: UITableView!
    
    var currentCell: VideoFeedCell!
    
    let videoLinks = ["https://firebasestorage.googleapis.com/v0/b/camp-38672.appspot.com/o/IMG_1431.mov?alt=media&token=f9e86737-8f50-4699-a5a2-9fedd5461f3e", "https://firebasestorage.googleapis.com/v0/b/camp-38672.appspot.com/o/IMG_1466.mov?alt=media&token=eb097ae2-b534-42f9-b244-ebd4d10d5b79"]
    
    override func viewDidLoad() {
        super.viewDidLoad();
        videoFeedTableView.delegate = self;
        videoFeedTableView.dataSource = self;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureViews();
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        currentCell.isUnactive();
    }
    
    private func configureViews() {
        filterSelectionHolderView.layer.borderColor = Colors.centralBlack.cgColor;
        filterSelectionHolderView.layer.borderWidth = 1.0;
        filterSelectionHolderView.roundedView();
    }

    
    @IBAction func notificationButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func newestFilterButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func topTenFilterButtonPressed(_ sender: Any) {
        
    }
    
}

extension HomeFeedController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            // 4/4s
            return 600;
        case 1136:
            // 5/5s
            return 600;
        case 1334:
            // 6/7/8
            return 600;
        case 1792:
            // xr
            return 700;
        case 1920, 2208:
            //iphone plus
            return 750;
        case 2436:
            // x xs
            return 750;
        case 2688:
            // xs max
            return 750;
        default:
            return 600;
            //unknown
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let activeCell = cell as! VideoFeedCell;
        activeCell.isUnactive();
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let activeCell = cell as! VideoFeedCell;
        currentCell = activeCell;
        activeCell.isActive();
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = videoLinks[indexPath.row];
        if let cell = videoFeedTableView.dequeueReusableCell(withIdentifier: "videoFeedCell") as? VideoFeedCell {
            cell.configureCell(link: post);
            cell.isActive()
            return cell
        } else {
            return VideoFeedCell()
        }
    }
    
}

extension UIView {
    func roundedView(){
        
        if #available(iOS 11.0, *) {
            self.clipsToBounds = true
            self.layer.cornerRadius = 8
            self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            let maskPath1 = UIBezierPath(roundedRect: bounds,
                                         byRoundingCorners: [.bottomLeft , .bottomRight],
                                         cornerRadii: CGSize(width: 8, height: 8))
            let maskLayer1 = CAShapeLayer()
            maskLayer1.frame = bounds
            maskLayer1.path = maskPath1.cgPath
            layer.mask = maskLayer1
        }
        
    }
}


//
//  UserPin.swift
//  SportCarClient
//
//  Created by 黄延 on 16/3/13.
//  Copyright © 2016年 WoodyHuang. All rights reserved.
//

import UIKit

class UserAnnotation: BMKPointAnnotation {
    var user: User!
    
    override init() {
        super.init()
        self.title = " "
    }
}

class UserAnnotationView: BMKAnnotationView {
    weak var parent: UIViewController!
    var user: User! {
        didSet {
            avatar.kf_setImageWithURL(user.avatarURL!, forState: .Normal)
            if let avatarCarURL = user.avatarCarModel?.logoURL {
                avatarCar.kf_setImageWithURL(avatarCarURL)
            }
        }
    }
    var avatar: UIButton!
    var avatarCar: UIImageView!
    
    override init!(annotation: BMKAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.bounds = CGRectMake(0, 0, 65, 65)
        avatar = self.addSubview(UIButton.self)
            .config(self, selector: #selector(avatarPressed))
            .setFrame(CGRectMake(0, 0, 65, 65))
            .toRound()
        avatarCar = self.addSubview(UIImageView.self)
            .config(nil)
            .setFrame(CGRectMake(40, 40, 25, 25))
            .toRound()
        self.addShadow()
    }
    
//    @available(*, deprecated=1)
    func avatarPressed() {
        let detail = PersonOtherController(user: user)
        parent.navigationController?.pushViewController(detail, animated: true)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HostUserOnRadarAnnotationView: BMKAnnotationView {
    var centerIcon: UIImageView!
    var scan: UIImageView!
    
    private var _curAngle: CGFloat = 0
    private var updator: CADisplayLink?
    
    override init!(annotation: BMKAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.bounds = CGRectMake(0, 0, 400, 400)
        self.userInteractionEnabled = false
        
        centerIcon = UIImageView(image: UIImage(named: "location_mark"))
        self.addSubview(centerIcon)
        centerIcon.center = CGPointMake(200, 200)
        centerIcon.bounds = CGRectMake(0, 0, 27.5, 30)
        
        scan = UIImageView(image: UIImage(named: "location_radar_scan"))
        scan.frame = self.bounds
        self.addSubview(scan)
        
        updator = CADisplayLink(target: self, selector: #selector(HostUserOnRadarAnnotationView.scanUpdate))
        updator?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        updator?.frameInterval = 1
        updator?.paused = true
        
        self.userInteractionEnabled = false
    }
    
    deinit {
        updator?.invalidate()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startScan() {
        updator?.paused = false
    }
    
    func scanUpdate() {
        let trans = CGAffineTransformMakeRotation(_curAngle)
        scan.transform = trans
        _curAngle += 0.03
        self.setNeedsDisplay()
    }
}
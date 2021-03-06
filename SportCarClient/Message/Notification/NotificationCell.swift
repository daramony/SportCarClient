//
//  NotificationCell.swift
//  SportCarClient
//
//  Created by 黄延 on 16/2/5.
//  Copyright © 2016年 WoodyHuang. All rights reserved.
//

import UIKit


class NotificationBaseCell: UITableViewCell {
    class func reuseIdentifier() -> String{
        return "notification_base_cell"
    }
    
    var avatarBtn: UIButton!
    var nickNameLbl: UILabel!
    var informLbL: UILabel!
    var dateLbl: UILabel!
    
    var readDot: UIView!
    
    var onAvatarPressed: (()->())?
    var notification: Notification!
    weak var navigationController: UINavigationController?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createSubviews()
        self.selectionStyle = .None
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createSubviews() {
        let superview = self.contentView
        superview.backgroundColor = UIColor.whiteColor()
        //
        avatarBtn = UIButton()
        avatarBtn.layer.cornerRadius = 22.5
        avatarBtn.clipsToBounds = true
        avatarBtn.addTarget(self, action: #selector(avatarPressed), forControlEvents: .TouchUpInside)
//        avatarBtn.userInteractionEnabled = false
        superview.addSubview(avatarBtn)
        avatarBtn.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(superview).offset(15)
            make.left.equalTo(superview).offset(15)
            make.size.equalTo(45)
        }
        //
        nickNameLbl = UILabel()
        nickNameLbl.font = UIFont.systemFontOfSize(14, weight: UIFontWeightBlack)
        nickNameLbl.textColor = UIColor.blackColor()
        superview.addSubview(nickNameLbl)
        nickNameLbl.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(avatarBtn.snp_right).offset(15)
            make.bottom.equalTo(avatarBtn.snp_centerY)
        }
        //
        informLbL = UILabel()
        informLbL.font = UIFont.systemFontOfSize(12, weight: UIFontWeightUltraLight)
        informLbL.textColor = kNotificationHintColor
        superview.addSubview(informLbL)
        informLbL.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(nickNameLbl.snp_right).offset(10)
            make.bottom.equalTo(nickNameLbl)
        }
        //
        dateLbl = UILabel()
        dateLbl.font = UIFont.systemFontOfSize(10, weight: UIFontWeightUltraLight)
        dateLbl.textColor = kNotificationHintColor
        superview.addSubview(dateLbl)
        dateLbl.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(nickNameLbl)
            make.top.equalTo(nickNameLbl.snp_bottom).offset(5)
        }
        
        readDot = superview.addSubview(UIView).config(kHighlightedRedTextColor)
            .toRound(5).layout({ (make) in
                make.centerX.equalTo(superview.snp_right).offset(-15)
                make.centerY.equalTo(avatarBtn.snp_top)
                make.size.equalTo(10)
            })
    }
    
    func avatarPressed() {
        if let user = notification.user, nav = navigationController {
            if user.isHost {
                let detail = PersonBasicController(user: user)
                nav.pushViewController(detail, animated: true)
            } else {
                let detail = PersonOtherController(user: user)
                nav.pushViewController(detail, animated: true)
            }
        } else {
            assertionFailure()
        }
    }
}


class NotificationCellWithCoverThumbnail: NotificationBaseCell {
    
    override class func reuseIdentifier() -> String {
        return "notification_cell_with_cover_thumbnail"
    }
    
    var cover: UIImageView!
    var messageBodyLbl: UILabel!
    static let messageBodyLblMaxWidth = UIScreen.mainScreen().bounds.width - 30
    
    override func createSubviews() {
        super.createSubviews()
        let superview = self.contentView
        
        cover = UIImageView()
        superview.addSubview(cover)
        cover.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(superview).offset(-15)
            make.centerY.equalTo(avatarBtn)
            make.height.equalTo(avatarBtn)
            make.width.equalTo(avatarBtn)
        }
        
        messageBodyLbl = UILabel()
        messageBodyLbl.font = UIFont.systemFontOfSize(14, weight: UIFontWeightLight)
        messageBodyLbl.textColor = kNotificationHintColor
        superview.addSubview(messageBodyLbl)
        messageBodyLbl.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(avatarBtn)
            make.right.equalTo(cover)
            make.top.equalTo(avatarBtn.snp_bottom).offset(15)
        }
        
        superview.bringSubviewToFront(readDot)
    }
}


class NotificationCellAboutActivity: NotificationBaseCell{
    
    override class func reuseIdentifier() -> String {
        return "notification_cell_about_activity"
    }
    
    var name2LbL: UILabel!
    var inform2Lbl: UILabel!
    
    var agreenBtn: UIButton!
    var onAgreeBtnPressed: ((sender: NotificationCellAboutActivity)->())?
    var denyBtn: UIButton!
    var onDenyBtnPressed: ((sender: NotificationCellAboutActivity)->())?
    var doneLbl : UILabel!
    
    var showBtns: Bool = true {
        didSet {
            agreenBtn.hidden = !showBtns
            denyBtn.hidden = !showBtns
        }
    }
    
    var closeOperation: Bool = true {
        didSet {
            showBtns = !closeOperation
            doneLbl.hidden = !closeOperation
        }
    }
    
    override func createSubviews() {
        super.createSubviews()
        let superview = self.contentView
        //
        name2LbL = UILabel()
        name2LbL.textColor = UIColor.blackColor()
        name2LbL.font = UIFont.systemFontOfSize(14, weight: UIFontWeightBlack)
        superview.addSubview(name2LbL)
        name2LbL.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(informLbL.snp_right).offset(10)
            make.bottom.equalTo(nickNameLbl) 
        }
        //
        inform2Lbl = UILabel()
        inform2Lbl.font = UIFont.systemFontOfSize(12, weight: UIFontWeightUltraLight)
        inform2Lbl.textColor = kNotificationHintColor
        superview.addSubview(inform2Lbl)
        inform2Lbl.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(name2LbL.snp_right).offset(10)
            make.bottom.equalTo(name2LbL)
        }
        //
        agreenBtn = UIButton()
        agreenBtn.setTitle(LS("同意"), forState: .Normal)
        agreenBtn.setTitleColor(kHighlightedRedTextColor, forState: .Normal)
        agreenBtn.titleLabel?.font = UIFont.systemFontOfSize(14, weight: UIFontWeightUltraLight)
        superview.addSubview(agreenBtn)
        agreenBtn.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(superview.snp_right).offset(-45)
            make.top.equalTo(dateLbl.snp_bottom).offset(13)
            make.size.equalTo(CGSizeMake(44, 20))
        }
        agreenBtn.addTarget(self, action: #selector(NotificationCellAboutActivity.agreeBtnPressed), forControlEvents: .TouchUpInside)
        //
        denyBtn = UIButton()
        denyBtn.setTitle(LS("谢绝"), forState: .Normal)
        denyBtn.setTitleColor(UIColor(white: 0.72, alpha: 1), forState: .Normal)
        denyBtn.titleLabel?.font = UIFont.systemFontOfSize(14, weight: UIFontWeightUltraLight)
        superview.addSubview(denyBtn)
        denyBtn.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(agreenBtn.snp_centerX).offset(-50)
            make.centerY.equalTo(agreenBtn)
            make.size.equalTo(agreenBtn)
        }
        denyBtn.addTarget(self, action: #selector(NotificationCellAboutActivity.denyBtnPressed), forControlEvents: .TouchUpInside)
        //
        doneLbl = UILabel()
        doneLbl.font = UIFont.systemFontOfSize(14)
        doneLbl.textColor = UIColor.blackColor()
        doneLbl.textAlignment = .Right
        superview.addSubview(doneLbl)
        doneLbl.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(denyBtn)
            make.right.equalTo(agreenBtn)
            make.height.equalTo(agreenBtn)
            make.centerY.equalTo(agreenBtn)
        }
    }
    
    
    func agreeBtnPressed() {
        if onAgreeBtnPressed == nil {
            assertionFailure()
        }
        onAgreeBtnPressed!(sender: self)
    }
    
    func denyBtnPressed() {
        if onDenyBtnPressed == nil {
            assertionFailure()
        }
        onDenyBtnPressed!(sender: self)
    }
}

//
//  privateSettings.swift
//  SportCarClient
//
//  Created by 黄延 on 16/2/6.
//  Copyright © 2016年 WoodyHuang. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON

let kPrivateChatSettingSectionTitles = ["", LS("信息"), LS("隐私"), LS("聊天")]

class PrivateChatSettingController: UITableViewController, FFSelectDelegate {
    /*
     列表长度有限，则直接采用UIScrollView
    */
    /// 目标用户
    var targetUser: User!
    var seeHisStatus: Bool = true
    var allowSeeStatus: Bool = true
    
    var board: UIScrollView!
    var startGroupChatBtn: UIButton?
    var startChat: UIButton?
    
    init(targetUser: User) {
        super.init(style: .Plain)
        self.targetUser = targetUser
    }
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .None
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "start_group_chat_cell")
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "start_chat_cell")
        tableView.registerClass(PrivateChatSettingsAvatarCell.self, forCellReuseIdentifier: PrivateChatSettingsAvatarCell.reuseIdentifier)
        tableView.registerClass(PrivateChatSettingsCommonCell.self, forCellReuseIdentifier: PrivateChatSettingsCommonCell.reuseIdentifier)
        tableView.registerClass(PrivateChatSettingsHeader.self, forHeaderFooterViewReuseIdentifier: "reuse_header")
        // 从网络获取配置数据
        let requester = ChatRequester.requester
        requester.getUserRelationSettings(targetUser.userID!, onSuccess: { (data) -> () in
            self.targetUser.remarkName = data!["remark_name"].string
            self.allowSeeStatus = data!["allow_see_status"].boolValue
            self.seeHisStatus = data!["see_his_status"].boolValue
            self.tableView.reloadData()
            }) { (code) -> () in
                //
        }
    }
    
    func navSettings() {
        self.navigationItem.title = targetUser.nickName
        let leftBtn = UIButton()
        leftBtn.setImage(UIImage(named: "account_header_back_btn"), forState: .Normal)
        leftBtn.frame = CGRectMake(0, 0, 9, 15)
        leftBtn.addTarget(self, action: "navLeftBtnPressed", forControlEvents: .TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
        let rightBtn = UIButton()
        rightBtn.setImage(UIImage(named: "status_detail_other_operation"), forState: .Normal)
        rightBtn.imageView?.contentMode = .ScaleAspectFit
        rightBtn.frame = CGRectMake(0, 0, 21, 21)
        rightBtn.addTarget(self, action: "navRightBtnPressed", forControlEvents: .TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
    }
    
    func navRightBtnPressed() {
        self.navigationController?.popViewControllerAnimated(true)
        let requester = ChatRequester.requester
        requester.postUpdateUserRelationSettings(targetUser.userID!, remark_name: targetUser.remarkName!, allowSeeStatus: allowSeeStatus, seeHisStatus: seeHisStatus, onSuccess: { (_) -> () in
            
            }) { (code) -> () in
                
        }
    }
    
    func navLeftBtnPressed() {
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            return 2
        case 3:
            return 4
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0.01
        }else {
            return 50
        }
    }
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0{
//            return nil
//        }
//        return kPrivateChatSettingSectionTitles[section]
//    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier("reuse_header") as! PrivateChatSettingsHeader
        header.titleLbl.text = kPrivateChatSettingSectionTitles[section]
        return header
    }
    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(PrivateChatSettingsAvatarCell.reuseIdentifier, forIndexPath: indexPath) as! PrivateChatSettingsAvatarCell
            cell.avatarBtn.kf_setImageWithURL(SFURL(targetUser.avatarUrl!)!, forState: .Normal)
            return cell
        case 1:
            if indexPath.row < 2 {
                let cell = tableView.dequeueReusableCellWithIdentifier(PrivateChatSettingsCommonCell.reuseIdentifier, forIndexPath: indexPath) as! PrivateChatSettingsCommonCell
                cell.staticLbl.text = [LS("备注"), LS("把他推荐给朋友")][indexPath.row]
                cell.boolSelect.hidden = true
                if indexPath.row == 0 {
                    cell.infoLbl.text = targetUser.remarkName
                }
                return cell
            }else {
                let cell = tableView.dequeueReusableCellWithIdentifier("start_group_chat_cell", forIndexPath: indexPath)
                if startGroupChatBtn == nil {
                    startGroupChatBtn = UIButton()
                    startGroupChatBtn?.setImage(UIImage(named: "chat_settings_add_person"), forState: .Normal)
                    cell.contentView.addSubview(startGroupChatBtn!)
                    startGroupChatBtn?.snp_makeConstraints(closure: { (make) -> Void in
                        make.left.equalTo(cell.contentView).offset(15)
                        make.centerY.equalTo(cell.contentView)
                        make.size.equalTo(65)
                    })
                    let staticLbl = UILabel()
                    staticLbl.font = UIFont.systemFontOfSize(12, weight: UIFontWeightUltraLight)
                    staticLbl.textColor = UIColor(white: 0.72, alpha: 1)
                    staticLbl.text = LS("发起一个群聊")
                    cell.contentView.addSubview(staticLbl)
                    staticLbl.snp_makeConstraints(closure: { (make) -> Void in
                        make.left.equalTo(startGroupChatBtn!.snp_right).offset(15)
                        make.centerY.equalTo(startGroupChatBtn!)
                    })
                }
                return cell
            }
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier(PrivateChatSettingsCommonCell.reuseIdentifier, forIndexPath: indexPath) as! PrivateChatSettingsCommonCell
            cell.staticLbl.text = [LS("不让他看我的动态"), LS("不看他的动态")][indexPath.row]
            cell.detailTextLabel?.text = ""
            cell.boolSelect.hidden = false
            cell.boolSelect.tag = indexPath.row
            if indexPath.row == 0 {
                cell.boolSelect.setOn(!allowSeeStatus, animated: false)
                cell.boolSelect.addTarget(self, action: "allowSeeStatusSwitchPressed:", forControlEvents: .ValueChanged)
            }else{
                cell.boolSelect.setOn(!seeHisStatus, animated: false)
                cell.boolSelect.addTarget(self, action: "seeHisStatusSwitchPressed:", forControlEvents: .ValueChanged)
            }
            return cell
        default:
            if indexPath.row < 3 {
                let cell = tableView.dequeueReusableCellWithIdentifier(PrivateChatSettingsCommonCell.reuseIdentifier, forIndexPath: indexPath) as! PrivateChatSettingsCommonCell
                cell.staticLbl.text = [LS("查找聊天内容"), LS("情况聊天内容"), LS("举报")][indexPath.row]
                cell.detailTextLabel?.text = ""
                cell.boolSelect.hidden = true
                return cell
            }else {
                let cell = tableView.dequeueReusableCellWithIdentifier("start_chat_cell", forIndexPath: indexPath)
                if startChat == nil {
                    startChat = UIButton()
                    startChat?.setImage(UIImage(named: "chat_setting_start_chat"), forState: .Normal)
                    cell.contentView.addSubview(startChat!)
                    startChat?.snp_makeConstraints(closure: { (make) -> Void in
                        make.centerX.equalTo(cell.contentView)
                        make.top.equalTo(cell.contentView).offset(15)
                        make.size.equalTo(CGSizeMake(150, 50))
                    })
                }
                return cell
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 114
        case 1:
            if indexPath.row < 2 {
                return 50
            }else {
                return 105
            }
        case 2:
            return 50
        case 3:
            if indexPath.row < 3 {
                return 50
            }else {
                return 128
            }
        default:
            return 0
        }
    }
    
    func startGroupChatPressed() {
        
    }
    
    func seeHisStatusSwitchPressed(sender: UISwitch) {
        seeHisStatus = !sender.on
    }
    
    func allowSeeStatusSwitchPressed(sender: UISwitch) {
        allowSeeStatus = !sender.on
    }
}


// MARK: - 各个cell的功能的具体实现
extension PrivateChatSettingController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    /**
     把他推荐给朋友
     */
    func recommendToFriend() {
        let selector = FFSelectController()
        let nav = BlackBarNavigationController(rootViewController: selector)
        selector.delegate = self
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    func userSelectCancelled() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func userSelected(users: [User]) {
        self.dismissViewControllerAnimated(true, completion: nil)
        // 向每一个用户发送一条推荐消息
    }
    
    /**
     情况聊天内容
     */
    func clearChatContent() {
        
    }
    
    /**
     修改备注名称
     */
    func changeRemarkName() {
        
    }
    
    /**
     搜索聊天内容
     */
    func searchChatContent() {
        
    }
}
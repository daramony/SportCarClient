//
//  AvatarClubSelect.swift
//  SportCarClient
//
//  Created by 黄延 on 16/3/5.
//  Copyright © 2016年 WoodyHuang. All rights reserved.
//
//  This is where current user selecting his/her avatar car
//

import UIKit


protocol AvatarClubSelectDelegate: class {
    func avatarClubSelectDidFinish(selectedClub: Club)
    func avatarClubSelectDidCancel()
}


class AvatarClubSelectController: AvatarItemSelectController {
    
    weak var delegate: AvatarClubSelectDelegate?
    
    var clubs: [Club] = []
    private var user: User = MainManager.sharedManager.hostUser!
    var preSelectID: Int32? = nil
    
    var selectedRow: Int = -1
    var noIntialSelect: Bool = false
    
    var noClubLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSubviews()
        let requester = ClubRequester.sharedInstance
        requester.getClubListAuthed({ (json) -> () in
            var i = 0
            for data in json!.arrayValue {
                let club: Club = try! MainManager.sharedManager.getOrCreate(Club.reorganizeJSON(data))
                self.clubs.append(club)
                if club.ssid == self.preSelectID ?? self.user.avatarClubModel?.ssid && !self.noIntialSelect{
                    self.selectedRow = i
                }
                i += 1
            }
            self.tableView.reloadData()
            }) { (code) -> () in
        }
    }
    
    func createSubviews() {
        let superview = self.view
        superview.backgroundColor = UIColor.whiteColor()
        
        noClubLbl = UILabel()
        noClubLbl.font = UIFont.systemFontOfSize(12, weight: UIFontWeightUltraLight)
        noClubLbl.textColor = UIColor(white: 0.72, alpha: 1)
        noClubLbl.text = LS("暂未加入认证俱乐部，在群聊中申请认证")
        superview.addSubview(noClubLbl)
        noClubLbl.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(superview)
            make.top.equalTo(superview).offset(100)
        }
        if clubs.count == 0 {
            noClubLbl.hidden = true
        }
    }
    
    override func navTitle() -> String {
        return LS("签名俱乐部")
    }
    
    override func navLeftBtnPressed() {
        super.navLeftBtnPressed()
        delegate?.avatarClubSelectDidCancel()
    }
    
    override func navRightBtnPressed() {
        super.navRightBtnPressed()
        //
        if selectedRow >= 0 {
            delegate?.avatarClubSelectDidFinish(clubs[selectedRow])
        }else {
            delegate?.avatarClubSelectDidCancel()
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noClubLbl.hidden = clubs.count != 0
        return clubs.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(AvatarItemSelectCell.reuseIdentifier, forIndexPath: indexPath) as! AvatarItemSelectCell
        let club = clubs[indexPath.row]
        cell.avatarImg?.kf_setImageWithURL(club.logoURL!, placeholderImage: nil)
        cell.selectBtn?.tag = indexPath.row
        cell.nickNameLbl?.text = club.name
        cell.authIcon.hidden = true
        cell.selectBtn?.selected = selectedRow == indexPath.row
        cell.onSelect = { [weak self] (sender: UIButton) in
            let row = sender.tag
            if sender.selected {
                self?.selectedRow = -1
            }else{
                self?.selectedRow = row
            }
            self?.tableView.reloadData()
            return true
        }
        return cell
    }
}

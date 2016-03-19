//
//  ClubDiscoverListCell.swift
//  SportCarClient
//
//  Created by 黄延 on 16/3/6.
//  Copyright © 2016年 WoodyHuang. All rights reserved.
//

import UIKit


class ClubDiscoverCell: DriverMapUserCell {
    var valueLbl: UILabel!
    weak var club: Club!
    
    override func createSubviews() {
        super.createSubviews()
        valueLbl = UILabel()
        valueLbl.font = UIFont.systemFontOfSize(12, weight: UIFontWeightUltraLight)
        valueLbl.textColor = UIColor(white: 0.72, alpha: 1)
        self.contentView.addSubview(valueLbl)
        valueLbl.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(nameLbl.snp_right).offset(5)
            make.centerY.equalTo(nameLbl)
        }
    }
    
    override func loadDataAndUpdateUI() {
        avatar.kf_setImageWithURL(SFURL(club.logo_url!)!)
        nameLbl.text = club.name! + "(\(club.memberNum))"
        distanceLbl.text = (club.city ?? "") + " " + (club.clubDescription ?? "")
        valueLbl.text = LS("总价") + "\(club.value)"
    }
}
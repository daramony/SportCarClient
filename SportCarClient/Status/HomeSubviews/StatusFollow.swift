//
//  StatusFollow.swift
//  SportCarClient
//
//  Created by 黄延 on 16/1/21.
//  Copyright © 2016年 WoodyHuang. All rights reserved.
//

import UIKit


class StatusFollowController: StatusBasicController {
    
    override func loadMoreData() {
        // 获取关注对象的状态（自己的状态也会返回）
        let dateThreshold = (status.last?.createdAt ?? NSDate())
        let requester = StatusRequester.sharedInstance
        requester.getMoreStatusList(dateThreshold, queryType: "follow", onSuccess: { (let data) -> () in
            if self.jsonDataHandler(data!) > 0{
                self.tableView.reloadData()
            }
            }) { (code) -> () in
        }
    }
    
    override func loadLatestData() {
        let dateThreshold = status.first?.createdAt ?? NSDate()
        let requester = StatusRequester.sharedInstance
        requester.getLatestStatusList(dateThreshold, queryType: "follow", onSuccess: { (let data) -> () in
            self.myRefreshControl?.endRefreshing()
            if self.jsonDataHandler(data!) > 0 {
                self.tableView.reloadData()
            }
            }) { (code) -> () in
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let s = self.status[indexPath.row]
        let cell =  tableView.cellForRowAtIndexPath(indexPath)
        let pos = cell!.frame.origin.y - tableView.contentOffset.y + 10
        let detail = StatusDetailController(status: s, background: getScreenShot(), initPos: pos, initHeight: cell!.frame.height)
        detail.list = tableView
        detail.indexPath = indexPath
        self.homeController?.navigationController?.pushViewController(detail, animated: false)
    }
    
    func getScreenShot() -> UIImage{
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, true, UIScreen.mainScreen().scale)
        let context = UIGraphicsGetCurrentContext()!
        CGContextTranslateCTM(context, 0, -self.tableView.contentOffset.y)
        self.view.layer.renderInContext(context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}
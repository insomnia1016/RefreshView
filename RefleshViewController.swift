//
//  RefleshViewController.swift
//  refleshView
//
//  Created by chenjianwu on 15/12/31.
//  Copyright © 2015年 gaoyuejianwu studio. All rights reserved.
//

import UIKit

private let kRefleshViewHeight:CGFloat = 200
class RefleshViewController: UITableViewController,RefreshViewDelegate {

    private var refleshView:RefleshView!
    override func viewDidLoad() {
        super.viewDidLoad()
        refleshView = RefleshView(frame: CGRectMake(0, -kRefleshViewHeight, CGRectGetWidth(view.bounds), kRefleshViewHeight), scrollView: tableView)
        refleshView.delegate = self
        view.insertSubview(refleshView, atIndex: 0)
        
    }

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        refleshView.scrollViewDidScroll(scrollView)
    }
    override func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        refleshView.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    func refreshViewDidRefresh(refreshView: RefleshView) {
        let time: NSTimeInterval = 10.0
        let delay = dispatch_time(DISPATCH_TIME_NOW,
            Int64(time * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()) {
            print("\(time) 秒后输出")
            self.refleshView.endRefreshing()
        }
    }
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 20
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)

        cell.textLabel?.text = "第 \(indexPath.row + 1) 行"

        return cell
    }
    


}

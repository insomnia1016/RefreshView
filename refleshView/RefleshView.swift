//
//  RefleshView.swift
//  refleshView
//
//  Created by chenjianwu on 15/12/31.
//  Copyright © 2015年 gaoyuejianwu studio. All rights reserved.
//

import UIKit

protocol RefreshViewDelegate:class{
    func refreshViewDidRefresh(refreshView:RefleshView)
}

private let kSceneHeight : CGFloat = 120.0
class RefleshView: UIView,UIScrollViewDelegate {
    
    private unowned  var scrollView:UIScrollView
    private var progress : CGFloat = 0.0
    weak var delegate : RefreshViewDelegate?
    var isRefreshing = false
    var refreshItems = [RefleshItem]()
    init(frame: CGRect,scrollView:UIScrollView) {
        self.scrollView = scrollView
        super.init(frame: frame)
        //        backgroundColor = UIColor.greenColor()
        updateBackground()
        setupRefreshItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupRefreshItems(){
        let groundImageView = UIImageView(image: UIImage(named: "ground"))
        let buildingImageView = UIImageView(image: UIImage(named: "buildings"))
        let sunImageView = UIImageView(image: UIImage(named: "sun"))
        let capeBackImageView = UIImageView(image: UIImage(named: "cape_back"))
        let catImageView = UIImageView(image: UIImage(named: "cat"))
        let capeFrontImageView = UIImageView(image: UIImage(named: "cape_front"))
        let cloud1ImageView = UIImageView(image: UIImage(named: "cloud_1"))
        let cloud2ImageView = UIImageView(image: UIImage(named: "cloud_2"))
        let cloud3ImageView = UIImageView(image: UIImage(named: "cloud_3"))
        
        
        refreshItems = [
            RefleshItem(view: buildingImageView, centerEnd: CGPoint(x: CGRectGetMidX(bounds), y: CGRectGetHeight(bounds) - CGRectGetHeight(groundImageView.bounds) - CGRectGetHeight(buildingImageView.bounds)/2), parallaxRatio: 1.5, sceneHeight: kSceneHeight),
            RefleshItem(view: sunImageView, centerEnd: CGPoint(x: CGRectGetWidth(bounds) * 0.1, y: CGRectGetHeight(bounds) - CGRectGetHeight(sunImageView.bounds) - CGRectGetHeight(groundImageView.bounds)), parallaxRatio: 3.0, sceneHeight: kSceneHeight),
            RefleshItem(view: groundImageView, centerEnd: CGPoint(x: CGRectGetMidX(bounds), y: CGRectGetHeight(bounds) - CGRectGetHeight(groundImageView.bounds)/2), parallaxRatio: 0.5, sceneHeight: kSceneHeight),
            RefleshItem(view: capeBackImageView, centerEnd: CGPoint(x: CGRectGetMidX(bounds), y: CGRectGetHeight(bounds) - CGRectGetHeight(groundImageView.bounds)/2 - CGRectGetHeight(capeBackImageView.bounds)/2), parallaxRatio: -1.0, sceneHeight: kSceneHeight),
            RefleshItem(view: catImageView, centerEnd: CGPoint(x: CGRectGetMidX(bounds), y: CGRectGetHeight(bounds) - CGRectGetHeight(groundImageView.bounds)/2 - CGRectGetHeight(catImageView.bounds)/2), parallaxRatio: 1.0, sceneHeight: kSceneHeight),
            RefleshItem(view: capeFrontImageView, centerEnd: CGPoint(x: CGRectGetMidX(bounds), y: CGRectGetHeight(bounds) - CGRectGetHeight(groundImageView.bounds)/2 - CGRectGetHeight(capeFrontImageView.bounds)/2), parallaxRatio: -1.0, sceneHeight: kSceneHeight),
            RefleshItem(view: cloud1ImageView, centerEnd: CGPoint(x: CGRectGetWidth(bounds) * 0.2, y: CGRectGetHeight(cloud1ImageView.bounds)), parallaxRatio: -1.0, sceneHeight: kSceneHeight),
            RefleshItem(view: cloud2ImageView, centerEnd: CGPoint(x: CGRectGetWidth(bounds)*0.5, y: CGRectGetHeight(cloud2ImageView.bounds)*3), parallaxRatio: -0.8, sceneHeight: kSceneHeight),
            RefleshItem(view: cloud3ImageView, centerEnd: CGPoint(x: CGRectGetWidth(bounds)*0.7, y: CGRectGetHeight(cloud3ImageView.bounds)*4), parallaxRatio: -1.2, sceneHeight: kSceneHeight)
            
        ]
        for refleshItem in refreshItems{
            addSubview(refleshItem.view)
        }
        
    }
    
    func beginRefreshing(){
        isRefreshing = true
        UIView.animateWithDuration(0.4, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            
            self.scrollView.contentInset.top += kSceneHeight
            }) { (_) -> Void in
                
        }
        // 猫和斗篷的动画
        let cape = refreshItems[3].view
        let cat = refreshItems[4].view
        cape.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI/32))
        cat.transform = CGAffineTransformMakeTranslation(1.0, 0)
        UIView.animateWithDuration(0.2, delay: 0,options: [.Repeat , .Autoreverse],
            animations: { () -> Void in
                cape.transform = CGAffineTransformMakeRotation(CGFloat(M_PI/32))
                cat.transform = CGAffineTransformMakeTranslation(-1.0, 0)
            }, completion: nil)
        
        // 地面和建筑的动画
        let buildings = refreshItems[0].view
        let ground = refreshItems[2].view
        UIView.animateWithDuration(2, delay: 0,options: .CurveEaseInOut,
            animations: { () -> Void in
                ground.center.y += kSceneHeight
                buildings.center.y += kSceneHeight
            }, completion: nil)
        
        //太阳的动画
        let sun = refreshItems[1].view
        sunRotation(sun.layer)
        
        //云的动画
        let cloud1 = refreshItems[6].view
        let cloud2 = refreshItems[7].view
        let cloud3 = refreshItems[8].view
        animateCloud(cloud1.layer)
        animateCloud(cloud2.layer)
        animateCloud(cloud3.layer)
        
    }
    
    func sunRotation(layer:CALayer){
        let rotation = CAKeyframeAnimation(keyPath: "transform.rotation")
        rotation.duration = 10
        rotation.repeatCount = 10
        rotation.values = [0.0,M_PI_2,M_PI,M_PI_2 * 3,M_PI * 2]
        rotation.keyTimes = [0.0,0.25,0.5,0.75,1]
        rotation.setValue("sun", forKey: "name")
        rotation.setValue(layer, forKey: "layer")
        layer.addAnimation(rotation, forKey: nil)
    }
    func endRefreshing(){
        
        UIView.animateWithDuration(0.4, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            
            self.scrollView.contentInset.top -= kSceneHeight
            }) { (_) -> Void in
                self.isRefreshing = false
                for refreshItem in self.refreshItems{
                    refreshItem.view.removeFromSuperview()
                }
                self.setupRefreshItems()
        }
    }
    
    func animateCloud(layer: CALayer) {
        //1
        let cloudSpeed = 5.0 / Double(bounds.size.height)
        let duration: NSTimeInterval = Double(bounds.size.height - layer.frame.origin.y) * cloudSpeed
        
        //2
        let cloudMove = CABasicAnimation(keyPath: "position.y")
        cloudMove.duration = duration
        cloudMove.toValue = bounds.size.height + layer.bounds.height
        cloudMove.delegate = self
        cloudMove.setValue("cloud", forKey: "name")
        cloudMove.setValue(layer, forKey: "layer")
        
        layer.addAnimation(cloudMove, forKey: nil)
        
        
    }
    func randomInRange(range: Range<Int>) -> CGFloat {
        let count = UInt32(range.endIndex - range.startIndex)
        return  CGFloat((Float(arc4random_uniform(count)) + Float(range.startIndex)) / Float(range.endIndex))
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if let name = anim.valueForKey("name") as? String{
            if name == "cloud"{
                if let layer = anim.valueForKey("layer") as? CALayer {
                    anim.setValue(nil, forKey: "layer")
                    layer.position.y -= layer.bounds.height
                    layer.position.x = randomInRange(3...10) * bounds.width
                    let random = randomInRange(3...10)
                    layer.transform = CATransform3DMakeScale(random, random, random)
                    if isRefreshing{
                        self.animateCloud(layer)
                    }
                }
            }else if name == "sun"{
                if let layer = anim.valueForKey("layer") as? CALayer{
                    anim.setValue(nil, forKey: "layer")
                    if isRefreshing
                    {
                        self.sunRotation(layer)
                    }
                }
            }
        }
    }
    
    func updateRefleshItemPosition(){
        for refreshItem in refreshItems{
            refreshItem.updateViewPositionForPercentage(progress)
        }
    }
    
    func updateBackground(){
        backgroundColor = UIColor(white: 0.7 * progress + 0.2, alpha: 1.0)
    }
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if !isRefreshing && progress == 1{
            beginRefreshing()
            targetContentOffset.memory.y = -scrollView.contentInset.top
            delegate?.refreshViewDidRefresh(self)
        }
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if isRefreshing{
            return
        }
        //1.先取得刷新视图可见区域的高度
        let refleshViewHeight = max(0, -scrollView.contentOffset.y - scrollView.contentInset.top)
        //2.计算当前滚动的进度 ,范围0-1
        progress = min(refleshViewHeight / kSceneHeight,1)
        //3.根据进度来改变背景色
        updateBackground()
        //4.根据进度来更新图片位置
        updateRefleshItemPosition()
    }
    
}

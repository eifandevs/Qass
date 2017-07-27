//
//  CircleMenu.swift
//  Eiger
//
//  Created by User on 2017/06/06.
//  Copyright © 2017年 eifaniori. All rights reserved.
//

import Foundation
import UIKit

protocol CircleMenuDelegate {
    func circleMenuDidClose()
}

class CircleMenu: UIButton, ShadowView, CircleView, EGApplicationDelegate {
    var delegate: CircleMenuDelegate?

    private var initialPt: CGPoint? = nil
    var swipeDirection: EdgeSwipeDirection = .none
    var isEdgeSwiping = true
    var isEdgeClosing = false
    var isClosing = false
    var progress: CircleProgress! = nil
    var circleMenuItemGroup: [[CircleMenuItem]] = []
    var menuIndex: Int = 0
    var circleMenuItems: [CircleMenuItem] {
        get {
            return circleMenuItemGroup[menuIndex]
        }
    }
    
    var circleMenuLocations: [CGPoint] {
        get {
            let i = swipeDirection == .left ? 1 : -1
            return [
                CGPoint(x: 0, y: -120), // Upper
                CGPoint(x: i*60, y: -88), // UpperRight
                CGPoint(x: i*95, y: -34), // RightUpper
                CGPoint(x: i*95, y:  34), // RightLower
                CGPoint(x: i*60, y: 88), // LowerRight
                CGPoint(x: 0, y: 110) // Lower
            ]
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addCircleShadow()
        addCircle()
        setImage(UIColor.gray.circleImage(size: CGSize(width: 33, height: 33)), for: .normal)
        alpha = 0.4
        EGApplication.sharedMyApplication.egDelegate = self
        
        // プログレス
        progress = CircleProgress(frame: CGRect(origin: CGPoint.zero, size: frame.size))
        addSubview(progress)
    }
    
    convenience init(frame: CGRect, menuItems: [[CircleMenuItem]]) {
        self.init(frame: frame)
        circleMenuItemGroup = menuItems
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

// MARK: Public Method

    
// MARK: EGApplication Delegate
    internal func screenTouchBegan(touch: UITouch) {
    }
    
    internal func screenTouchMoved(touch: UITouch) {
        if !isEdgeClosing && isEdgeSwiping {
            let pt = touch.location(in: superview!)
            center = pt

            // CircleMenuItemを作成する
            if initialPt == nil {
                initialPt = pt
                for (index, circleMenuItem) in circleMenuItems.enumerated() {
                    circleMenuItem.frame.size = frame.size
                    circleMenuItem.center = initialPt!
                    _ = circleMenuItem.reactive.tap
                        .observe { [weak self] _ in
                            if !self!.isClosing {
                                circleMenuItem.scheduledAction = true
                                self!.closeCircleMenuItems()
                            }
                    }
                    superview!.addSubview(circleMenuItem)
                    UIView.animate(withDuration: 0.18, animations: {
                        circleMenuItem.center = self.center + self.circleMenuLocations[index]
                    })
                }
            }
            
            // CircleMenuとCircleMenuItemの重なり検知
            collisionLoop()
            // エッジクローズを検知する
            edgeClose()
        }
    }
    
    internal func screenTouchEnded(touch: UITouch) {
        if !isEdgeClosing && isEdgeSwiping {
            isEdgeSwiping = false
            startCloseAnimation()
        }
    }
    
    internal func screenTouchCancelled(touch: UITouch) {
        screenTouchEnded(touch: touch)
    }
    
// MARK: Touch Event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if !isEdgeClosing {
            progress.invalidate()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if !isEdgeClosing {
            let touch = touches.first!
            let newPt = touch.location(in: superview!)
            let oldPt = touch.previousLocation(in: superview!)
            let diff = newPt - oldPt
            center = center + diff
            // CircleMenuとCircleMenuItemの重なり検知
            collisionLoop()
            // エッジクローズ検知
            edgeClose()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if !isEdgeClosing {
            // CircleMenu押下判定
            if  center == initialPt! {
                // サークルメニューアイテムを切り替える
                let currentCircleMenuItems = circleMenuItems
                menuIndex = menuIndex + 1 == circleMenuItemGroup.count ? 0 : menuIndex + 1
                for (index, item) in currentCircleMenuItems.enumerated() {
                    circleMenuItems[index].frame = item.frame
                    _ = circleMenuItems[index].reactive.tap
                        .observe { [weak self] _ in
                            if !self!.isClosing {
                                self!.circleMenuItems[index].scheduledAction = true
                                self!.closeCircleMenuItems()
                            }
                    }
                    superview!.addSubview(circleMenuItems[index])
                    item.removeFromSuperview()
                }
            }
            startCloseAnimation()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
// MARK: Private Method
    private func closeCircleMenuItems() {
        if self.executeCircleMenuAction() {
            isClosing = true
            progress.invalidate()
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha = 0
                self.circleMenuItems.forEach({ (menuItem) in
                    if menuItem.scheduledAction {
                        menuItem.transform = CGAffineTransform(scaleX: 2, y: 2)
                        menuItem.backgroundColor = UIColor.frenchBlue
                    } else {
                        menuItem.center = self.initialPt!
                        menuItem.alpha = 0
                    }
                })
            }, completion: { (finished) in
                if finished {
                    self.alpha = 0
                    self.circleMenuItems.forEach({ (menuItem) in
                        if menuItem.scheduledAction {
                            UIView.animate(withDuration: 0.2, animations: {
                                menuItem.alpha = 0
                            }, completion: { (finished) in
                                if finished {
                                    self.delegate?.circleMenuDidClose()
                                }
                            })
                        } else {
                            menuItem.alpha = 0
                        }
                    })
                }
            })
        } else {
            self.progress.start {
                UIView.animate(withDuration: 0.2, animations: {
                    self.alpha = 0
                    self.circleMenuItems.forEach({ (menuItem) in
                        menuItem.center = self.initialPt!
                        menuItem.alpha = 0
                    })
                }, completion: { (finished) in
                    if finished {
                        self.delegate?.circleMenuDidClose()
                    }
                })
            }
        }
    }
    
    private func startCloseAnimation() {
        UIView.animate(withDuration: 0.15, animations: {
            self.center = self.initialPt!
        }) { (finished) in
            if finished {
                self.closeCircleMenuItems()
            }
        }
    }
    
    private func edgeClose() {
        if center.x < AppConst.edgeSwipeErea * 0.98 {
            isEdgeClosing = true
            isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.2, animations: {
                self.center.x = -1 * self.frame.size.width / 2
                self.circleMenuItems.forEach({ (item) in
                    item.center = CGPoint(x: -1 * self.frame.size.width, y: self.center.y)
                })
            }, completion: { (finished) in
                if finished {
                    self.delegate?.circleMenuDidClose()
                }
            })
        } else if center.x > DeviceConst.displaySize.width * 0.98 {
            isEdgeClosing = true
            isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.2, animations: {
                self.center.x = DeviceConst.displaySize.width + self.frame.size.width / 2
                self.circleMenuItems.forEach({ (item) in
                    item.center = CGPoint(x: DeviceConst.displaySize.width + self.frame.size.width, y: self.center.y)
                })
            }, completion: { (finished) in
                if finished {
                    self.delegate?.circleMenuDidClose()
                }
            })
        }
    }
    
    private func collisionLoop() {
        // CircleMenuとCircleMenuItemの重なりを検知
        for item in self.circleMenuItems {
            if (detectCollision(item: item)) {
                if item.isValid == false && item.scheduledAction == false {
                    // 他のitemを無効にする
                    for v in self.circleMenuItems {
                        v.scheduledAction = false
                        v.backgroundColor = UIColor.white
                    }
                    
                    item.scheduledAction = true
                    item.isValid = true
                    item.backgroundColor = UIColor.frenchBlue
                    UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn, animations: {
                        item.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                    }, completion: nil)
                }
            } else {
                if item.isValid {
                    item.isValid = false
                    item.backgroundColor = UIColor.white
                    if item.scheduledAction {
                        // 他のValidなitemをアクション予約する
                        for v in self.circleMenuItems where v.isValid {
                            v.scheduledAction = true
                            v.backgroundColor = UIColor.frenchBlue
                        }
                    }
                    item.scheduledAction = false
                    UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
                        item.transform = CGAffineTransform.identity
                    }, completion: nil)
                }
                
            }
        }
    }
    
    private func detectCollision(item: CircleMenuItem) -> Bool {
        let distance = center.distance(pt: item.center)
        if (distance < (((bounds.size.width * 1.5) / 2) + (item.bounds.size.width / 2))) {
            return true
        }
        return false
    }
    
    private func executeCircleMenuAction() -> Bool {
        for item in circleMenuItems {
            if item.scheduledAction {
                item.action?(initialPt!)
                return true
            }
        }
        return false
    }
}
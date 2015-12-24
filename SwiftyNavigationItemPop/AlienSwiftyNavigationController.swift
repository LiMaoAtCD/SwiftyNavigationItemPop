//
//  AlienSwiftyNavigationController.swift
//  SwiftyNavigationItemPop
//
//  Created by AlienLi on 15/12/23.
//  Copyright © 2015年 MarcoLi. All rights reserved.
//

import UIKit

enum ScreenShotError: ErrorType {
    case NoImageError
}

let ScreenWidth = UIScreen.mainScreen().bounds.size.width
let ScreenHeight = UIScreen.mainScreen().bounds.size.height
let min_distance: CGFloat = ScreenWidth / 2.0;// 最小回弹距离


class AlienSwiftyNavigationController: UINavigationController, UIGestureRecognizerDelegate {

    var startPoint: CGPoint?
    var isMoving: Bool?

    var screenShotImageView: UIImageView?
    
    lazy var backgroundView: UIView = {
        let view:UIView = UIView(frame: CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height))
        view.backgroundColor = UIColor.whiteColor()
        return view
    }()

    lazy var screenShotList:[UIImage] = {
        var list = [UIImage]()
        return list
    }()

    func captureScreenShot() throws -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0)
        
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.renderInContext(context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image;
        } else{
            throw ScreenShotError.NoImageError
        }
    }
    
    func startPopAnimation() {
        
        guard viewControllers.count != 1 else {
            return
        }
        self.view.superview?.insertSubview(backgroundView, belowSubview: view)
        backgroundView.hidden = false
        if let last = screenShotImageView {
            last.removeFromSuperview()
        }
        let lastScreenView = self.screenShotList.last
        screenShotImageView = UIImageView(image: lastScreenView)
        screenShotImageView?.frame = CGRectMake(-ScreenWidth, 0, ScreenWidth, ScreenHeight)
        backgroundView.addSubview(screenShotImageView!)
     
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.moveViewOnHorizontal(ScreenWidth)
            }) { (_) -> Void in
                self.gestureAnimation(false)
                var frame = self.view.frame
                frame.origin.x = 0
                self.view.frame = frame
                self.isMoving = false
                self.backgroundView.hidden = true
        }
    }
    
    func moveViewOnHorizontal(var x: CGFloat){
        x = x > ScreenWidth ? ScreenWidth : x
        x = x < 0 ? 0 : x
        var frame = self.view.frame
        frame.origin.x = x
        self.view.frame = frame
        screenShotImageView?.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight)
    }
    func gestureAnimation(animated : Bool){
        self.screenShotList.removeLast()
        super.popViewControllerAnimated(animated)
    }
    
    func PanGestureReceived(recoginizer: UIPanGestureRecognizer) {
        if self.viewControllers.count <= 1 {
            return
        }
        
        let touchPoint: CGPoint = recoginizer.locationInView(UIApplication.sharedApplication().keyWindow!)
        
        if recoginizer.state == UIGestureRecognizerState.Began {
            isMoving = true
            startPoint = touchPoint
       
            self.view.superview?.insertSubview(self.backgroundView, belowSubview: self.view)
            self.backgroundView.hidden = false
            if let lastScreenView = screenShotImageView {
                lastScreenView.removeFromSuperview()
            }
            let lastScreenShot = self.screenShotList.last
            self.screenShotImageView = UIImageView(image: lastScreenShot)
            screenShotImageView?.frame = CGRectMake(-ScreenWidth, 0, ScreenWidth, ScreenHeight)
            self.backgroundView.addSubview(screenShotImageView!)
            
            
        } else if recoginizer.state == UIGestureRecognizerState.Ended {
            if touchPoint.x - startPoint!.x >= min_distance {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.moveViewOnHorizontal(ScreenWidth)
                    }, completion: { (_) -> Void in
                        self.gestureAnimation(false)
                        var frame = self.view.frame
                        frame.origin.x = 0
                        self.view.frame = frame
                        self.isMoving = false
                })
            } else {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.moveViewOnHorizontal(0)
                    }, completion: { (_) -> Void in
                        self.isMoving = false
                        self.backgroundView.hidden = true

                })
            }
            
        } else if recoginizer.state == UIGestureRecognizerState.Cancelled {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.moveViewOnHorizontal(0)
                }, completion: { (finished) -> Void in
                   self.backgroundView.hidden = true
                    self.isMoving = false
            })
        } else {
            if self.isMoving! {
                self.moveViewOnHorizontal(touchPoint.x - startPoint!.x)
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let recognizer = UIPanGestureRecognizer(target: self, action: "PanGestureReceived:")
        recognizer.delaysTouchesBegan = true
        view.addGestureRecognizer(recognizer)
    }
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        do{
            let image = try captureScreenShot()
            screenShotList.append(image)
            super.pushViewController(viewController, animated: true)
        } catch {
           print("screen shot is failed to get one image")
        }
    }

    override func popViewControllerAnimated(animated: Bool) -> UIViewController? {
        if animated {
            startPopAnimation()
            return nil
        } else {
            return super.popViewControllerAnimated(animated)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

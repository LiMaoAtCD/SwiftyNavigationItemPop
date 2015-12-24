//
//  ViewController.swift
//  SwiftyNavigationItemPop
//
//  Created by AlienLi on 15/12/23.
//  Copyright © 2015年 MarcoLi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let button = UIButton(type: UIButtonType.Custom)
        button.frame = CGRectInset(self.view.frame, 100, 300)
        button.backgroundColor = UIColor.redColor()
        button.setTitle("Push", forState: UIControlState.Normal)
        button.addTarget(self, action: "Push", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button)
        
        self.title = "Main"
        

    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    func Push() {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = sb.instantiateViewControllerWithIdentifier("DetailViewController") as? DetailViewController
        
        self.navigationController?.pushViewController(detailVC!, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


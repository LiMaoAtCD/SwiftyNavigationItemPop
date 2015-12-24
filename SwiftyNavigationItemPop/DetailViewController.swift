//
//  DetailViewController.swift
//  SwiftyNavigationItemPop
//
//  Created by AlienLi on 15/12/23.
//  Copyright © 2015年 MarcoLi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let button = UIButton(type: UIButtonType.Custom)
        button.frame = CGRectInset(self.view.frame, 100, 300)
        button.backgroundColor = UIColor.greenColor()
        button.setTitle("Pop", forState: UIControlState.Normal)
        button.addTarget(self, action: "pop", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button)
        
        self.title = "Detail"

    }

    func pop() {
        self.navigationController?.popViewControllerAnimated(true)
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

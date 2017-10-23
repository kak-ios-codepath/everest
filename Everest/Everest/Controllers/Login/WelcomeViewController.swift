//
//  WelcomeViewController.swift
//  Everest
//
//  Created by Kavita Gaitonde on 10/13/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate  {

    let pageTitles = ["Title 1", "Title 2", "Title 3", "Title 4"]
    var images = ["Moment.png","password.png","Moment.png","Moment.png"]
    var count = 0
    
    var pageViewController : UIPageViewController!
    
    @IBAction func swipeLeft(sender: AnyObject) {
        print("SWipe left")
    }
    
    @IBAction func swiped(sender: AnyObject) {
        
        self.pageViewController.view .removeFromSuperview()
        self.pageViewController.removeFromParentViewController()
        reset()
    }
    
    func reset() {
        /* Getting the page View controller */
        pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "WelcomePageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        let pageContentViewController = self.viewControllerAtIndex(index: 0)
        self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        
        /* We are substracting 30 because we have a start again button whose height is 30*/
        self.pageViewController.view.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height - 30)
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMove(toParentViewController: self)
    }
    
    @IBAction func start(sender: AnyObject) {
        let pageContentViewController = self.viewControllerAtIndex(index: 0)
        self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    
    var index = (viewController as! WelcomeContentViewController).pageIndex!
    index += 1
    if(index >= self.images.count){
    return nil
    }
    return self.viewControllerAtIndex(index: index)
    
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    
    var index = (viewController as! WelcomeContentViewController).pageIndex!
    if(index <= 0){
    return nil
    }
    index -= 1
    return self.viewControllerAtIndex(index: index)
    
    }
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
    if((self.pageTitles.count == 0) || (index >= self.pageTitles.count)) {
    return nil
    }
    let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeContentViewController") as! WelcomeContentViewController
    
    pageContentViewController.imageName = self.images[index]
    pageContentViewController.titleText = self.pageTitles[index]
    pageContentViewController.pageIndex = index
    return pageContentViewController
    }
    
    private func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
    return pageTitles.count
    }
    
    private func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
    return 0
    }
    
}

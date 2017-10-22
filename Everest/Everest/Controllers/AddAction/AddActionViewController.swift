//
//  AddActionViewController.swift
//  Everest
//
//  Created by Kavita Gaitonde on 10/13/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit
import LNICoverFlowLayout

class AddActionViewController: UIViewController {
    
    @IBOutlet weak fileprivate var categoriesCollectionView: UICollectionView!
    @IBOutlet weak fileprivate var coverFlowLayout: LNICoverFlowLayout!
    @IBOutlet weak fileprivate var actsTableView: UITableView!
    
    private var originalItemSize = CGSize.zero
    private var originalCollectionViewSize = CGSize.zero
    
    fileprivate let photoUrls = ["https://www.lipstiq.com/wp-content/uploads/2014/06/62.jpg", "https://www.lipstiq.com/wp-content/uploads/2014/06/62.jpg"]
    fileprivate var categoryIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup notification observers
        //availableCategories = MainManager.shared.availableCategories

        
        categoriesCollectionView.delegate = self
        actsTableView.delegate = self
        actsTableView.estimatedRowHeight = 30
        actsTableView.rowHeight = UITableViewAutomaticDimension
        
        categoriesCollectionView.reloadData()
        actsTableView.reloadData()
        
        originalItemSize = coverFlowLayout.itemSize
        originalCollectionViewSize = categoriesCollectionView.bounds.size
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // We should invalidate layout in case we are switching orientation.
        // If we won't do that we will receive warning from collection view's flow layout that cell size isn't correct.
        coverFlowLayout.invalidateLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Now we should calculate new item size depending on new collection view size.
        coverFlowLayout.itemSize = CGSize(
            width: categoriesCollectionView.bounds.size.width * originalItemSize.width / originalCollectionViewSize.width,
            height: categoriesCollectionView.bounds.size.height * originalItemSize.height / originalCollectionViewSize.height
        )
        
        setInitialValues()
        
        // Forcely tell collection view to reload current data.
        categoriesCollectionView.setNeedsLayout()
        categoriesCollectionView.layoutIfNeeded()
        categoriesCollectionView.reloadData()
    }
    
    fileprivate func setInitialValues() {
        // Setting some nice defaults, ignore if you don't like them
        coverFlowLayout.maxCoverDegree = 45
        coverFlowLayout.coverDensity = 0.06
        coverFlowLayout.minCoverScale = 0.80
        coverFlowLayout.minCoverOpacity = 0.50
    }
}


//Mark:- Collection View Delegates
extension AddActionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MainManager.shared.availableCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCollectionCell", for: indexPath) as? CategoryCollectionCell else {return UICollectionViewCell()}
        cell.categoryPhotoURL = photoUrls[indexPath.row]
        cell.categoryTitle = MainManager.shared.availableCategories[indexPath.row].title
        return cell
    }
}


//Mark:- Table View Delegates
extension AddActionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let acts = MainManager.shared.availableCategories[categoryIndex].acts else {return 0}
        return acts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "actsCell", for: indexPath) as? ActsCell else {return UITableViewCell()}
        cell.actText = MainManager.shared.availableCategories[categoryIndex].acts[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        actsTableView.deselectRow(at: indexPath, animated: true)
        MainManager.shared.createNewAction(id: (MainManager.shared.availableCategories[categoryIndex].acts[indexPath.row].id), completion:{(error) in
            let alertController = UIAlertController(title: "Added", message: "You can view this newly added action in your Profile view.",  preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: { (action:UIAlertAction!) in
            })
            alertController.addAction(okAction)
            // Present Alert
            self.present(alertController, animated: true, completion:nil)
        })
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let velocity = scrollView.panGestureRecognizer.velocity(in: self.view)
        
        if abs(velocity.x) > abs(velocity.y) {

            if velocity.x > 0 && categoryIndex > 0 {
                categoryIndex -= 1
            } else if velocity.x < 0 && categoryIndex < MainManager.shared.availableCategories.count-1 {
                categoryIndex += 1
            }
            actsTableView.reloadData()
        }
    }
}

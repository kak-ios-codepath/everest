//
//  AddActionViewController.swift
//  Everest
//
//  Created by Kavita Gaitonde on 10/13/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit
import LNICoverFlowLayout

class AddActionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  
  @IBOutlet weak private var categoriesCollectionView: UICollectionView!
  @IBOutlet weak private var coverFlowLayout: LNICoverFlowLayout!
  
  private var originalItemSize = CGSize.zero
  private var originalCollectionViewSize = CGSize.zero
  
  private let titles = ["Empathy", "Surprise"]
  private let photoUrls = ["http://www.spring.org.uk/images/empathy-1.jpg", "https://www.lipstiq.com/wp-content/uploads/2014/06/62.jpg"]
  private var categories = [String: [Act]]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    categoriesCollectionView.delegate = self
    fetchCategoriesAndActs()
    
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
    coverFlowLayout.minCoverScale = 0.69
    coverFlowLayout.minCoverOpacity = 0.50
  }
  
  func fetchCategoriesAndActs() {
    for title in titles {
      FireBaseManager.shared.fetchAvailableActs(category: title) {(actArray, error) in
        if error == nil {
          self.categories[title] = actArray
          self.categoriesCollectionView.reloadData()
        }
      }
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return categories.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCollectionCell", for: indexPath) as? CategoryCollectionCell else {return UICollectionViewCell()}
    cell.categoryPhotoURL = photoUrls[indexPath.row]
    cell.categoryTitle = titles[indexPath.row]
    return cell
  }
  
}

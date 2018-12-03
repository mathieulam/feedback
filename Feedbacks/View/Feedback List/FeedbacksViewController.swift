//
//  ViewController.swift
//  Feedbacks
//
//  Created by Mathieu Lamvohee on 10/31/18.
//  Copyright © 2018 Mathieu Lamvohee. All rights reserved.
//

import UIKit
import FlexiblePageControl
import Mapbox

class FeedbacksViewController: UIViewController, FeedbackProtocol, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource{
    @IBOutlet weak var feedbackTableView: UITableView!
    @IBOutlet weak var countryCollectionView: UICollectionView!
    @IBOutlet weak var pageControlContainerView: UIView!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    
    var feedbackList: [FeedbackModel] = []
    var presenter: FeedbackPresenter!
    var collectionViewCurrentIndexPath: IndexPath = [0,0]
    let countryPageControl = FlexiblePageControl()
    var mapView: CustomMapView!
    var selectedIndexPath: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TableView
        feedbackTableView.delegate = self
        feedbackTableView.dataSource = self
        feedbackTableView.register(UINib(nibName: "FeedbackTableViewCell", bundle: nil), forCellReuseIdentifier: FeedbackTableViewCell.reuseId)
        
        //CollectionView
        countryCollectionView.delegate = self
        countryCollectionView.dataSource = self
        countryCollectionView.register(UINib(nibName: "CountryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CountryCollectionViewCell.reuseId)
        countryCollectionView.collectionViewLayout = CountryCollectionViewFlowLayout()
        
        presenter = FeedbackPresenter(feedbackView: self)
        presenter.getFeedbacks()
        
        //Page Control
        countryPageControl.numberOfPages = presenter.getCountryListSize()
        countryPageControl.pageIndicatorTintColor = .white
        countryPageControl.currentPageIndicatorTintColor = .black
        countryPageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControlContainerView.addSubview(countryPageControl)
        
        
        let widthConstraint = NSLayoutConstraint(item: countryPageControl, attribute: .width, relatedBy: .equal,
                                                 toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100)
        
        let heightConstraint = NSLayoutConstraint(item: countryPageControl, attribute: .height, relatedBy: .equal,
                                                  toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 25)
        
        let xConstraint = NSLayoutConstraint(item: countryPageControl, attribute: .centerX, relatedBy: .equal, toItem: self.pageControlContainerView, attribute: .centerX, multiplier: 1, constant: 0)
        
        let yConstraint = NSLayoutConstraint(item: countryPageControl, attribute: .centerY, relatedBy: .equal, toItem: self.pageControlContainerView, attribute: .centerY, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([widthConstraint, heightConstraint, xConstraint, yConstraint])
        
        self.tableViewTopConstraint.constant = UIScreen.main.bounds.height * 0.6
        
        self.view.setNeedsUpdateConstraints()
        self.view.layoutIfNeeded()
        
        //MapView
        mapView = CustomMapView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        mapView.configureIsNeeded()
        mapView.alpha = 0
        
        UIView.animate(withDuration: 1.0) {
            self.mapView.alpha = 1.0
        }
        
        self.view.insertSubview(mapView, at: 0)
    }
    
    //MARK: - Feedback protocol
    
    func refreshData() {
        DispatchQueue.main.async {
            self.countryCollectionView.reloadData()
            self.feedbackTableView.reloadData()
            self.mapView.feedbackList = self.presenter.getFeedbackList(forCountry: self.presenter.getCountryList()[self.collectionViewCurrentIndexPath.row])
            self.mapView.isConfugured = false
            self.mapView.configureIsNeeded()
            self.mapView.showAnnotations(self.mapView.annotationList, animated: true)
        }
        
    }
    
    //MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if presenter.getCountryList().isEmpty {
            return 0
        }
        return presenter.getFeedbackListSize(forCountry: presenter.getCountryList()[collectionViewCurrentIndexPath.row])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedbackTableViewCell.reuseId, for: indexPath) as? FeedbackTableViewCell else {
            fatalError("Couldn't dequeue cell with identifier \(FeedbackTableViewCell.reuseId)")
        }
        let currentCountry = presenter.getCountryList()[collectionViewCurrentIndexPath.row]
        let currentCountryFeedbackList = presenter.getFeedbackList(forCountry: currentCountry)
        cell.configureCell(feedback: currentCountryFeedbackList[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndexPath = indexPath.row
        let currentCountry = presenter.getCountryList()[collectionViewCurrentIndexPath.row]
        self.performSegue(withIdentifier: "show_details", sender: presenter.getFeedbackList(forCountry: currentCountry))
    }
    
    //MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getCountryListSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CountryCollectionViewCell.reuseId, for: indexPath) as? CountryCollectionViewCell else {
            fatalError("Couldn't dequeue cell with identifier \(CountryCollectionViewCell.reuseId)")
        }
        let currentCountry = presenter.getCountryList()[indexPath.row]
        let averageRating = presenter.getAverageRating(forCountry: currentCountry)
        cell.configureCell(countryName: currentCountry, totalRating: presenter.getFeedbackListSize(forCountry: currentCountry), averageRating: averageRating)
        let count = presenter.getCountryListSize()
        countryPageControl.numberOfPages = count
        countryPageControl.isHidden = !(count > 1)
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if let _ = scrollView as? UICollectionView {
            var visibleRect = CGRect()
            
            visibleRect.origin = countryCollectionView.contentOffset
            visibleRect.size = countryCollectionView.bounds.size
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            guard let indexPath = countryCollectionView.indexPathForItem(at: visiblePoint) else { return }
            collectionViewCurrentIndexPath = indexPath
            countryPageControl.setCurrentPage(at: collectionViewCurrentIndexPath.row)
            feedbackTableView.reloadData()
            let tableViewIndexPath = IndexPath(row: 0, section: 0)
            self.feedbackTableView.scrollToRow(at: tableViewIndexPath, at: .top, animated: true)
            
            mapView.feedbackList = presenter.getFeedbackList(forCountry: presenter.getCountryList()[collectionViewCurrentIndexPath.row])
            mapView.isConfugured = false
            mapView.configureIsNeeded()
            mapView.showAnnotations(mapView.annotationList, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show_details" {
            let feedbackDetailViewController = segue.destination as! FeedbackDetailsViewController
            let currentCountry = presenter.getCountryList()[collectionViewCurrentIndexPath.row]
            let feedbackList = presenter.getFeedbackList(forCountry: currentCountry)
            if !feedbackList.isEmpty {
                feedbackDetailViewController.feedback = feedbackList[selectedIndexPath]
            }
        }
    }
    
}


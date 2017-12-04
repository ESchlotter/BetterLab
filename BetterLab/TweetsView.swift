//
//  TweetsView.swift
//  BetterLab
//
//  Created by Eduard Schlotter on 04/12/2017.
//  Copyright © 2017 eschlotter. All rights reserved.
//

import UIKit
import Kingfisher

class TweetsView: UIView {
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    
    // MARK: - Class Members
    
    //Refresh control for pull to refresh.
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TweetsView.handlePullToRefresh(_:)), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    //View model
    let viewModel = TweetViewModel()

    override func didMoveToSuperview() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
    }
    @objc func methodOfReceivedNotification(notification: Notification){
        print("loaded")
        self.viewModel.authenticate()
        setupUI()
        setDelegates()
        setupTableView()
    }
    
    
    func setupUI() {
        //Navigation Bar Title
        //self.title = "@" + Constants.Config.twitterHandle
        //Add further UI customization if required.
    }
    
    func setDelegates() {
        //View model delegate
        self.viewModel.delegate = self as TweetViewModelProtocol
        //Tableview delegate and datasource
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func setupTableView() {
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "TweetTableViewCell", bundle: nil), forCellReuseIdentifier: "TweetTableViewCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120
        self.tableView.addSubview(self.refreshControl)
    }
    
    //MARK: - Pull To Refresh
    
    func handlePullToRefresh(_ refreshControl: UIRefreshControl) {
        self.viewModel.loadInitialTweets()
    }

}

extension TweetsView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell", for: indexPath) as! TweetTableViewCell
        let thisTweet = viewModel.tweets[indexPath.row]
        cell.headerLabel.text = thisTweet.username
        cell.bodyLabel.text = thisTweet.text
        cell.tweetImageView.kf.setImage(with: thisTweet.profileImageURL)
        return cell
    }
    
}

// MARK: - UIScrollView + UITableView Delegate

extension TweetsView: UITableViewDelegate, UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollContentHeight = scrollView.contentSize.height + scrollView.contentInset.bottom
        let scrollBottomPosition = scrollView.contentOffset.y + scrollView.bounds.size.height
        let difference = scrollContentHeight - scrollBottomPosition
        
        //Difference determines the offset remaining to reach the bottom from user's current position.
        //We trigger load more when the difference is reached to enable smooth scrolling, considering a user's normal reading pace.
        if difference < 200 && !self.viewModel.isLoadingMore {
            self.viewModel.loadPreviousTweets() //Load more tweets
        }
        
    }
    
}

extension TweetsView: TweetViewModelProtocol {
    
    //Used by view model to update view whenever data changes.
    func reloadData() {
        DispatchQueue.main.async(execute: { [weak self] in
            self?.loadingView.isHidden = true
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
        })
    }
    
}

//
//  ViewController.swift
//  SwiftMvc
//
//  Created by Umesh Karhe on 04/02/17.
//  Copyright © 2017 Umesh Karhe. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var filterCollectionView: FilterCollectionView!
    var moviesData = [Movies]()
    var moviesToFilterData = [Movies]()
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var filterButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        ModelViewController.sharedInstance.processRequestWith(requestType: .GetTopMovies, modelType: .MoviesModel, parameters: nil)
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "NotificationMoviesData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMoviesData(notification:)), name: Notification.Name(rawValue: "NotificationMoviesData"), object: nil)
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
    }
    
    @objc func refresh()  {
        ModelViewController.sharedInstance.processRequestWith(requestType: .GetTopMovies, modelType: .MoviesModel, parameters: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        filterCollectionView.reloadData()
        filterCollectionView.deledate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickOfFilterButton(_ sender: Any) {
        if (sender as! UIBarButtonItem).title == "Filter" {
            (sender as! UIBarButtonItem).title = "Cancel"
            self.filterTopConstraint.constant = 0
        }else if (sender as! UIBarButtonItem).title == "Cancel" {
            (sender as! UIBarButtonItem).title = "Filter"
            self.filterTopConstraint.constant = -130
        }
    }
    
    @objc func didReceiveMoviesData(notification: Notification) -> Void {
        refreshControl.endRefreshing()
        UserDefaults.standard.set("All", forKey: "SelectedFilterValue")
        moviesData = (notification.userInfo!["MoviesData"] as? [Movies])!
        moviesToFilterData = (notification.userInfo!["MoviesData"] as? [Movies])!
        collectionView.reloadData()
        filterCollectionView.reloadData()
    }
    
    private func downloadImageFrom(_ link: NSString, cell: MoviesCollectionViewCell) {
        URLSession.shared.dataTask( with: NSURL(string: link as String)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async() {
                if let data = data {
                    cell.movieIcon.image = UIImage(data: data)
                    var path = Utility.sharedInstance.createDirectoryWithName(directoryName: "Images")
                    path = path.appendingFormat("/%@", link.lastPathComponent)
                    
                    let result = (data as NSData).write(toFile: path, atomically: true)
                    if result == true{
                        //print("Image saved")
                    }
                }
            }
        }).resume()
    }
    
    private func setImageToCImageView(imageUrlString: NSString, cell: MoviesCollectionViewCell){
        let imagesFolder = Utility.sharedInstance.createDirectoryWithName(directoryName: "Images")
        let imagePath = imagesFolder + "/" + imageUrlString.lastPathComponent
        var image = UIImage(named: imageUrlString.lastPathComponent)
        if FileManager.default.fileExists(atPath: imagePath) {
            image = UIImage(contentsOfFile: imagePath)
        }
        if image == nil{
            self.downloadImageFrom(imageUrlString as NSString, cell: cell)
        } else {
            cell.movieIcon.image = image
        }
    }
}

extension MoviesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return moviesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviesCollectionViewCell", for: indexPath) as! MoviesCollectionViewCell
        let movie = moviesData[indexPath.row]
        if let title = movie.title {
            cell.movieTitle.text = title
        }
        cell.rating.text = String(movie.rating)
        cell.yearReleased.text = String(movie.releaseYear)
        self.setImageToCImageView(imageUrlString: movie.image! as NSString, cell: cell)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: self.view.frame.size.width/2-15, height: self.view.frame.size.height/3)
        return size
    }
}

extension MoviesViewController: FilterCollectionViewDelegate {
    func didSelectCell(_ collectionView: UICollectionView, selectedValue: String) {
        print("\(selectedValue)")
        self.filterButton.title = "Filter"
        self.filterTopConstraint.constant = -130
        if selectedValue == "All" {
            let filteredArray = moviesToFilterData
            moviesData = filteredArray
        }else {
            let filteredArray = moviesToFilterData.filter { (movie) -> Bool in
                (movie.genre?.contains(selectedValue))!
            }
            moviesData = filteredArray
        }
        self.collectionView.reloadData()
        UserDefaults.standard.set(selectedValue, forKey: "SelectedFilterValue")
        self.filterCollectionView.reloadData()
    }
}

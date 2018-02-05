//
//  FilterCollectionView.swift
//  Movies
//
//  Created by Umesh Karhe on 04/02/18.
//  Copyright © 2018 Umesh Karhe. All rights reserved.
//

import UIKit

protocol FilterCollectionViewDelegate: class {
    func didSelectCell(_ collectionView: UICollectionView, selectedValue: String)
}

class FilterCollectionView: UICollectionView {
    weak var deledate: FilterCollectionViewDelegate?
    
    let filterValues = ["All","Animation","Adventure","Family","Action","Drama","Sci-Fi","Horror","Thriller","Comedy","Fantasy"]
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dataSource = self
        self.delegate = self
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension FilterCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterValues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionViewCell", for: indexPath) as! FilterCollectionViewCell
        cell.filterTitle.text = filterValues[indexPath.row]
        cell.filterTitle.backgroundColor = UIColor.darkGray
        if let selectedValue = UserDefaults.standard.value(forKey: "SelectedFilterValue") as? String {
            if selectedValue == filterValues[indexPath.row] {
                cell.filterTitle.backgroundColor = UIColor.cyan
            }else {
                cell.filterTitle.backgroundColor = UIColor.darkGray
            }
        }
        return cell
    }
    
}

extension FilterCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 100, height: 21)
        return size
    }
}

extension FilterCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if let delegateAssigned = self.deledate {
            let filterValue = filterValues[indexPath.row]
            delegateAssigned.didSelectCell(collectionView, selectedValue: filterValue
            )
        }
    }
}

//
//  URBNSwiftCollectionViewController.swift
//  URBNDataSource
//
//  Created by Dustin Bergman on 12/14/15.
//  Copyright © 2015 Joe. All rights reserved.
//

import UIKit
import URBNDataSource

class URBNSwiftCollectionViewController: UICollectionViewController {

    lazy var adapter: URBNArrayDataSourceAdapter = {
        return URBNArrayDataSourceAdapter(items: ["Item 1", "Item 2", "Item 3", "Item 4"])
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.headerReferenceSize = CGSizeMake(300.0, 50.0)
            layout.footerReferenceSize = CGSizeMake(300.0, 50.0)
        }
        
        self.adapter.fallbackDataSource = self
        self.adapter.collectionView = collectionView

        /// If all of your cell classes are unique, then you can just call regsiter cell with that class.
        /// The identifier will be the className
        adapter.registerCell { (cell: UICollectionViewCell, data: NSString, indexPath) -> () in
            cell.backgroundColor = UIColor.cyanColor().colorWithAlphaComponent(0.8)
            if let cellLabel = cell.viewWithTag(100) as? UILabel {
                cellLabel.text = data as String
            }
            else {
                let cellLabel = UILabel(frame: cell.contentView.bounds)
                cellLabel.tag = 100
                cellLabel.numberOfLines = 0
                cellLabel.backgroundColor = .clearColor()
                cellLabel.font = UIFont.systemFontOfSize(30.0)
                cellLabel.textColor = .blackColor()
                cellLabel.textAlignment = .Center
                cellLabel.text = data as String
                cell.contentView.addSubview(cellLabel)
            }
        }
        
        /// Since this is a different subclass than the UICollectionViewCell we're doing above, there's no need to supply an identifier
        /// Since this Cell has a nib file, it will be instantiated from that nib as well.
        adapter.registerCell { (cell: CustomCollectionCellFromNib, data: NSString, indexPath) -> () in
            cell.label?.text = "Custom Cell " + (data as String)
        }
        
        /// Since we've registered an `UICollectionViewCell` above, we should supply an identifier for this cell
        adapter.registerCell("My Identifier") { (cell: UICollectionViewCell, data: NSString, indexPath) in
            cell.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.8)
            if let cellLabel = cell.viewWithTag(100) as? UILabel {
                cellLabel.text = data as String
            }
            else {
                let cellLabel = UILabel(frame: cell.contentView.bounds)
                cellLabel.tag = 100
                cellLabel.numberOfLines = 0
                cellLabel.backgroundColor = .clearColor()
                cellLabel.font = UIFont.systemFontOfSize(30.0)
                cellLabel.textColor = .blackColor()
                cellLabel.textAlignment = .Center
                cellLabel.text = data as String
                cell.contentView.addSubview(cellLabel)
            }
        }
        
        /// Here we're registering a UICollectionReusableView for our section headers.  Pretty sweet
        adapter.registerHeaderView { (headerView: UICollectionReusableView, kind, indexPath) -> () in
            headerView.backgroundColor = UIColor.orangeColor().colorWithAlphaComponent(0.8)
            headerView.layer.borderWidth = 1.0
            
            if let viewLabel = headerView.viewWithTag(100) as? UILabel {
                viewLabel.text = "Collection HeaderView " + String(indexPath.section)
            }
            else {
                let viewLabel = UILabel(frame: headerView.bounds)
                viewLabel.tag = 100
                viewLabel.numberOfLines = 0
                viewLabel.backgroundColor = .clearColor()
                viewLabel.font = UIFont.systemFontOfSize(30.0)
                viewLabel.textColor = .blackColor()
                viewLabel.textAlignment = .Center
                viewLabel.text = "Collection HeaderView " + String(indexPath.section)
                headerView.addSubview(viewLabel)
            }
        }
        
        /// Here we're registering a UICollectionReusableView for our section footers.  Pretty sweet.
        /// Notice that we're not supplying an identifier here.  That's because it's not needed.
        /// Even though we're registering configuration blocks for the same class, since they're different kinds (`URBNSupplementaryViewTypeFooter` vs. `URBNSupplementaryViewTypeHeader`)
        /// we can ignore the identifier
        adapter.registerFooterView { (footerView: UICollectionReusableView, kind, indexPath) -> () in
            footerView.backgroundColor = UIColor.purpleColor().colorWithAlphaComponent(0.1)
            footerView.layer.borderWidth = 1.0
            
            if let viewLabel = footerView.viewWithTag(100) as? UILabel {
                viewLabel.text = "Collection FooterView " + String(indexPath.section)
            }
            else {
                let viewLabel = UILabel(frame: footerView.bounds)
                viewLabel.tag = 100
                viewLabel.numberOfLines = 0
                viewLabel.backgroundColor = .clearColor()
                viewLabel.font = UIFont.systemFontOfSize(30.0)
                viewLabel.textColor = .blackColor()
                viewLabel.textAlignment = .Center
                viewLabel.text = "Collection FooterView " + String(indexPath.section)
                footerView.addSubview(viewLabel)
            }
        }
        
        /// Since we want more than  1 identifier, we need to supply an identifier configuration here.
        adapter.cellIdentifierBlock = { (type, indexPath) -> String in
            let cellIdentifiers = [NSStringFromClass(UICollectionViewCell.self), NSStringFromClass(CustomCollectionCellFromNib.self), "My Identifier"]
            
            return cellIdentifiers[(indexPath.item % cellIdentifiers.count)]
        }
        
        collectionView?.dataSource = adapter
    }
    
    @IBAction func toggleSectionedData(sender: UIBarButtonItem) {
        var data = [AnyObject]()
        if adapter.isSectioned() {
            /// We're not sectioned.  Let's make it sectioned
            data = ["Item 1", "Item 2", "Item 3", "Item 4"]
        }
        else {
            /// We're already sectioned.  Make this a flat list
            data = [["Section 1 item 1", "Section 1 Item 2"],   // Section1
                ["Section 2 item 1", "Section 2 Item 2"],   // Section2
                ["Section 3 item 1", "Section 3 Item 2"],   // Section3
                ["Section 4 item 1", "Section 4 Item 2"]]   // Section4
        }
        
        let sectionStatus = adapter.isSectioned() ? "Off" : "On"
        sender.title = "Sections: " + sectionStatus
        
        adapter.replaceItems(data)
    }
}

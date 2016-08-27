//
//  StoreViewController.swift
//  Ball Hero
//
//  Created by David Taylor on 7/16/15.
//  Copyright (c) 2015 Hyper Elephant. All rights reserved.
//

import UIKit
import StoreKit

class StoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    var tableView = UITableView()
    let productIdentifiers = Set(["RemoveAds","add5Continues"])
    var product: SKProduct?
    var productsArray = Array<SKProduct>()
    var buyButton = UIButton(frame: CGRectMake(UIScreen.mainScreen().bounds.width - 60.0, 5.0, 50.0, 20.0))
    var UIScale = CGFloat(1)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            UIScale = 1.5
        }
        
        tableView = UITableView(frame: self.view.frame)
        tableView.backgroundColor = UIColor(red: 0.925, green: 0.376, blue: 0.957, alpha: 1)
        tableView.separatorColor = UIColor.clearColor()
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        
        let doneButton = UIButton(frame: CGRectMake(UIScreen.mainScreen().bounds.width - 60.0, UIScreen.mainScreen().bounds.height - 20.0, 50.0, 20.0))
        doneButton.titleLabel!.font = UIFont (name: "HelveticaNeue", size: 12 * UIScale)
        doneButton.addTarget(self, action: #selector(StoreViewController.buyProduct(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        doneButton.backgroundColor = UIColor.blackColor()
        
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        requestProductData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        SKPaymentQueue.defaultQueue().removeTransactionObserver(self)
    }
    
    // In-App Purchase Methods
    
    func requestProductData()
    {
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers: self.productIdentifiers)
            request.delegate = self
            request.start()
        } else {
            let alert = UIAlertController(title: "In-App Purchases Not Enabled", message: "Please enable In App Purchase in Settings", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default, handler: { alertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
                
                let url: NSURL? = NSURL(string: UIApplicationOpenSettingsURLString)
                if url != nil
                {
                    UIApplication.sharedApplication().openURL(url!)
                }
                
            }))
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { alertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        
        var products = response.products
        
        if (products.count != 0) {
            for i in 0 ..< products.count
            {
                self.product = products[i]
                self.productsArray.append(product!)
            }
            self.tableView.reloadData()
        } else {
            print("No products found")
        }
        let otherProducts = response.invalidProductIdentifiers
        for product in otherProducts
        {
            print("Product not found: \(product)")
        }
    }
    
    func buyProduct(sender: UIButton) {
        let payment = SKPayment(product: productsArray[sender.tag])
        SKPaymentQueue.defaultQueue().addPayment(payment)
    }
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            
            switch transaction.transactionState {
                
            case SKPaymentTransactionState.Purchased:
                print("Transaction Approved")
                print("Product Identifier: \(transaction.payment.productIdentifier)")
                self.deliverProduct(transaction)
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                
            case SKPaymentTransactionState.Failed:
                print("Transaction Failed")
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
    func deliverProduct(transaction:SKPaymentTransaction) {
        
        if transaction.payment.productIdentifier == "RemoveAds"
        {
            print("Ad Remove Purchased")
            // Remove Ads
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "RemoveAds")
            NSNotificationCenter.defaultCenter().postNotificationName("removeAds", object: nil)
        } else if transaction.payment.productIdentifier == "add5Continues" {
            print("5 Continues Purchased")
            // Add 5 Continues
            var continues = NSUserDefaults.standardUserDefaults().integerForKey("continues")
            continues += 5
            NSUserDefaults.standardUserDefaults().setInteger(continues, forKey: "continues")
            NSNotificationCenter.defaultCenter().postNotificationName("updateContinues", object: nil)
        }
    }
    
    func restorePurchases(sender: UIButton) {
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
        print("Transactions Restored")
        
//        var purchasedItemIDS = []
        for transaction:SKPaymentTransaction in queue.transactions {
            
            if transaction.payment.productIdentifier == "RemoveAds"
            {
                print("Ad Remove Purchased")
                // Remove Ads
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "RemoveAds")
                NSNotificationCenter.defaultCenter().postNotificationName("removeAds", object: nil)
            }
        }
        let alert = UIAlertView(title: "Thank You", message: "Your purchase(s) were restored.", delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    
    // Screen Layout Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.productsArray.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellFrame = CGRectMake(0, 0, self.tableView.frame.width, 52.0)
        let retCell = UITableViewCell(frame: cellFrame)
        
        retCell.backgroundColor = UIColor(red: 0.925, green: 0.376, blue: 0.957, alpha: 1)
        
        if self.productsArray.count != 0
        {
            if indexPath.row == 2
            {
                let restoreButton = UIButton(frame: CGRectMake(10.0, 10.0, UIScreen.mainScreen().bounds.width - 20.0, 44.0))
                restoreButton.titleLabel!.font = UIFont (name: "HelveticaNeue-Bold", size: 20)
                restoreButton.addTarget(self, action: #selector(StoreViewController.restorePurchases(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                restoreButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
                restoreButton.setTitle("Restore Purchases", forState: UIControlState.Normal)
                restoreButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                retCell.addSubview(restoreButton)
            }
            else
            {
                let singleProduct = productsArray[indexPath.row]
                
                let titleLabel = UILabel(frame: CGRectMake(10.0, 0.0, UIScreen.mainScreen().bounds.width - 20.0, 25.0))
                titleLabel.textColor = UIColor.blackColor()
                titleLabel.text = singleProduct.localizedTitle
                titleLabel.font = UIFont (name: "HelveticaNeue", size: 20 * UIScale)
                retCell.addSubview(titleLabel)
                
                let descriptionLabel = UILabel(frame: CGRectMake(10.0, 10.0, UIScreen.mainScreen().bounds.width - 70.0, 40.0))
                descriptionLabel.textColor = UIColor.blackColor()
                descriptionLabel.text = singleProduct.localizedDescription
                descriptionLabel.font = UIFont (name: "HelveticaNeue-Light", size: 12 * UIScale)
                retCell.addSubview(descriptionLabel)
                
                let buyButton = UIButton(frame: CGRectMake(UIScreen.mainScreen().bounds.width - 60.0, 5.0, 50.0, 20.0))
                buyButton.titleLabel!.font = UIFont (name: "HelveticaNeue", size: 12 * UIScale)
                buyButton.tag = indexPath.row
                buyButton.addTarget(self, action: #selector(StoreViewController.buyProduct(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                buyButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
                let numberFormatter = NSNumberFormatter()
                numberFormatter.numberStyle = .CurrencyStyle
                numberFormatter.locale = NSLocale.currentLocale()
                buyButton.setTitle(numberFormatter.stringFromNumber(singleProduct.price), forState: UIControlState.Normal)
                buyButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                retCell.addSubview(buyButton)
            }
        }
        
        return retCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 52.0 * UIScale
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 0
        {
            return 64.0 * UIScale
        }
        
        return 32.0 * UIScale
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView:UIView = UIView(frame: CGRectMake(0, 0, self.tableView.frame.width, self.tableView.frame.height))
        
        let headerTitle = UILabel(frame: CGRectMake(10, 0, self.tableView.frame.width - 20, 32.0 * UIScale))
        headerTitle.backgroundColor = UIColor.clearColor()
        headerTitle.text = "Target Ball Store"
        headerTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 26 * UIScale)
        headerTitle.textAlignment = NSTextAlignment.Center
        headerView.addSubview(headerTitle)
        
        let doneButton = UIButton(frame: CGRectMake(self.tableView.frame.width / 2 - 20, 0, self.tableView.frame.width - 20, 32 * UIScale))
        doneButton.setTitle("Done", forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        doneButton.backgroundColor = UIColor.clearColor()
        doneButton.addTarget(self, action: #selector(StoreViewController.closeStore(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        headerView.addSubview(doneButton)
        
        return headerView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func closeStore(sender:UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}



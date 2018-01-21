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
    var buyButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 60.0, y: 5.0, width: 50.0, height: 20.0))
    var UIScale = CGFloat(1)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if UIDevice.current.userInterfaceIdiom == .pad {
            UIScale = 1.5
        }
        
        tableView = UITableView(frame: self.view.frame)
        tableView.backgroundColor = UIColor(red: 0.925, green: 0.376, blue: 0.957, alpha: 1)
        tableView.separatorColor = UIColor.clear
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        
        let doneButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 60.0, y: UIScreen.main.bounds.height - 20.0, width: 50.0, height: 20.0))
        doneButton.titleLabel!.font = UIFont (name: "HelveticaNeue", size: 12 * UIScale)
        doneButton.addTarget(self, action: #selector(StoreViewController.buyProduct(_:)), for: UIControlEvents.touchUpInside)
        doneButton.backgroundColor = UIColor.black
        
        SKPaymentQueue.default().add(self)
        requestProductData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SKPaymentQueue.default().remove(self)
    }
    
    // In-App Purchase Methods
    
    func requestProductData()
    {
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers: self.productIdentifiers)
            request.delegate = self
            request.start()
        } else {
            let alert = UIAlertController(title: "In-App Purchases Not Enabled", message: "Please enable In App Purchase in Settings", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.default, handler: { alertAction in
                alert.dismiss(animated: true, completion: nil)
                
                let url: URL? = URL(string: UIApplicationOpenSettingsURLString)
                if url != nil
                {
                    UIApplication.shared.openURL(url!)
                }
                
            }))
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { alertAction in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
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
    
    @objc func buyProduct(_ sender: UIButton) {
        let payment = SKPayment(product: productsArray[sender.tag])
        SKPaymentQueue.default().add(payment)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            
            switch transaction.transactionState {
                
            case SKPaymentTransactionState.purchased:
                print("Transaction Approved")
                print("Product Identifier: \(transaction.payment.productIdentifier)")
                self.deliverProduct(transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
                
            case SKPaymentTransactionState.failed:
                print("Transaction Failed")
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
    func deliverProduct(_ transaction:SKPaymentTransaction) {
        
        if transaction.payment.productIdentifier == "RemoveAds"
        {
            print("Ad Remove Purchased")
            // Remove Ads
            UserDefaults.standard.set(true, forKey: "RemoveAds")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "removeAds"), object: nil)
        } else if transaction.payment.productIdentifier == "add5Continues" {
            print("5 Continues Purchased")
            // Add 5 Continues
            var continues = UserDefaults.standard.integer(forKey: "continues")
            continues += 5
            UserDefaults.standard.set(continues, forKey: "continues")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "updateContinues"), object: nil)
        }
    }
    
    @objc func restorePurchases(_ sender: UIButton) {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("Transactions Restored")
        
//        var purchasedItemIDS = []
        for transaction:SKPaymentTransaction in queue.transactions {
            
            if transaction.payment.productIdentifier == "RemoveAds"
            {
                print("Ad Remove Purchased")
                // Remove Ads
                UserDefaults.standard.set(true, forKey: "RemoveAds")
                NotificationCenter.default.post(name: Notification.Name(rawValue: "removeAds"), object: nil)
            }
        }
        let alert = UIAlertView(title: "Thank You", message: "Your purchase(s) were restored.", delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    
    // Screen Layout Methods
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.productsArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellFrame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 52.0)
        let retCell = UITableViewCell(frame: cellFrame)
        
        retCell.backgroundColor = UIColor(red: 0.925, green: 0.376, blue: 0.957, alpha: 1)
        
        if self.productsArray.count != 0
        {
            if (indexPath as NSIndexPath).row == 2
            {
                let restoreButton = UIButton(frame: CGRect(x: 10.0, y: 10.0, width: UIScreen.main.bounds.width - 20.0, height: 44.0))
                restoreButton.titleLabel!.font = UIFont (name: "HelveticaNeue-Bold", size: 20)
                restoreButton.addTarget(self, action: #selector(StoreViewController.restorePurchases(_:)), for: UIControlEvents.touchUpInside)
                restoreButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
                restoreButton.setTitle("Restore Purchases", for: UIControlState())
                restoreButton.setTitleColor(UIColor.black, for: UIControlState())
                retCell.addSubview(restoreButton)
            }
            else
            {
                let singleProduct = productsArray[(indexPath as NSIndexPath).row]
                
                let titleLabel = UILabel(frame: CGRect(x: 10.0, y: 0.0, width: UIScreen.main.bounds.width - 20.0, height: 25.0))
                titleLabel.textColor = UIColor.black
                titleLabel.text = singleProduct.localizedTitle
                titleLabel.font = UIFont (name: "HelveticaNeue", size: 20 * UIScale)
                retCell.addSubview(titleLabel)
                
                let descriptionLabel = UILabel(frame: CGRect(x: 10.0, y: 10.0, width: UIScreen.main.bounds.width - 70.0, height: 40.0))
                descriptionLabel.textColor = UIColor.black
                descriptionLabel.text = singleProduct.localizedDescription
                descriptionLabel.font = UIFont (name: "HelveticaNeue-Light", size: 12 * UIScale)
                retCell.addSubview(descriptionLabel)
                
                let buyButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 60.0, y: 5.0, width: 50.0, height: 20.0))
                buyButton.titleLabel!.font = UIFont (name: "HelveticaNeue", size: 12 * UIScale)
                buyButton.tag = (indexPath as NSIndexPath).row
                buyButton.addTarget(self, action: #selector(StoreViewController.buyProduct(_:)), for: UIControlEvents.touchUpInside)
                buyButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .currency
                numberFormatter.locale = Locale.current
                buyButton.setTitle(numberFormatter.string(from: singleProduct.price), for: UIControlState())
                buyButton.setTitleColor(UIColor.black, for: UIControlState())
                retCell.addSubview(buyButton)
            }
        }
        
        return retCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 52.0 * UIScale
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 0
        {
            return 64.0 * UIScale
        }
        
        return 32.0 * UIScale
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableView.frame.height))
        
        let headerTitle = UILabel(frame: CGRect(x: 10, y: 0, width: self.tableView.frame.width - 20, height: 32.0 * UIScale))
        headerTitle.backgroundColor = UIColor.clear
        headerTitle.text = "Target Ball Store"
        headerTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 26 * UIScale)
        headerTitle.textAlignment = NSTextAlignment.center
        headerView.addSubview(headerTitle)
        
        let doneButton = UIButton(frame: CGRect(x: self.tableView.frame.width / 2 - 20, y: 0, width: self.tableView.frame.width - 20, height: 32 * UIScale))
        doneButton.setTitle("Done", for: UIControlState())
        doneButton.setTitleColor(UIColor.black, for: UIControlState())
        doneButton.backgroundColor = UIColor.clear
        doneButton.addTarget(self, action: #selector(StoreViewController.closeStore(_:)), for: UIControlEvents.touchUpInside)
        headerView.addSubview(doneButton)
        
        return headerView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func closeStore(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)

    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
}



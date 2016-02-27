//
//  ViewController.swift
//  bin-finder
//
//  Created by Sergio Marron on 2/27/16.
//  Copyright © 2016 Sergio Marron. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var binField: UITextField!
    
    @IBOutlet weak var brandLbl: UILabel!
    
    @IBOutlet weak var bankLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var cardImg: UIImageView!
    
    @IBOutlet weak var searchBtn: UIButton!
    
    let URL_BINLIST = "http://www.binlist.net/json"
    
    let SUPPORTED_BRANDS = ["amex", "american express" , "visa", "mastercard", "maestro", "discover"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        binField.delegate = self
        searchBtn.layer.cornerRadius = 5.0
    }
   
    func loadBinData() {
        if let bin = binField.text {
            
            let urlStr = "\(URL_BINLIST)/\(bin)"
            
            Alamofire.request(.GET, NSURL(string: urlStr)!).responseJSON { response in
                
                if let dict = response.result.value as? Dictionary<String, AnyObject> {
                    
                    if var brand = dict["brand"] as? String {
                        
                        if self.SUPPORTED_BRANDS.contains(brand.lowercaseString) {
                            
                            self.brandLbl.text = brand
                            
                            if brand.lowercaseString == "american express" {
                                brand = "amex"
                            }
                            
                            self.cardImg.image = UIImage(named: "\(brand.lowercaseString).png")
                            self.cardImg.hidden = false
                            
                            if let bank = dict["bank"] as? String {
                                self.bankLbl.text = bank
                            }
                            if let country = dict["country_name"] as? String {
                                self.countryLbl.text = country
                            }
                            if let type = dict["card_type"] as? String {
                                self.typeLbl.text = type
                            }

                        } else {
                            self.brandLbl.text = ""
                            self.bankLbl.text = ""
                            self.countryLbl.text = ""
                            self.typeLbl.text = ""
                            self.cardImg.hidden = true
                        }
                        
                    }
                    
                } else {
                    self.brandLbl.text = ""
                    self.bankLbl.text = ""
                    self.countryLbl.text = ""
                    self.typeLbl.text = ""
                    self.cardImg.hidden = true
                }
            
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func searchBtnTapped(sender: UIButton) {
        self.view.endEditing(true)
        loadBinData()
    }
    

}


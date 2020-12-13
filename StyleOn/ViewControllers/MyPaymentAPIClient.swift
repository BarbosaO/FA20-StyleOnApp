//
//  MyAPIClient.swift
//  SwiftSeriesStripeIntegration
//
//  Created by Chandra Bhushan on 28/12/2019.
//  Copyright © 2019 Chandra Bhushan. All rights reserved.
//

import Foundation
import Alamofire
import Stripe
class MyPaymentAPIClient: NSObject,STPCustomerEphemeralKeyProvider {
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        var url = URL(string: "https://znon-app.herokuapp.com/")!
        url.appendPathComponent("ephemeral_keys")
        let parameters = ["api_version":apiVersion]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: [:]).responseJSON { (apiResponse) in
            let data = apiResponse.data
            guard let json = ((try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]) as [String : Any]??) else {
                completion(nil, apiResponse.error)
                return
            }
            completion(json, nil)
        }
    }
    
    class func createCustomer(){
        
        var customerDetailParams = [String:String]()
        customerDetailParams["email"] = "oscartestt@gmail.com"
        customerDetailParams["phone"] = "8888888888"
        customerDetailParams["name"] = "test"
        
        Alamofire.request(URL(string: "http://localhost:80/StripeBackend-master/createCustomer.php")!, method: .post, parameters: customerDetailParams, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.result.isSuccess {
                debugPrint(response.data!)
            }else{
                debugPrint(response.error)
                debugPrint(response.debugDescription)
            }
        }
    }
    
    
    class func createPaymentIntent(amount:Double,currency:String,customerId:String,completion:@escaping (Result<String>)->Void){
        //        createpaymentintent.php
        Alamofire.request(URL(string: "http://localhost:80/StripeBackend-master/createpaymentintent.php")!, method: .post, parameters: ["amount":amount,"currency":currency,"customerId":customerId], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.isSuccess {
                let data = response.data
                
                guard let json = ((try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : String]) as [String : String]??) else {
                    completion(.failure(response.error!))
                    return
                }
                completion(.success(json!["clientSecret"]!))
            }else{
                completion(.failure(response.result.error!))
            }
        }
    }
}

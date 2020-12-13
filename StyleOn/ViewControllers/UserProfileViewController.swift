import UIKit
import Firebase
import FirebaseAuth
import Foundation
import FirebaseStorage
import FirebaseDatabase
import CoreLocation
import Stripe

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var settingsEditMenu: UIView!
    @IBOutlet weak var settingsMenuButton: UIButton!
    
    @IBOutlet weak var userFirstName: UILabel!
    @IBOutlet weak var userLastName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userAddress: UILabel!
    
    @IBOutlet weak var proMenuView: UIView!
    @IBOutlet var pro_switch:UISwitch!
    
    var customerContext : STPCustomerContext?
    var paymentContext : STPPaymentContext?
    var isSetShipping = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let config = STPPaymentConfiguration.shared
        config.shippingType = .shipping
        config.requiredShippingAddressFields = Set<STPContactField>(arrayLiteral: STPContactField.name,STPContactField.emailAddress,STPContactField.phoneNumber,STPContactField.postalAddress)
        config.companyName = "Style On"
        customerContext = STPCustomerContext(keyProvider: MyPaymentAPIClient())
        paymentContext =  STPPaymentContext(customerContext: customerContext!, configuration: config, theme: .default())
        self.paymentContext?.delegate = self
        self.paymentContext?.hostViewController = self
        self.paymentContext?.paymentAmount = 5000
    
//        get uth info from bd
        let uid = Auth.auth().currentUser!.uid
        print(uid)
    
        print("I'm in UserProfileViewController")
        userFirstName.text = "this is a test"
        print(Auth.auth().currentUser!.uid)
        let userRef = Firestore.firestore().collection("users")
        userRef.whereField("uid", isEqualTo: Auth.auth().currentUser!.uid).getDocuments{ (snapshot, error) in
            if let err = error {
                debugPrint("error fetching documents")
                debugPrint(err)
            }
            else{
                guard let snap = snapshot else{return}
                for document in snap.documents {
                    let data = document.data()
                    self.userFirstName.text = data["firstname"] as? String ?? ""
                    self.userLastName.text = data["lastname"] as? String ?? ""
                    self.userEmail.text = data["email"] as? String ?? ""
                    self.userAddress.text = data["address"] as? String ?? ""
                }
                print(snapshot?.documents)
            }
        }
        
        
        
        
    }
    
    
    @IBAction func clickedBtnCreateCustomer(_ sender: Any) {
        MyPaymentAPIClient.createCustomer()
    }
    
    @IBAction func clickedPaymentMethods(_ sender: Any) {
        self.paymentContext?.presentPaymentOptionsViewController()
    }
    
    
    @IBAction func settingsMenuButtonPressed(_ sender: Any) {
        
        if (settingsEditMenu.isHidden == true){
            settingsEditMenu.isHidden = false
        }
        else{
            settingsEditMenu.isHidden = true
        }
        
    }
    
    
  

    
    @IBAction func pro_switch_action(_ sender: UISwitch){
        if sender.isOn {
            
            if (proMenuView.isHidden == true){
                proMenuView.isHidden = false
            }
            
            
            
//            view.backgroundColor = .red
            print("switch is on")
            print("user id is ")
            print(Auth.auth().currentUser!.uid)
            
            
            
//            Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).setData(["Pro":"True"])
            Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).updateData(["pro":"True"])
//            
//            var user = Auth.auth().currentUser.;
//            print(user)
//            
            
//            let docRef = Firestore.firestore().collection("users").whereField("uid", isEqualTo: Auth.auth().currentUser?.uid ?? "")
//            docRef.setValue(<#T##value: Any?##Any?#>, forKey: String)
            //            docRef.setValue(["pro": "yes?"])
            
//            TODO get id
//            let docRef = Firestore.firestore().collection("usersBusiness").whereField("uid", isEqualTo: Auth.auth().currentUser?.uid ?? "")
//            TODO set pro:yes
            
        }
        else{
            print("switch is off")
//            view.backgroundColor = .blue
//            TODO set pro :no
            print(Auth.auth().currentUser!.uid)
//            Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).setData(["Pro":"False"])
            Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).updateData(["pro":"False"])
        
            if (proMenuView.isHidden == false){
                proMenuView.isHidden = true
            }
            
        
        }
    }
    
    
}
extension UserProfileViewController: STPPaymentContextDelegate {
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
       
        if paymentContext.selectedPaymentOption != nil && isSetShipping{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                paymentContext.presentShippingViewController()
            }
        }
        
        if paymentContext.selectedShippingMethod != nil && !isSetShipping {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
             self.paymentContext?.requestPayment()
            }
        }
    }
    
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        
        MyPaymentAPIClient.createPaymentIntent(amount: (Double(paymentContext.paymentAmount+Int((paymentContext.selectedShippingMethod?.amount)!))), currency: "usd", customerId: "") { (response) in
            switch response {
            case .success(let clientSecret):
                // Assemble the PaymentIntent parameters
                let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
                paymentIntentParams.paymentMethodId = paymentResult.paymentMethod?.stripeId
                paymentIntentParams.paymentMethodParams = paymentResult.paymentMethodParams
                
                STPPaymentHandler.shared().confirmPayment(withParams: paymentIntentParams, authenticationContext: paymentContext) { status, paymentIntent, error in
                    switch status {
                    case .succeeded:
                        // Your backend asynchronously fulfills the customer's order, e.g. via webhook
                        completion(.success, nil)
                    case .failed:
                        completion(.error, error) // Report error
                    case .canceled:
                        completion(.userCancellation, nil) // Customer cancelled
                    @unknown default:
                        completion(.error, nil)
                    }
                }
            case .failure(let error):
                completion(.error, error) // Report error from your API
                break
            }
        }
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        
    }
}

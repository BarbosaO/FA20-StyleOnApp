import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class StylerProfileViewController: UIViewController {
    
    @IBOutlet weak var stylerProfileImage: UIImageView!
    @IBOutlet weak var addService: UIButton!
    @IBOutlet weak var serviceAdded1: UIButton!
    @IBOutlet weak var serviceAdded2: UIButton!
    @IBOutlet weak var serviceAdded3: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var profileSettings: UIView!
    @IBOutlet weak var lastname: UILabel!
    @IBOutlet weak var firstname: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Styling profile page UI
        stylerProfilePhoto()
        addServiceButtonStyle()
        updateUserInfo()
        
    }
    
    
    func updateUserInfo(){
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
                    self.firstname.text = data["firstname"] as? String ?? "firstname"
                    self.lastname.text = data["lastname"] as? String ?? "lastname"
                }
                print(snapshot?.documents)
            }
        }
    }
    
    
    @IBAction func profileButtonPressed(_ sender: Any){
        if (profileSettings.isHidden == true){
            profileSettings.isHidden = false
        }
        else{
            profileSettings.isHidden = true
        }
    }
    
    
    
    // This sets the design of the Styler photo profile
    func stylerProfilePhoto(){
        stylerProfileImage.layer.cornerRadius = stylerProfileImage.frame.width/2
        stylerProfileImage.layer.masksToBounds = true
    }
    
    // This sets the design for the Styer add service button
    func addServiceButtonStyle() {
        addService.layer.cornerRadius = addService.frame.width/2
        addService.layer.masksToBounds = true
        addService.clipsToBounds = true
        
        serviceAdded1.layer.cornerRadius = addService.frame.width/2
        serviceAdded1.layer.masksToBounds = true
        serviceAdded1.clipsToBounds = true
        
        serviceAdded2.layer.cornerRadius = addService.frame.width/2
        serviceAdded2.layer.masksToBounds = true
        serviceAdded2.clipsToBounds = true
//
//        serviceAdded3.layer.cornerRadius = addService.frame.width/2
//        serviceAdded3.layer.masksToBounds = true
//        serviceAdded3.clipsToBounds = true
        
    }
    
}

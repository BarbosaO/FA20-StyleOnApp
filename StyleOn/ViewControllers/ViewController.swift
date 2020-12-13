import UIKit
import AVKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet var LogoImage: UIImageView!
    @IBOutlet var RoundedButton: UIButton!
    @IBOutlet var RoundedButton1: UIButton!
    @IBOutlet var ProRoundedButton: UIButton!
    @IBOutlet var ProRegisterRoundedButton: UIButton!
    
    
    var videoPlayer: AVPlayer?
    var videoPlayerLayer: AVPlayerLayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        self.RoundedButton.layer.cornerRadius = 20.0
        self.RoundedButton.layer.borderWidth = 1.0
        self.RoundedButton.layer.borderColor = UIColor.white.cgColor
        
        self.ProRoundedButton.layer.cornerRadius = 20.0
        self.ProRoundedButton.layer.borderWidth = 1.0
        self.ProRoundedButton.layer.borderColor = UIColor.white.cgColor
        
        self.ProRegisterRoundedButton.layer.cornerRadius = 20.0 
        self.ProRegisterRoundedButton.layer.borderWidth = 1.0
        self.ProRegisterRoundedButton.layer.borderColor = UIColor.white.cgColor
        
        self.RoundedButton1.layer.cornerRadius = 20.0
        self.RoundedButton1.layer.borderWidth = 1.0
        self.RoundedButton1.layer.borderColor = UIColor.white.cgColor
        
        
        
        
        
        
//         code below for gradient background
//        let topColor = UIColor(red: 201/255, green: 0/255, blue: 0/255, alpha: 1)
//        let bottomColor = UIColor(red: 243/255, green: 0/255, blue: 0/255, alpha: 1)
//
//        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
//        let gradientLocations: [Float] = [0.0, 0.5]
//        let gradientLayer: CAGradientLayer = CAGradientLayer()
//
//        gradientLayer.colors = gradientColors
//        gradientLayer.locations = gradientLocations as [NSNumber]?
//
//        gradientLayer.frame = self.view.bounds
//        self.view.layer.insertSublayer(gradientLayer, at: 0)
//
    }

    override func viewWillAppear(_ animated: Bool) {
        // set up video in background
        setUpVideo()
    }
    
    func setUpVideo(){
        
        // get Path to the resource in bundle
        let bundlePath = Bundle.main.path(forResource: "signInVideo", ofType: "mp4")
        // check if bundle video found
        guard bundlePath != nil else{
            return
        }
        
        // create url from bundle
        let url = URL(fileURLWithPath: bundlePath!)
        
        // create video player Item
        let item = AVPlayerItem(url: url)
        
        // create the player
        videoPlayer = AVPlayer(playerItem: item)
        
        // create the layer
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
        
        // adjust the size and frame
        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width*3, y: 0, width: self.view.frame.size.height*4, height: self.view.frame.height)
        
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        
        //add it to the view and play it
        videoPlayer?.playImmediately(atRate: 0.3)
        
        
        
    }
    
}


import UIKit
import Firebase
import FirebaseAuth
import Foundation

class UserSalonViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let db = Firestore.firestore()
    var category:String = "All"
    
    // This is the view to display all posts from all Authors
    @IBOutlet var allPostsTableView: UITableView!
    @IBOutlet weak var featuredPostsCollectionView: UICollectionView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var seachTextField: UITextField!
    @IBOutlet weak var filterSegment: UISegmentedControl!
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        let searchItem = seachTextField.text!
        searchObserve(search:searchItem)
    }
    @IBAction func categorySegmentChange(_ sender: Any) {
        self.category = filterSegment.titleForSegment(at: filterSegment.selectedSegmentIndex)!
        searchObserve(search:"")

    }
    
    var posts = [UserPosts]()
    let productCollectionViewId = "FeaturedPostsCollectionViewCell"
    
    var products = [FeaturedPosts]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: "UserPostViewCell", bundle: nil)
        allPostsTableView.register(cellNib, forCellReuseIdentifier: "postCell")
        
        allPostsTableView.delegate = self
        allPostsTableView.dataSource = self
        allPostsTableView.tableFooterView = UIView()
        
        observe()
        
        allPostsTableView.reloadData()
        
        // Register cell
        let nibCell = UINib(nibName: productCollectionViewId, bundle: nil)
        featuredPostsCollectionView.register(nibCell, forCellWithReuseIdentifier: productCollectionViewId)
        
        
//         init data
        for _ in 1...25 {
            let product = FeaturedPosts()
            product?.Name = ""
            product?.desc = ""
            products.append(product!)
        }
        
        featuredPostsCollectionView.reloadData()
        
    }
    
    
    func observe() {
        
        var tempPosts = [UserPosts]()
        
        // postsRef is just the url of the database: https://style-on-757e5.firebaseio.com/post
        self.db.collection("post").getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    // Save current iterating document as a local variable so that It's easier to work with
                    let DocumentFromDatabase = document.data()
                    
                    // Define data from the Post struct as local variables to create the post
                    //let postAuthor = DocumentFromDatabase["AuthorDisplayName"]!
                    let postAuthor = "Test Author"
                    let postTitle = DocumentFromDatabase["Title"]!
                    let postDescription = DocumentFromDatabase["Description"]!
                    let postUrl = URL(string: DocumentFromDatabase["PostUrl"]! as! String)
                    let postAddress = DocumentFromDatabase["Address"]!
                    let postCoordinates = DocumentFromDatabase["Coordinates"]!

                    // Create local post object
                    let post = UserPosts(author: postAuthor as! String, postTitle: postTitle as! String, postDescription: postDescription as! String, postUrl: postUrl!, postAddress:  postAddress as! String, coordinates: postCoordinates as! [String : Any])

                    // Now that the local post object is created, append to the list of Posts so that they get displayed in the cell view
                    tempPosts.append(post)
                }
                
                // Escape and refresh table data, Previous team wrote this section
                self.posts = tempPosts
                self.allPostsTableView.reloadData()
            }
        }
        
        // ---- MarcoTest --- Removing for now, it just adds 3 posts to the feed
        
        /*
         
        let url1 = URL(string: "https://www.botanicadayspa.com/wp-content/uploads/2018/01/shutterstock_348940706-3.jpg")
        let url2 = URL(string: "https://femeout.com/wp-content/uploads/2020/02/Female-Haircut-Models-According-To-Face-Shape-930x620.jpg")
        let url3 = URL(string: "https://www.drbishop.com/assets/Blog/57a3915863/Extensions__FillWzkwMCw1NDVd.jpg")
         tempPosts.append(UserPosts(author: "Marco Dambrosio", postTitle: "Eyelash extensions", postDescription: "Professionally done eyelash extensions which last a full month backed by our customer satisfaction guarantee", postUrl: url3!, postAddress: "441 Lewers St, Honolulu, Hi, 98615"))
        
         tempPosts.append(UserPosts(author: "Adam Kent", postTitle: "Haircut", postDescription: "Let one of our stylists give you the haircut you deserve", postUrl: url2!, postAddress: "644 Segovia St, Coral Gables, Fl, 33134"))
        
         tempPosts.append(UserPosts(author: "Jenny Hubert", postTitle: "Spa Day", postDescription: "Full spa day by one of our licensed therapists", postUrl: url1!, postAddress: "262 Henry Rd, Miami, Fl, 33130"))
         
        */
        
         // ----- End MarcoTest ---

         self.posts = tempPosts
         self.allPostsTableView.reloadData()
    }
    
    func searchObserve(search: String) {
        
        var tempPosts = [UserPosts]()
        
        var docRef:Query = self.db.collection("post")
        var searchByZipCode = false
        var strFrontCode: String
        var strEndCode: String
        
        if(search.count > 0){
            
            if(search.count == 5 && (Int(search)) != nil){
                searchByZipCode = true
            }
            
//            var strSearch = "start with text here";
            var strlength = search.count
            strFrontCode = ""//search[...3]
            strEndCode = ""//search.index(search.endIndex, offsetBy: 5)

//            var strEndCode = strSearch.slice(strlength-1, strSearch.length);
//
//            var startcode = strSearch;
//            var endcode = strFrontCode + String.fromCharCode(strEndCode.charCodeAt(0) + 1);
            
        }
        
        if(self.category == "All"){
            if(searchByZipCode){
                docRef = self.db.collection("post")
                    .whereField("Zipcode", isEqualTo: search)
            }else{
                docRef = self.db.collection("post")
            }
        }else{
            if(searchByZipCode){
                docRef = self.db.collection("post")
                    .whereField("Tag", isEqualTo: self.category)
                    .whereField("Zipcode", isEqualTo: search)
//            }else if(search.replacingOccurrences(of: " ", with: "").count > 0){
//                docRef = self.db.collection("post")
//                    .whereField("Tag", isEqualTo: category)
//                    .whereField("Title", isGreaterThanOrEqualTo: strFrontCode)
//                    .whereField("Title", isLessThanOrEqualTo: strEndCode)
            }else{
                docRef = self.db.collection("post")
                    .whereField("Tag", isEqualTo: self.category)
            }
        }
        
        
        docRef.getDocuments { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    // Save current iterating document as a local variable so that It's easier to work with
                    let DocumentFromDatabase = document.data()
                    
                    // Define data from the Post struct as local variables to create the post
                    //let postAuthor = DocumentFromDatabase["AuthorDisplayName"]!
                    let postAuthor = "Test Author"
                    let postTitle = DocumentFromDatabase["Title"]!
                    let postDescription = DocumentFromDatabase["Description"]!
                    let postUrl = URL(string: DocumentFromDatabase["PostUrl"]! as! String)
                    let postAddress = DocumentFromDatabase["Address"]!
                    let postCoordinates = DocumentFromDatabase["Coordinates"]!

                    // Create local post object
                    let post = UserPosts(author: postAuthor as! String, postTitle: postTitle as! String, postDescription: postDescription as! String, postUrl: postUrl!, postAddress:  postAddress as! String, coordinates: postCoordinates as! [String : Any])

                    // Now that the local post object is created, append to the list of Posts so that they get displayed in the cell view
                    tempPosts.append(post)
                }
                
                // Escape and refresh table data, Previous team wrote this section
                self.posts = tempPosts
                self.allPostsTableView.reloadData()
            }
        }
        
         self.posts = tempPosts
         self.allPostsTableView.reloadData()
    }
    
    
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! UserPostViewCell
        cell.set(userPost: posts[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

            return 250
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return products.count
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 310, height: 350)
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedPostsCollectionViewCell", for: indexPath) as! FeaturedPostsCollectionViewCell
        let product = products[indexPath.row]
        cell.featuredImage.image = UIImage(named: "3")
        cell.lbName.text = product.Name!
        cell.lbDesc.text = product.desc!
        
        return cell
    }
}

extension UserSalonViewController : UserPostViewCellDelegator {
    func didTapButton(myData dataobject: String) {
        print(dataobject)
        self.performSegue(withIdentifier: "showCalendar", sender:dataobject)
    }
}



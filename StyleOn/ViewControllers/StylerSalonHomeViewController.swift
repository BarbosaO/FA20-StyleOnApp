import UIKit
import Firebase
import FirebaseAuth
import Foundation

class StylerSalonHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    // Instantiate table view to post content
    var tableView:UITableView!
    
    // Access database from firestore
    let db = Firestore.firestore()

    var posts = [Post]()
    
    // Loads current view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        
        let cellNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "postCell")
        
        view.addSubview(tableView)
        
        var layoutGuide:UILayoutGuide
        
        if #available(iOS 11.0, *){
            layoutGuide = view.safeAreaLayoutGuide
        }
        
        layoutGuide = view.safeAreaLayoutGuide
        
        tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        observe{
            [weak self](tempPosts) in
            self!.posts = tempPosts
          }
        
        tableView.reloadData()

    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        cell.set(post: posts[indexPath.row])
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
             return 180
     }
    
    
    
    @IBAction func handleLogout(_ target: UIBarButtonItem) {
        try! Auth.auth().signOut()
        self.dismiss(animated: false, completion: nil)
    }

    func observe(finished: @escaping ([Post]) -> Void) {
            // postsRef is just the url of the database: https://style-on-757e5.firebaseio.com/post
        
            // Getting reference to db to refresh on post pushing
            let postsRef = self.db.collection("post").whereField("AuthorID", isEqualTo: String(Auth.auth().currentUser?.uid ?? ""))
            
            
            // To filter by stylist ID add .whereField("AuthorID", isEqualTo: StylistID )
            
            // Saving currently Logged-in stylist's ID:
            
            // Field AuthorID is not yet implemented
            // self.db.collection("post").whereField("AuthorID", isEqualTo: String(Auth.auth().currentUser?.uid ?? "")).getDocuments() { (querySnapshot, err) in
                postsRef.addSnapshotListener{ (querySnapshot, err) in
                var tempPosts = [Post]()
                
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        // Save current iterating document as a local variable so that It's easier to work with
                        let DocumentFromDatabase = document.data()
                        
                        // Define data from the Post struct as local variables to create the post
                        let postAuthor = DocumentFromDatabase["AuthorDisplayName"]!
                        let postTitle = DocumentFromDatabase["Title"]!
                        let postDescription = DocumentFromDatabase["Description"]!
                        let postUrl = URL(string: DocumentFromDatabase["PostUrl"]! as! String)
                        let postAddress = DocumentFromDatabase["Address"]!

                        // Create local post object
                        let post = Post(author: postAuthor as! String, postTitle: postTitle as! String, postDescription: postDescription as! String, postUrl: postUrl!, postAddress:  postAddress as! String)

                        // Now that the local post object is created, append to the list of Posts so that they get displayed in the cell view
                        tempPosts.append(post)
                    }
                    
                    // Escape and refresh table data, Previous team wrote this section
                    finished(tempPosts)
                    self.tableView.reloadData()
                }
            }
        }
        
        
}




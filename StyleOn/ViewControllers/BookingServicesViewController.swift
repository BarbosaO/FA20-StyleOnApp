import UIKit
import Firebase
import FirebaseAuth
import Foundation

class BookingServicesViewController: UIViewController, UITableViewDelegate {

    let db = Firestore.firestore()
    
    @IBOutlet weak var tableView: UITableView!
    
    var bookingServices : [BookingService] = []
    
    var posts = [BookingService]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "BookingServiceCell", bundle: nil), forCellReuseIdentifier: "BookingServiceReusableCell")
        
        observe()
    }
    
    func observe() {
        
        
        // postsRef is just the url of the database: https://style-on-757e5.firebaseio.com/post
        self.db.collection("bookings").addSnapshotListener() { (querySnapshot, err) in
            
            self.bookingServices = []
            
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for document in querySnapshot!.documents {
                    // Save current iterating document as a local variable so that It's easier to work with
                    let DocumentFromDatabase = document.data()
                    
                    // Define data from the Post struct as local variables to create the post
                    
                    let postUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/style-on-757e5.appspot.com/o/PO_Meeting_Test?alt=media&token=f65a8e23-26c7-4cf8-b83b-4bf135eae0b7")
                    let postAddress = DocumentFromDatabase["address"]!
                    let postDate = DocumentFromDatabase["date"]!
                    let postTime = DocumentFromDatabase["time"]!
                    
                    // Create local booking service object
                    let bookingServicePost = BookingService(date: postDate as! String, time: postTime as! String, address: postAddress as! String, postURL: postUrl!)

                    // Now that the local post object is created, append to the list of Posts so that they get displayed in the cell view
                    //print(bookingServicePost)
                    self.bookingServices.append(bookingServicePost)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            
            self.tableView.reloadData()
        }
    }
}

extension BookingServicesViewController : UITableViewDataSource{
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

            return 250
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookingServices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingServiceReusableCell", for: indexPath) as! BookingServiceCell
        cell.set(bookingServicePost: bookingServices[indexPath.row])
        //cell.dateHard.text = "Date: "
        //cell.timeHard.text = "Time: "
        //cell.date.text = bookingServices[indexPath.row].date
        //cell.time.text = bookingServices[indexPath.row].time
        //cell.address.text = bookingServices[indexPath.row].address
        return cell
    }
}

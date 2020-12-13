import Foundation

class UserPosts {
    var author:String // username
    var postTitle:String
    var postDescription:String
    var postUrl:URL
    var postAddress: String
    var coordinates: [String: Any]
    
    init(author:String, postTitle:String, postDescription:String, postUrl:URL, postAddress:String, coordinates: [String: Any]) {
        self.author = author
        self.postTitle = postTitle
        self.postDescription = postDescription
        self.postUrl = postUrl
        self.postAddress = postAddress
        self.coordinates = coordinates
    }
}

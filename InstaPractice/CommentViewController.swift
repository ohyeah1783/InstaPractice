import UIKit
import Firebase
import SVProgressHUD

class CommentViewController: UIViewController {
    
    @IBOutlet weak var commentTextField: UITextField!
    
    var postArray: [PostData] = []
    var row:Int = 0
    
    @IBAction func handleCommentPost(_ sender: Any) {
        if let comment = commentTextField.text {
            
            let postData = postArray[row]
            
            // コメントが入力されていない時はHUDを出して何もしない
            if comment.isEmpty {
                SVProgressHUD.showError(withStatus: "コメントを入力して下さい")
                return
            }
            
            if let displayName = Auth.auth().currentUser?.displayName {
                if postData.comments.count != 0 {
                    postData.comments["name"]!.append(displayName)
                    postData.comments["comment"]!.append(comment)
                } else {
                    postData.comments["name"] = [displayName]
                    postData.comments["comment"] = [comment]
                }
            }
            
            let postRef = Database.database().reference().child(Const.PostPath).child(postData.id!)
            let comments = ["comments": postData.comments]
            
            postRef.updateChildValues(comments)
            
            // HUDで完了を知らせる
            SVProgressHUD.showSuccess(withStatus: "コメントを投稿しました")
            dismiss(animated: true, completion: nil)
        }
        // キーボードを閉じる
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

}

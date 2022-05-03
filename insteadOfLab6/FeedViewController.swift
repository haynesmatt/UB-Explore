//
//  FeedViewController.swift
//  insteadOfLab6
//
//  Created by Amit Tzadok on 4/13/22.
//

import UIKit
import AlamofireImage
import Parse

class FeedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
        
//        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        layout.minimumLineSpacing = 4
//        layout.minimumInteritemSpacing = 4
//
//        let width = (view.frame.size.width - layout.minimumInteritemSpacing) / 2
//        layout.itemSize = CGSize(width: width, height: width * 3 / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! PostCell
        
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            let size: CGFloat = (cell.frame.size.width - space) / 2.0
            return CGSize(width: size, height: size)
        }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className:"Posts")
        query.includeKey("author")
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.collectionView.reloadData()
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! PostCell
        
        let post = posts[indexPath.row]
        
        cell.titleLabel.text = post["title"] as! String
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        let filter = AspectScaledToFillSizeFilter(size: cell.photoView.frame.size)
        
        cell.photoView.af_setImage(withURL: url, filter: filter)
        cell.photoView.layer.cornerRadius = 20
        
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        // find post
        if segue.identifier == "post" {
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)!
        let post = posts[indexPath.row]
        
        // pass post to postViewController
        let postViewController = segue.destination as! PostViewController
        postViewController.post = post
        }
    }
    
}

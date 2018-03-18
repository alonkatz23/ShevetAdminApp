//
//  ViewController.swift
//  Shevet Hamifratz Admin
//
//  Created by Alon Katz on 1/29/18.
//  Copyright © 2018 Shevet Hamifratz. All rights reserved.
//

import UIKit
import Firebase

class NewsletterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var newMessageButton: UIButton!
    
    @IBOutlet weak var articleTableView: UITableView!
    
    var articles: [Article] = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        articleTableView.delegate = self
        articleTableView.dataSource = self
        
        articleTableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "articleCell")
        
//        articleTableView.register(UINib(nibName: "CustomArticleCell", bundle: nil), forCellReuseIdentifier: "customArticleCell")
//
        
        let origImage = UIImage(named: "create_new");
        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        newMessageButton.setImage(tintedImage, for: .normal)
        newMessageButton.tintColor = UIColor.white
        
        fetchArticle()
        
        
        let date = (Int)(NSDate().timeIntervalSince1970)
        
        print("Date \(date)")
        
        Auth.auth().signIn(withEmail: "shevet@gmail.com", password: "qqqqqq", completion: { (user, error) in
            
            if error != nil {
                print(error!)
                return
            }
//            let ref = Database.database().reference().child("users").child("QPqO2ubVNxcLfNFZGU31IeBu1Rs2")
//
//            ref.observeSingleEvent(of: .value, with: { (snapshot) in
//                 if let dictionary = snapshot.value as? [String: AnyObject] {
//                    if let name = dictionary["name"]{
//                        print(name)
//                    }
//                }
//            })
           
        })
        
      
        
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell
        
        let article = articles[indexPath.row]
        cell.articleTitle.text = article.title
      //  cell.articleImage.image = UIImage(named: "Shevet Hamifratz")
        //cell.articleImage.backgroundColor = .blue

        if let articleImageUrl = article.articleImageUrl{
            let url = URL(string: articleImageUrl)
            
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                DispatchQueue.main.async {
                    cell.articleImage.image = UIImage(data: data!)
                }
                
                

            
            }.resume()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func fetchArticle(){
        Database.database().reference().child("articles").observe(.childAdded, with: { (snapshot) in
            print("fetched")
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let article = Article(dictionary: dictionary)
                //article.setValuesForKeys(dictionary)
                self.articles.append(article)
                
//                DispatchQueue.main.async {
//                    self.articleTableView.reloadData()
//                }
                print(self.articles.count)
                self.organizeChronologicalTableView()

            }
        
           // print(snapshot)
            
            
        }, withCancel: nil)
    }
    
    func organizeChronologicalTableView(){
        var unchanged = false
        print(articles.count)
        while(!unchanged && articles.count > 1){
            unchanged = true
            print("in here")
            for index in 1..<articles.count {
                if (articles[index-1].date! < articles[index].date!){
                    var temp = articles[index-1]
                    articles[index-1] = articles[index]
                    articles[index] = temp
                    unchanged = false
                }
            }
        }
        DispatchQueue.main.async {
            self.articleTableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func newMessagePressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "addMessageSegue", sender: self)
        
    }
    
    
}


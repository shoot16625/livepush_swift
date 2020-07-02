//
//  SecondViewController.swift
//  livepush
//
//  Created by shuto.uchida on 2020/07/01.
//  Copyright © 2020 shuto.uchida. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
        private var tableView = UITableView()
        fileprivate var tweets: [Tweet] = []
        var inputWord: String!
        var timer = Timer()

        override func viewDidLoad() {
            super.viewDidLoad()

            setUpTableView: do {
                tableView.frame = view.frame
                tableView.dataSource = self
                view.addSubview(tableView)
            }
            print(inputWord!)
            //timer処理
            timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true, block: { (timer) in
                HitApi.fetchArticle(keyword: self.inputWord,completion: { (pushInfo) in
                    self.tweets = pushInfo.Tweets
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                })
            })
        }
    }

    extension SecondViewController: UITableViewDataSource {

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            let tweet = tweets[indexPath.row]
            cell.textLabel?.text = tweet.user.name
            cell.detailTextLabel?.text = tweet.full_text
            return cell
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return tweets.count
        }
    }


    struct PushInfo: Codable {
        var Word: String
        var Push: Bool
        var Token: String
        var Tweets: [Tweet]
    }

    struct Tweet: Codable {
        let id: int_fast64_t
        let full_text: String
        let created_at: String
        let user: User
        struct User: Codable {
            let id: int_fast64_t
            let name: String
            let profile_image_url_https: String
        }
    }


    struct HitApi {

        static func fetchArticle(keyword:String, completion: @escaping (PushInfo) -> Swift.Void) {

            let urlString = "https://livepush.shijimi.work/"

            let request = NSMutableURLRequest(url: URL(string: urlString)!)

            request.httpMethod = "POST"
            request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

            let params:[String:Any] = [
                "Word": keyword
            ]

            do{
                request.httpBody = try JSONSerialization.data(withJSONObject: params)

                let task:URLSessionDataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data,response,error) in
                    guard let jsonData = data else {
                        return
                    }
                    do {
                        let pushInfo = try JSONDecoder().decode(PushInfo.self, from: jsonData)
                        print(pushInfo.Word, pushInfo.Tweets[0])
                        completion(pushInfo)
                    } catch {
                        print(error.localizedDescription)
                    }
                })
                task.resume()
            }catch{
                print("Error:\(error)")
                return
            }
        }
    }


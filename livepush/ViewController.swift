//
//  ViewController.swift
//  livepush
//
//  Created by shuto.uchida on 2020/07/01.
//  Copyright © 2020 shuto.uchida. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var inputWord: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        inputWord.attributedPlaceholder = NSAttributedString(string: "キーワードを入力")
    }
    // ①セグエ実行前処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSecondView" {
            // ③遷移先ViewCntrollerの取得
            let tweetView = segue.destination as! SecondViewController

            // ④値の設定
            tweetView.inputWord = self.inputWord.text!
            
            tweetView.resultHandler = { pushed in
                print("pushの状態：", pushed)
                if pushed == true {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "toPushView",sender: self)
                    }
                }
            }
        }
    }
}


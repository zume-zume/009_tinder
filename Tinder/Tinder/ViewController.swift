//
//  ViewController.swift
//  Tinder
//
//  Created by zume on 2023/02/26.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var basicCard: UIView!
    @IBOutlet weak var likeImageView: UIImageView!
    
    @IBOutlet weak var person1: UIView!
    @IBOutlet weak var person2: UIView!
    @IBOutlet weak var person3: UIView!
    @IBOutlet weak var person4: UIView!
    
    var centerOfCard: CGPoint!
    var people = [UIView]()
    var selectedCardCount: Int = 0
    
    let name = ["ほのか", "あかね", "みほ", "カルロス"]
    var likedName = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerOfCard = self.basicCard.center
        people.append(person1)
        people.append(person2)
        people.append(person3)
        people.append(person4)
    }

    private func resetCard() {
        self.basicCard.center = self.centerOfCard
        self.basicCard.transform = .identity
    }

    @IBAction func swipeCard(_ sender: UIPanGestureRecognizer) {
        // スワイプした時の情報をsenderから受け取り、senderのview(スワイプしたカード)を取得する
        let card = sender.view!
        // スワイプした位置情報（inのviewは親のViewなので、親のViewからどれぐらい動いたか）
        let point = sender.translation(in: view)
        // xyの座標を指定(カードの元々の座標に、動いた座標（point.x y）を足してあげる。)
        card.center = CGPoint(x: card.center.x + point.x, y: card.center.y + point.y)
        people[selectedCardCount].center = CGPoint(x:  card.center.x + point.x, y: card.center.y + point.y)
        
        // 角度を変える(0.785はラジアンの45度)
        let xFromCenter = card.center.x - view.center.x
        card.transform = CGAffineTransform(rotationAngle: xFromCenter / (view.frame.width / 2) * -0.785)
        people[selectedCardCount].transform = CGAffineTransform(rotationAngle: xFromCenter / (view.frame.width / 2) * -0.785)
        
        if xFromCenter > 0 {
            self.likeImageView.image = UIImage(named: "good")
            self.likeImageView.alpha = 1
            self.likeImageView.tintColor = UIColor.red
        } else if xFromCenter < 0 {
            self.likeImageView.image = UIImage(named: "bad")
            self.likeImageView.alpha = 1
            self.likeImageView.tintColor = UIColor.blue
        }
        
        if sender.state == UIGestureRecognizer.State.ended {
            // 左に大きくスワイプ
            if card.center.x < 75 {
                UIView.animate(withDuration: 0.2, animations: {
                    // 左から75ptより小さかったら、250ptまで飛ばす
                    self.resetCard()
                    self.people[self.selectedCardCount].center = CGPoint(x: self.people[self.selectedCardCount].center.x - 250, y: self.people[self.selectedCardCount].center.y)
                })
                self.likeImageView.alpha = 0
                self.selectedCardCount += 1
                if selectedCardCount >= people.count {
                    print(likedName)
                }
                return
            } else if card.center.x > self.view.frame.width - 75 {
                UIView.animate(withDuration: 0.2, animations: {
                    // 右から75ptより小さかったら、250ptまで呼ばす
                    self.resetCard()
                    self.people[self.selectedCardCount].center = CGPoint(x: self.people[self.selectedCardCount].center.x + 250, y: self.people[self.selectedCardCount].center.y)
                })
                self.likeImageView.alpha = 0
                likedName.append(name[selectedCardCount])
                self.selectedCardCount += 1
                if selectedCardCount >= people.count {
                    print(likedName)
                }
                return
            }
            
            // 元に戻る処理
            UIView.animate(withDuration: 0.2, animations: {
                self.resetCard()
                self.people[self.selectedCardCount].center = self.centerOfCard
                self.people[self.selectedCardCount].transform = .identity
            })
            self.likeImageView.alpha = 0
        }
    }
    
}


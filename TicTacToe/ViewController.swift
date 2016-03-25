//
//  ViewController.swift
//  TicTacToe
//
//  Created by admin on 3/4/16.
//  Copyright © 2016 Barak. All rights reserved.


import UIKit

class ViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource{
    var arrayEmoji = [String]()
    var arrLocation = [Int]()
    var dicBoardCards = [Int:String]()
    var counter = 1
    var lastIndexPath = NSIndexPath()
    var lastCell = CollectionViewCell()
    var canPlay = true
    var playedAlready = false
    var score = 0
    var timerCount = 0
    var timerRunning = false
    var timer = NSTimer()
    var mCollectionView:UICollectionView!
    var correct = 0
    var firstRun = true
    
    @IBOutlet weak var btnStartOver: UIButton!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelScore: UILabel!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var labelDone: UILabel!
    
    func scoringCalc () -> Int
    {
        var dicScoring = [20:200,40:150,60:100,80:50,100:20,120:10]
        var temp = 20
        if(timerCount < 20)
        {
            temp = 20
        }
        else if(timerCount < 40)
        {
            temp = 40
        }
        else if(timerCount < 60)
        {
            temp = 60
        }
        else if(timerCount < 80)
        {
            temp = 80
        }
        else if(timerCount<100)
        {
            temp = 100
        }
        else if(timerCount<120)
        {
            temp = 120
        }
        return dicScoring[temp]!
    }
    func counting (){
        if(timerRunning && correct != 8)
        {
            timerCount+=1
            labelTime.text = "Timer: \(timerCount)"
        }
    }
    @IBAction func onlickStartOver(sender: UIButton) {
        timerCount = 0
        score = 0
        labelTime.text = "Timer: 0"
        labelScore.text = "Score: 0"
        timerRunning = false
        initBoard()
        if(playedAlready)
        {
            startOver(mCollectionView)
        }
        btnStartOver.hidden=true
        btnStart.hidden=false
    }
    @IBAction func onClickStart(sender: AnyObject) {
        if(!timerRunning)
        {
          //  timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("counting"), userInfo: nil, repeats: true)
            timerRunning = true
            btnStart.hidden=true
            btnStop.hidden=false
        }
        
    }
    @IBAction func onClickStop(sender: AnyObject) {
        
        if(timerRunning)
        {
            //timer.invalidate()
            timerRunning = false
            btnStop.hidden=true
            btnStart.hidden=false
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initBoardDic()
        initBoard()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellIdentifier", forIndexPath: indexPath)
            as! CollectionViewCell
        
        //  cell.cellLabel.text = "\(indexPath.row),\(indexPath.section)"
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.mCollectionView = collectionView
        if(timerRunning)
        {
            playedAlready = true
            let cell = collectionView.cellForItemAtIndexPath(indexPath)as! CollectionViewCell
            
            if(counter%2 == 1) // first press
            {
                if(canPlay)
                {
                    lastIndexPath = indexPath
                    lastCell = cell
                    cell.cellLabel.text = dicBoardCards[indexPath.row * 4 + indexPath.section]
                    
                    counter++
                }
                
            }
            else // second
            {
                if(indexPath != lastIndexPath)
                {
                    if(canPlay)
                    {
                        counter++
                        cell.cellLabel.text = dicBoardCards[indexPath.row * 4 + indexPath.section]
                        // flip the contentView while repositioning the actual cell view
                        //CollectionViewCell.transitionFromView(cell, toView: cell, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
                        
                        if(dicBoardCards[indexPath.row * 4 + indexPath.section] == dicBoardCards[lastIndexPath.row * 4 + lastIndexPath.section])
                        {
                            correct++
                            score += scoringCalc()
                            labelScore.text = "Score: \(score)"
                            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
                            dispatch_after(delayTime, dispatch_get_main_queue()) {
                                cell.hidden = true
                                self.lastCell.hidden = true
                                self.canPlay = true
                                if(self.correct == 8)
                                {
                                    self.labelDone.hidden = false //needs to wait until all the cards will fliped
                                    self.btnStop.hidden=true
                                    self.btnStartOver.hidden=false
                                }
                            }
                            
                        }
                        else
                        {
                            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
                            
                            dispatch_after(delayTime, dispatch_get_main_queue()) {
                                cell.cellLabel.text = "?"
                                self.lastCell.cellLabel.text = "?"
                                self.canPlay = true
                            }
                        }
                    }
                    canPlay = false
                    
                }
            }
        }
    }
    func initBoardDic()
    {
        for var index = 0; index < 16; ++index{
            arrLocation.append(index)
            
        }
        arrLocation.shuffleInPlace()
        
        for var index = 0; index < 8; ++index{
            arrayEmoji.append(String(UnicodeScalar(0x1f601+index)))
            arrayEmoji.append(String(UnicodeScalar(0x1f601+index)))
            print(arrayEmoji[index])
        }
    }
    func initBoard(){
        btnStart.hidden=false
        btnStartOver.hidden=true
        btnStop.hidden=true
        labelDone.hidden = true
        correct = 0
        arrayEmoji.shuffleInPlace()
        
        for var index = 0; index < 16; ++index{
            dicBoardCards[arrLocation[index]] = arrayEmoji[index]
        }
        if(firstRun){
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("counting"), userInfo: nil, repeats: true)
            firstRun=false
        }
        
        
    }
    func startOver(collectionView: UICollectionView){
        for var index = 0; index < 16; ++index{
            let indexPath = NSIndexPath(forRow: index/4, inSection: index%4)
            let cell = collectionView.cellForItemAtIndexPath(indexPath)as! CollectionViewCell
            cell.cellLabel.text = "?"
            cell.hidden = false
            
        }
    }
    
}

extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}
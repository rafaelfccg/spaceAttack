//
//  GameViewController.swift
//  Space Attack
//
//  Created by Miguel Araújo on 8/25/16.
//  Copyright (c) 2016 Miguel Araújo. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(_ file: String) -> SKNode? {
        let path = Bundle.main.path(forResource: file, ofType: "sks")
        let sceneData: Data?
        
        do {
            sceneData = try Data(contentsOf: URL(fileURLWithPath: path!), options: .dataReadingMapped)
        } catch _ {
            sceneData = nil
        }
        
        let archiver = NSKeyedUnarchiver(forReadingWith: sceneData!)
        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
        let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! GameScene
        archiver.finishDecoding()
        return scene
    }
}

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene.init(size: self.view.frame.size)
        let skView = self.view as! SKView
//        skView.showsPhysics = true;
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        
    }

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    
    func clearScene(){
        let skView = self.view as? SKView
        if skView?.scene != nil {
            skView?.scene?.removeAllActions()
            skView?.scene?.removeAllChildren()
            skView?.presentScene(nil)
        }
    }
}

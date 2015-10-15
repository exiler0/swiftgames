//
//  GameViewController.swift
//  SuperSpaceMan3D
//
//  Created by Andrew Phommathep on 10/12/15.
//  Copyright (c) 2015 Apress. All rights reserved.
//


import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        // Create the scene
        let mainScene = createMainScene()
        mainScene.rootNode.addChildNode( createFloorNode() )

        // Get the games main view
        let sceneView = self.view as! SCNView
        sceneView.scene = mainScene
    
        // Optional, but nice to be turned on during developement
        sceneView.showsStatistics = true
        sceneView.allowsCameraControl = true
    }
    
    func createMainScene() -> SCNScene {
        
        var mainScene = SCNScene(named: "art.scnassets/hero.dae")
        
        return mainScene!
    }
    
    
    func createFloorNode() -> SCNNode {
        
        let floorNode = SCNNode()
        let floor =  SCNFloor()
            
        floorNode.geometry = floor
        floorNode.geometry?.firstMaterial?.diffuse.contents = "Floor"
        return floorNode
    }
}

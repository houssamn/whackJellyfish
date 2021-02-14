//
//  ViewController.swift
//  WhackJellyfish
//
//  Created by Houssam on 2/14/21.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBAction func play(_ sender: Any) {
        self.addNode()
    }
    
    @IBAction func reset(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configuration = ARWorldTrackingConfiguration()
        
        self.sceneView.debugOptions = [SCNDebugOptions.showWorldOrigin, SCNDebugOptions.showFeaturePoints]
        self.sceneView.session.run(configuration)
        // Do any additional setup after loading the view.
    
    
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }

    func addNode() {
        let node = SCNNode(geometry: SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0))
        
        node.position = SCNVector3(0,0,-1)
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        self.sceneView.scene.rootNode.addChildNode(node)

    }
    
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let sceneViewTappedOn = sender.view as! SCNView
        let touchCoordinates = sender.location(in: sceneViewTappedOn)
        let hitTest = sceneViewTappedOn.hitTest(touchCoordinates)
        
        if hitTest.isEmpty {
            print("nothing")
        }else{
            print("Hit something")
            let result = hitTest.first!
            let geom = result.node.geometry
            print(geom)
            
        }
                
    }

}


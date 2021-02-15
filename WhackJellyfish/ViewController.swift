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
        self.playButton.isEnabled = false
    }
    
    @IBOutlet weak var playButton: UIButton!
    @IBAction func reset(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configuration = ARWorldTrackingConfiguration()
        
        self.sceneView.debugOptions = [SCNDebugOptions.showFeaturePoints]
        self.sceneView.session.run(configuration)
        // Do any additional setup after loading the view.
    
    
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }

    func addNode() {
//        let node = SCNNode(geometry: SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0))
//
//        node.position = SCNVector3(0,0,-1)
//        node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
//        self.sceneView.scene.rootNode.addChildNode(node)
        let jellyfishScene = SCNScene(named: "art.scnassets/Jellyfish.scn")
        let jellyfish = jellyfishScene?.rootNode.childNode(withName: "Sphere", recursively: false)
        
        jellyfish?.position = SCNVector3(randomNumber(lower: -1,upper: 1), randomNumber(lower: -0.5,upper: 0.5), -1)
        self.sceneView.scene.rootNode.addChildNode(jellyfish!)
        
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
            // let geom = result.node.geometry
            let node  = result.node
            if node.animationKeys.isEmpty{
                SCNTransaction.begin()
                self.animateNode(node: node)
                SCNTransaction.completionBlock = {
                    node.removeFromParentNode()
                    self.addNode()
                }
                SCNTransaction.commit()
            }
            
        }
                
    }
    
    func animateNode(node: SCNNode) {
        let spin = CABasicAnimation(keyPath: "position")
        spin.fromValue = node.presentation.position
        spin.toValue = SCNVector3(0,0,node.presentation.position.z - 1)
        spin.autoreverses = true
        spin.duration = 0.07
        spin.repeatCount = 5
        node.addAnimation(spin, forKey: "position")
    }

}

func randomNumber(lower: CGFloat, upper: CGFloat) -> CGFloat {
    return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(upper-lower) + lower
}


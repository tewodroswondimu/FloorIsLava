//
//  ViewController.swift
//  FloorIsLava
//
//  Created by Tewodros Wondimu on 10/30/17.
//  Copyright © 2017 Tewodros Wondimu. All rights reserved.
//

import UIKit
import ARKit

// To detect whenever a horizontal surface is detected
class ViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.delegate = self;
        self.sceneView.session.run(configuration)
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        
        // turn on plane detection in the horiztonal
        self.configuration.planeDetection = .horizontal
        
        // create a new plane with a lava texture
        //let lavaNode = createLava()
        //lavaNode.eulerAngles = SCNVector3(Float(90.degreesToRadians), 0,0)
        // self.sceneView.scene.rootNode.addChildNode(lavaNode)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Creates a 1x1 plane with a texture of lava and returns it
    func createLava(plane: ARPlaneAnchor) -> SCNNode {
        // the height and width can be found from the plane
        let lavaNode = SCNNode(geometry: SCNPlane(width: CGFloat(plane.extent.x), height: CGFloat(plane.extent.z)))
        lavaNode.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "lava")
        lavaNode.geometry?.firstMaterial?.isDoubleSided = true
        lavaNode.position = SCNVector3(plane.center.x, plane.center.y, plane.center.z)
        lavaNode.eulerAngles = SCNVector3(Float(90.degreesToRadians), 0,0)
        return lavaNode
    }
    
    // checks if ar anchor was added to the scene view
    // the anchor gets the size, orientation and location of an anchor
    // if plane anchor, size orientation and position of a horizontal plane surface
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // to check if the added anchor is a plane
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        
        // we can use the plane that is detected to make the laza is exactly the same size and position
        let lavaNode = createLava(plane: planeAnchor)
        
        // add the lava node to the node that has been detected
        node.addChildNode(lavaNode)
        
        print("new flat surface detected, new ARPlaneAnchor added")
    }
    
    // We want to know whenever an plan anchor is updated
    // As the devices discovers new planes it adds it to the ARPlaneAnchor
    // The device is not perfect it could add a surface that is not
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        
        // add the new updated node
        node.enumerateChildNodes { (childNode, _) in
            childNode.removeFromParentNode()
        }
        
        let lavaNode = createLava(plane: planeAnchor)
        node.addChildNode(lavaNode)
        
        print("updating the floor anchor");
    }
    
    // When the device detects that an ARPlaneAnchor has been added to the wrong anchor
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard let _ = anchor as? ARPlaneAnchor else {return}

        // add the new updated node
        node.enumerateChildNodes { (childNode, _) in
            childNode.removeFromParentNode()
        }
    }
    
}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180 }
}

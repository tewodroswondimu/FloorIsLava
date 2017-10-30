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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // checks if ar anchor was added to the scene view
    // the anchor gets the size, orientation and location of an anchor
    // if plane anchor, size orientation and position of a horizontal plane surface
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // to check if the added anchor is a plane
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        
        print("new flat surface detected, new ARPlaneAnchor added")
    }
    
    // We want to know whenever an plan anchor is updated
    // As the devices discovers new planes it adds it to the ARPlaneAnchor
    // The device is not perfect it could add a surface that is not
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        
        print("updating the floor anchor");
    }
    
    // When the device detects that an ARPlaneAnchor has been added to the wrong anchor
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        
    }
    
}


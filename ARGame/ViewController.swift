//
//  ViewController.swift
//  ARGame
//
//  Created by Aya Essam on 19/10/2021.
//

import UIKit
import RealityKit

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    var object: Entity!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rect1 = CGRect(x: 50, y: 50, width: 100, height: 50)
        let rect2 = CGRect(x: 250, y: 50, width: 100, height: 50)

        let playButton = UIButton(frame: rect1)
        playButton.setTitle("Play", for: .normal)
        playButton.addTarget(self, action: #selector(play), for: .touchUpInside)
        playButton.backgroundColor = .blue
        
        let resetButton = UIButton(frame: rect2)
        resetButton.setTitle("Reset", for: .normal)
        resetButton.addTarget(self, action: #selector(reset), for: .touchUpInside)
        resetButton.backgroundColor = .blue

        self.view.addSubview(playButton)
        self.view.addSubview(resetButton)
    }
    
    func startGame() {
        let anchor = AnchorEntity(plane: .horizontal, classification: .any, minimumBounds: [0.4, 0.4])
        arView.scene.addAnchor(anchor)
        
        let box = MeshResource.generateBox(width: 0.04, height: 0.04, depth: 0.04, cornerRadius: 4)
        let material = SimpleMaterial.init(color: .blue, isMetallic: true)
        let model = ModelEntity(mesh: box, materials: [material])
        model.generateCollisionShapes(recursive: false)
        self.object = model
        
        let x = Float.random(in: 0..<0.4)
        let z = Float.random(in: 0..<0.2)
        object.position = [x, 0, z]
        anchor.addChild(object)
    }
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: arView)
        if let object = arView.entity(at: tapLocation){
            object.isEnabled = false
            let alert = UIAlertController(title: "Found it!", message: "You've earned one point", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when){
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func play(sender: UIButton!) {
        self.startGame()
    }
    
    @objc func reset(sender: UIButton!) {
        object.isEnabled = false
    }

}

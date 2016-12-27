//
//  ViewController.swift
//  Colores
//
//  Created by Eugenio Barquín on 27/12/16.
//  Copyright © 2016 Eugenio Barquín. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var btnSwitch: UIButton!
    @IBOutlet weak var imgKnobBase: UIImageView!
    @IBOutlet weak var imgKnob: UIImageView!
    
    private var deltaAngle: CGFloat?
    private var startTransform: CGAffineTransform?
    
    //el punto de arriba
    private var setPointAngle = M_PI_2
    
    //establecemos límites tomando como referencia un ángulo de 30 grados
    private var maxAngle = 7 * M_PI / 6
    private var minAngle = 0 - (M_PI / 6)
    
       override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgKnob.isHidden = true
        imgKnobBase.isHidden = true
        imgKnob.isUserInteractionEnabled = true
       
    }
    override func viewWillAppear(_ animated: Bool) {
        btnSwitch.setImage(#imageLiteral(resourceName: "img_switch_off"), for: .normal)
        btnSwitch.setImage(#imageLiteral(resourceName: "img_switch_on"), for: .selected)
    }
    
    @IBAction func btnSwitchPressed(_ sender: UIButton) {
        btnSwitch.isSelected = !btnSwitch.isSelected
        if btnSwitch.isSelected {
            imgKnob.isHidden = false
            imgKnobBase.isHidden = false
            resetKnob()
        } else {
            view.backgroundColor = UIColor(hue: 0.5, saturation: 0, brightness: 0.2, alpha: 1.0)
            imgKnob.isHidden = true
            imgKnobBase.isHidden = true
        }
    }
    
    func resetKnob() {
        view.backgroundColor = UIColor(hue: 0.5, saturation: 0.5, brightness: 0.75, alpha: 1.0)
        //le decimos al knob que vuelva a su lugar de origen
        imgKnob.transform = CGAffineTransform.identity
        setPointAngle = M_PI_2
    }
    
    private func touchISInKnobWithDistance(distance: CGFloat) -> Bool {
        //si la distancia es mayor que el radio, estamos fuera y si es menor estamos tocando el boton
        if distance > (imgKnob.bounds.height / 2) {
            return false
        }
        return true
    }
    
    // esto es el teorema de pitágoras
    private func calculateDistanceFromCenter(_ point:CGPoint) -> CGFloat {
        let center = CGPoint(x: imgKnob.bounds.size.width / 2.0, y: imgKnob.bounds.size.height / 2.0)
        let dx = point.x - center.x
        let dy = point.y - center.y
        return sqrt((dx * dx) + (dy * dy))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches .first {
            let delta = touch.location(in: imgKnob)
            let dist = calculateDistanceFromCenter(delta)
            if touchISInKnobWithDistance(distance: dist) {
                startTransform = imgKnob.transform
                let center = CGPoint(x: imgKnob.bounds.size.width / 2, y: imgKnob.bounds.size.height / 2.0)
                let deltaX = delta.x - center.x
                let deltaY = delta.y - center.y
                deltaAngle = atan2(deltaY, deltaX)
            }
        }
        super.touchesBegan(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.view == imgKnob {
                deltaAngle = nil
                startTransform = nil
            }
        }
        super.touchesEnded(touches, with: event)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first,
            let deltaAngle = deltaAngle,
            let startTransform = startTransform,
            touch.view == imgKnob {
            let position = touch.location(in: imgKnob)
            let dist = calculateDistanceFromCenter(position)
            if touchISInKnobWithDistance(distance: dist) {
                //vamos a calcular el ángulo según arrastramos
                let center = CGPoint(x: imgKnob.bounds.size.width / 2, y: imgKnob.bounds.size.height / 2)
                let deltaX = position.x - center.x
                let deltaY = position.y - center.y
                let angle = atan2(deltaY, deltaX)
                
                //y calculamos la distancia con el anterior
                let angleDif = deltaAngle - angle
                let newTransform = startTransform.rotated(by: -angleDif) //para la imagen
                let lastSetPointAngle = setPointAngle
                
                //comprobamos que no nos hemos pasado de los límites mímino y máximo
                //Al anterior le sumamos lo que nos hemos movido
                setPointAngle = setPointAngle + Double(angleDif)
                if setPointAngle >= minAngle && setPointAngle <= maxAngle {
                    //si está dentro de los márgenes , cambiamos el color y le aplicamos la transformada
                    view.backgroundColor = UIColor(hue: colorValueFromAngle(angle: setPointAngle), saturation: 0.75, brightness: 0.75, alpha: 1.0)
                    imgKnob.transform = newTransform
                    self.startTransform = newTransform
                } else {
                    //si se pasa lo dejamos en el límite
                    setPointAngle = lastSetPointAngle
                }
            }
            
        }
        super.touchesMoved(touches, with: event)
    }
    private func colorValueFromAngle(angle: Double) -> CGFloat {
        let hueValue = (angle - minAngle) * (360 / maxAngle - minAngle)
        return CGFloat(hueValue / 360)
        
    }
  
}


//
//  PhotoViewController.swift
//  Everpobre
//
//  Created by Fernando Rodríguez Romero on 9/13/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit
import CoreImage

class PhotoViewController: UIViewController {
    
    let model : Note
    
    
    
    @IBOutlet weak var photoView: UIImageView!
    
    
    //MARK: - Actions
    @IBAction func applyFilter(_ sender: AnyObject) {
     

        
        // CIImage, Context, CIFilter
        
        // Imagen de entrada
        let img = CIImage(image: photoView.image!)
        
        // Contexto: el que crea la imagen final
        let ctxt = CIContext(options: nil)
    
        // Filtro (usado por el contexto)
        let vintage = CIFilter(name: "CIFalseColor")
        vintage?.setDefaults()
        vintage?.setValue(img, forKey: "inputImage")
        
        // La imagen final
        let finalImg = vintage?.value(forKey: kCIOutputImageKey) as! CIImage
        
        // Aquí es donde se aplica el filtro y lo que consume tiempo
        let res = ctxt.createCGImage(finalImg, from: finalImg.extent)
        
        
        
        let result = UIImage(cgImage: res!)
        
        
        photoView.image = result
        
        
        
    }
    @IBAction func deletePhoto(_ sender: AnyObject) {
        
        
        
        let oldBounds = self.photoView.bounds
        
        // Animación
        UIView.animate(withDuration: 0.9,
                       animations: {
                        self.photoView.alpha = 0
                        self.photoView.bounds = CGRect(x: 0, y: 0, width: 0, height: 0)
                        self.photoView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_4))
                        
        }) { (finished: Bool) in
            // Dejar todo como estaba
            self.photoView.bounds = oldBounds
            self.photoView.transform = CGAffineTransform(rotationAngle: CGFloat(0))
            self.photoView.alpha = 1
            
            // Actualizamos
            self.model.photo?.image = nil
            self.syncModelView()
        }
        
        
        
        
    }
    @IBAction func takePhoto(_ sender: AnyObject) {
        
        // Crear una instancia de UIImagePicker
        let picker = UIImagePickerController()
        
        // Configurarlo
        if UIImagePickerController.isCameraDeviceAvailable(.rear){
            picker.sourceType = .camera
        }else{
            // me conformo con el carrete
            picker.sourceType = .photoLibrary
        }
        
        
        picker.delegate = self
        
        // Mostrarlo de forma modal
        self.present(picker, animated: true) { 
            // Por si quieres hacer algo nada más
            // mostrarse el picker
        }
    }
    
    
    init(model: Note){
        
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        syncModelView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        syncViewModel()
    }
    
    
    func syncModelView(){
        title = model.text
        photoView.image = model.photo?.image
    }
    
    func syncViewModel(){
        model.photo?.image = photoView.image
    }

}


//MARK: - Delegates
extension PhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        // Redimensionarla al tamaño de la pantalla
        // deberes (está en el online)
        model.photo?.image = info[UIImagePickerControllerOriginalImage] as! UIImage?
        
        // Quitamos de enmedio al picker
        self.dismiss(animated: true) { 
            //
        }
    }
}

























//
//  MLTextViewController.swift
//  AI_MUNJANG
//
//  Created by murba chovski on 2022/10/14.
//

import UIKit
import MobileCoreServices
import AVFoundation
import Photos
import MLKitTextRecognitionKorean
import MLKitVision


protocol MLTextDelegate: AnyObject {
    func mlTextDelegate(res:String)
}

class MLTextViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    let imagePicker: UIImagePickerController! = UIImagePickerController()
    
    var delegate:MLTextDelegate?
    var selectedImage:UIImage?
    
    var resultText = ""
    
    
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var btnAlbumn: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    
    
    @IBOutlet weak var textImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        btnCamera.backgroundColor = hexStringToUIColor(hex: "#f7f9fb")
        btnCamera.layer.cornerRadius = btnCamera.frame.size.height / 2
        btnCamera.layer.masksToBounds = false
        
        btnAlbumn.backgroundColor = hexStringToUIColor(hex: "#f7f9fb")
        btnAlbumn.layer.cornerRadius = btnAlbumn.frame.size.height / 2
        btnAlbumn.layer.masksToBounds = false
        
        btnConfirm.layer.cornerRadius = 10
        btnConfirm.layer.masksToBounds = false
        
    }
    
    //MARK
    //사용자가 카메라 버튼 클릭시 호출
    @IBAction func clickedCameraButton(_ sender: Any) {
        checkCameraPermission()
    }
    
    
    //사용자가 앨범버튼 클릭시
    @IBAction func clickedAlbumButton(_ sender: Any) {
        checkAlbumPermission()
      
    }
    
    //사용작 선택한 이미지를 확인하고 확인버튼 클릭시
    @IBAction func clickedConfirm(_ sender: Any) {
        useMLForImageToText()
            dismiss(animated: true) {
                self.delegate?.mlTextDelegate(res: self.resultText)
        }
    }
    
    @IBAction func clickedClose(_ sender: Any) {
        dismiss(animated: true)
    }
    
    //MARK: - 카메라,앨범 사용권한 질의
    //카메라 사용권한에 대한 질의
    func checkCameraPermission(){
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: // The user has previously granted access to the camera.
                print("Camera: 권한 허용")
                DispatchQueue.main.async {
                    self.showCamera()
                }
            
            case .notDetermined: // The user has not yet been asked for camera access.
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        print("Camera: 권한 허용")
                        DispatchQueue.main.async {
                            self.showCamera()
                        }
                    }
                }
            
            case .denied: // The user has previously denied access.
                print("Camera: 권한 거부")
                DispatchQueue.main.async {
                    
                    let alert = AlertService().alert(title: "알림", body: "카메라 사용에 대한 접근권한이 없는 상태입니다.\n 설정페이지로 이동하시겠습니까?", cancelTitle: "아니오", confirTitle: "예") {
                        self.dismiss(animated: true)
                    } fourthButtonCompletion: {
                        self.openSettings()
                    }
                    self.present(alert, animated: true)
                    
                }
                return

            case .restricted: // The user can't grant access due to restrictions.
                return
        @unknown default:
            return
        }
}
    
    //앨범에 대한 접근권한여부 질의
    func checkAlbumPermission(){
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization( { status in
                switch status{
                    case .authorized:
                        print("Album: 권한 허용")
                        DispatchQueue.main.async {
                            self.showPohotoAlbumn()
                        }
                    default:
                        break
                }
            })
        }else {
            PHPhotoLibrary.requestAuthorization( { status in
                switch status{
                    case .authorized:
                        print("Album: 권한 허용")
                        DispatchQueue.main.async {
                            self.showPohotoAlbumn()
                        }
                        
                    case .denied:
                        print("Album: 권한 거부")
                        DispatchQueue.main.async {
                            let alert = AlertService().alert(title: "알림", body: "사진 앨범에 대한 접근권한이 없는 상태입니다.\n 설정페이지로 이동하시겠습니까?", cancelTitle: "아니오", confirTitle: "예") {
                                self.dismiss(animated: true)
                            } fourthButtonCompletion: {
                                self.openSettings()
                            }
                            self.present(alert, animated: true)
                        }
                    default:
                        break
                }
            })
        }
}
    
    

    
    
   
    

    
    //MARK: - PickerController Delegate
    //사용작 카메라/앨범에서 선택한 사진을 이미지뷰에 로딩
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        var finalImage:UIImage?

        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            finalImage = image
        }else {
            finalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }

       
        self.textImageView.image = finalImage
        self.selectedImage = finalImage

        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)

    }

    //MARK: - 카메라,앨범 띄우기
    //카메라를 띄워 이미지 촬영
    fileprivate func showCamera() {
        
        // 만일 카메라를 사용할 수 있다면
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            
            imagePicker.delegate = self // 이미지 피커의 델리케이트를 self로 설정
            imagePicker.sourceType = .camera // 이미지 피커의 소스 타입을 Camera로 설정
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = true
            
            // 뷰 컨트롤러를 imagePicker로 대체
            present(imagePicker, animated: true, completion: nil)
        } else {
        }
    }
    
  
    
    //사용자가 사진앨범에서 사진을 선택할 수 있도록
    fileprivate func showPohotoAlbumn() {
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary // 이미지 피커의 소스 타입을 PotoLibrary로 설정
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = true // 편집을 허용
            
            present(imagePicker, animated: true, completion: nil)
        } else {
        }
    }

    //MARK: - 설정창으로 이동
    //설정창으로 이동
    func openSettings() {
        if let url = URL.init(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    //MARK: - 이미지내의 텍스트를 추출하기
    func useMLForImageToText() {
     
        let koreanOptions = KoreanTextRecognizerOptions()
        let koreanTextRecognizer = TextRecognizer.textRecognizer(options: koreanOptions)
        guard let selectedImage = selectedImage else {
            return
        }
        let image = VisionImage(image: selectedImage)
        image.orientation = imageOrientation(deviceOrientation: UIDevice.current.orientation, cameraPostion: .back)
        
        koreanTextRecognizer.process(image) { result, error in
            guard error==nil, let result = result else{
                //Eorror handling
                print("Error")
                return
            }
            self.resultText = result.text
            print("resultTEXT: \(self.resultText)")
        }
        // Do any additional setup after loading the view.
    }

    func imageOrientation(deviceOrientation:UIDeviceOrientation, cameraPostion:AVCaptureDevice.Position)->UIImage.Orientation{
        switch deviceOrientation {
        case .portrait:
            return cameraPostion == .front ? .leftMirrored : .right
        case .landscapeLeft:
            return cameraPostion == .front ? .downMirrored : .up
        case .portraitUpsideDown:
            return cameraPostion == .front ? .rightMirrored : .left
        case .landscapeRight:
            return cameraPostion == .front ? .upMirrored : .down
        case .faceDown, .faceUp, .unknown:
            return .up
        @unknown default:
            return .up
        }
    }
}

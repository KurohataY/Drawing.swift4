//
//  ViewController.swift
//  Drawing
//
//
//

import UIKit


class ViewController: UIViewController {
    
    //ベジエ曲線の利用
    var bezier:UIBezierPath!
    //画像の変数
    var Image:UIImage!
    //空の変数
    var undoStack: NSMutableArray!
    
    //サインする場所
    @IBOutlet  var canvas: UIImageView!
    
    
    //クリアボタンの動作
    @IBAction func clear_button(_ sender: Any) {
        clear()
    }
    //saveボタン
    @IBAction func save_button(_ sender: Any) {
        saveImage(image: Image)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        clear()
        canvas = UIImageView()
        canvas.frame = CGRect(x:105,y:295,width:835,height:330)
        canvas.backgroundColor = UIColor.clear
        self.view.addSubview(canvas)
    }
    
    override func viewWillAppear(_: Bool) {
        undoStack = NSMutableArray()
        
    }
    
    //タッチイベント
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchEvent = touches.first!
        let currentPoint:CGPoint = touchEvent.location(in: self.canvas)
        bezier = UIBezierPath()
        bezier.lineWidth = 10.0
        bezier.lineCapStyle = .butt
        bezier.move(to:currentPoint)
    }
    
    //ドラックイベント
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if bezier == nil {
            return
        }
        let touchEvent = touches.first!
        let currentPoint:CGPoint = touchEvent.location(in: self.canvas)
        bezier.addLine(to: currentPoint)
        drawLine(path: bezier)
    }
    
    //指を離した時のイベント
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if bezier == nil {
            return
        }
        let touchEvent = touches.first!
        let currentPoint:CGPoint = touchEvent.location(in: canvas)
        bezier.addLine(to: currentPoint)
        drawLine(path: bezier)
        self.Image = canvas.image
    }
    
    //描画処理
    func drawLine(path:UIBezierPath){
        UIGraphicsBeginImageContext(canvas.frame.size)
        if let image = self.Image {
            image.draw(at: CGPoint.zero)
        }
        let lineColor = UIColor.black
        lineColor.setStroke()
        path.stroke()
        self.canvas.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    //サインのクリア
    func clear(){
        Image = nil
        canvas.image = nil
    }
    
    func getDocumentsURL() -> NSURL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
        return documentsURL
    }
    // ディレクトリのパスにファイル名をつなげてファイルのフルパスを作る
    func fileInDocumentsDirectory(filename: String) -> String {
        let fileURL = getDocumentsURL().appendingPathComponent(filename)
        return fileURL!.path
    }
    
    //画像を写真ライブラリに追加（端末内）
    func saveImage (image: UIImage) {
    UIImageWriteToSavedPhotosAlbum(image,self,#selector(self.didFinishSavingImage(_:didFinishSavingWithError:contextInfo:)),nil)
    }
    
    // 保存を試みた結果を受け取る
    @objc func didFinishSavingImage(_ image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer) {
        
        // 結果によって出すアラートを変更する
        var title = "保存完了"
        var message = "カメラロールに保存しました"
        
        if error != nil {
            title = "エラー"
            message = "保存に失敗しました"
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        }
}

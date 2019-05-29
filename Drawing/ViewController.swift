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
    
    func saveImage (image: UIImage, path: String ) -> Bool{
        let jpgImageData = image.jpegData(compressionQuality:0.5)
        do {
            try jpgImageData!.write(to: URL(fileURLWithPath: path), options: .atomic)
        } catch {
            print(error)
            return false
        }
        return true
    }
}






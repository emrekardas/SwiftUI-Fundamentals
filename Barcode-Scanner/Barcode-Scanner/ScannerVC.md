---

### **1. Kütüphanelerin İçe Aktarılması**

```swift
import Foundation
import AVFoundation
import UIKit
```

- **Foundation**: Temel veri tipleri ve fonksiyonları sağlar.
- **AVFoundation**: Ses ve video işleme için kullanılır, burada kamera erişimi ve barkod tarama işlemleri için gereklidir.
- **UIKit**: iOS uygulamalarının kullanıcı arayüzünü oluşturmak için kullanılır.

---

### **2. Protokol Tanımı**

```swift
protocol ScannerVCDelegate: AnyObject {
    func didFind(barcode: String)
}
```

- **ScannerVCDelegate** adında bir protokol tanımlanmış.
- **didFind(barcode: String)** fonksiyonu, taranan barkod değerini iletmek için kullanılır.
- **AnyObject**: Bu protokolün sadece sınıflar tarafından benimsenebileceğini belirtir (referans tipleri).

---

### **3. ScannerVC Sınıfının Tanımlanması**

```swift
final class ScannerVC: UIViewController {
    // ...
}
```

- **ScannerVC**, `UIViewController` sınıfından türetilmiş bir sınıftır.
- **final** anahtar kelimesi, bu sınıfın başka sınıflar tarafından miras alınmasını engeller.

---

### **4. Değişkenlerin Tanımlanması**

```swift
let captureSession = AVCaptureSession()
var previewLayer: AVCaptureVideoPreviewLayer?
weak var scannerDelegate: ScannerVCDelegate!
```

- **captureSession**: Video yakalama oturumu oluşturur.
- **previewLayer**: Kamera görüntüsünü ekranda göstermek için kullanılır.
- **scannerDelegate**: `ScannerVCDelegate` protokolünü benimseyen ve taranan barkod bilgisini iletecek olan delegate. **weak** olarak tanımlanması, güçlü referans döngülerini önler.

---

### **5. Başlatıcı (Initializer) Metotlar**

```swift
init(scannerDelegate: ScannerVCDelegate){
    super.init(nibName: nil, bundle: nil)
    self.scannerDelegate = scannerDelegate
}

required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
```

- **init(scannerDelegate:)**: Sınıfın başlatıcısı, bir `scannerDelegate` alır ve bunu sınıf içindeki değişkene atar.
- **required init?(coder:)**: Storyboard kullanmadığımız için bu başlatıcıyı kullanmıyoruz ve bir hata mesajı ile uygulama sonlandırılıyor.

---

### **6. Kamera ve Yakalama Oturumunun Kurulumu**

```swift
private func setupCaptureSession(){
    // ...
}
```

#### **6.1. Oturum Ön Ayarının Yapılması**

```swift
captureSession.sessionPreset = .photo
```

- Yakalama oturumunun kalitesi **.photo** olarak ayarlanır, bu da yüksek çözünürlüklü fotoğraf yakalamayı belirtir.

#### **6.2. Video Girişinin Eklenmesi**

```swift
guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
let videoInput: AVCaptureDeviceInput
do {
    try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
    captureSession.addInput(videoInput)
} catch {
    return print("Error creating video input: \(error.localizedDescription)")
}

if captureSession.canAddInput(videoInput){
    captureSession.addInput(videoInput)
} else{
    return print("Error adding video input")
}
```

- **videoCaptureDevice**: Cihazın varsayılan video girişini (arka kamera) alır.
- **AVCaptureDeviceInput**: Video giriş cihazını yakalama oturumuna eklemek için kullanılır.
- Hata kontrolü ile giriş cihazının oluşturulup oluşturulamadığı doğrulanır.
- **captureSession.addInput(videoInput)**: Giriş cihazı yakalama oturumuna eklenir.

#### **6.3. Metadata Çıkışının Eklenmesi**

```swift
let metaDataOutput = AVCaptureMetadataOutput()

if captureSession.canAddOutput(metaDataOutput){
    captureSession.addOutput(metaDataOutput)
    metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
    metaDataOutput.metadataObjectTypes = [.ean8,.ean13,.qr]
}else{
    return print("Error adding metadata output")
}
```

- **metaDataOutput**: Barkod ve QR kodları tespit etmek için kullanılır.
- **setMetadataObjectsDelegate**: Tespit edilen metadata nesnelerini işlemek için delegasyon kurulur, burada `self` kullanılır ve ana kuyruk belirtilir.
- **metadataObjectTypes**: Tespit edilecek barkod türleri belirtilir (EAN8, EAN13 ve QR kodları).

#### **6.4. Önizleme Katmanının Ayarlanması ve Oturumun Başlatılması**

```swift
previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
previewLayer!.videoGravity = .resizeAspectFill
view.layer.addSublayer(previewLayer!)

captureSession.startRunning()
```

- **previewLayer**: Kamera akışını kullanıcıya göstermek için oluşturulur.
- **videoGravity**: Video içeriğinin nasıl ölçekleneceğini belirtir.
- **view.layer.addSublayer(previewLayer!)**: Önizleme katmanı ana görünüme eklenir.
- **captureSession.startRunning()**: Yakalama oturumu başlatılır.

---

### **7. AVCaptureMetadataOutputObjectsDelegate Protokolünün Uygulanması**

```swift
extension ScannerVC : AVCaptureMetadataOutputObjectsDelegate {
    // ...
}
```

- **ScannerVC**, barkod ve QR kodu tespitlerini işlemek için bu protokolü benimser.

#### **7.1. metadataOutput Fonksiyonunun Tanımlanması**

```swift
func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
    guard let metadataObject = metadataObjects.first else { return }
    guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
    guard let barcode = readableObject.stringValue else { return }
    
    scannerDelegate?.didFind(barcode: barcode)
}
```

- **metadataObjects**: Tespit edilen metadata nesnelerinin bir dizisidir.
- **metadataObjects.first**: İlk tespit edilen nesne alınır.
- **AVMetadataMachineReadableCodeObject**: Barkod veya QR kodu gibi okunabilir kodları temsil eder.
- **stringValue**: Tespit edilen kodun string değerini alır.
- **scannerDelegate?.didFind(barcode: barcode)**: Tespit edilen barkod değeri delegate'e iletilir.

---

### **8. Eksik veya Dikkat Edilmesi Gereken Noktalar**

- **viewDidLoad()** veya **viewWillAppear()** metodları tanımlanmamış. Bu metodlardan birinde **setupCaptureSession()** fonksiyonunun çağrılması gerekir.

    ```swift
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
    }
    ```

- **previewLayer**'ın çerçevesi ayarlanmamış. **viewDidLayoutSubviews()** içinde ayarlanmalıdır:

    ```swift
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.bounds
    }
    ```

- **Otorizasyon Kontrolleri**: Kamera erişimi için kullanıcıdan izin isteme işlemi yapılmamış. Uygulama çalışırken kullanıcıya kamera izni sormak ve izin durumunu kontrol etmek gerekir.

- **Hata Yönetimi**: Hatalar sadece konsola yazdırılıyor. Kullanıcıya uygun bir mesaj gösterilmesi daha iyi bir kullanıcı deneyimi sağlar.

---

### **9. Genel İşleyiş**

- **Amaç**: Bu sınıf, kamera aracılığıyla barkod ve QR kodu taraması yapar ve tespit edilen kodu delegate aracılığıyla iletir.

- **Kullanım Senaryosu**:
    - **ScannerVC** oluşturulur ve bir delegate atanır.
    - Kamera oturumu başlatılır ve canlı önizleme gösterilir.
    - Bir barkod veya QR kodu tespit edildiğinde, **didFind(barcode:)** metodu çağrılır ve tespit edilen kod değeri iletilir.

- **Delegate Pattern**: Kodun tasarımı, **Delegate Tasarım Deseni**ni kullanır. Bu sayede, tarayıcı sınıfı ile diğer bileşenler arasında gevşek bir bağlılık sağlanır.

---

**Sonuç Olarak**, bu kod parçası, bir barkod ve QR kodu tarayıcı oluşturmak için temel bileşenleri içeriyor. Kamera erişimi, önizleme katmanı ve metadata tespiti gibi önemli adımlar uygulanmış. Ancak, eksik olan bazı kısımlar (örneğin, kullanıcıdan kamera izni isteme ve arayüz güncellemeleri) uygulamaya eklenmelidir.


@preconcurrency import AVFoundation

/// Owns one capture session. Configuring and starting block, so they run on this actor, off the main thread;
/// the preview layer only reads `session`, which is why it is exposed nonisolated.
actor CameraSession {
    nonisolated let session = AVCaptureSession()

    /// Connects the default video camera and starts the session. Returns false when there is no camera.
    func start() -> Bool {
        if session.isRunning {
            return true
        }
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else {
            return false
        }
        session.beginConfiguration()
        session.inputs.forEach(session.removeInput)
        if session.canAddInput(input) {
            session.addInput(input)
        }
        session.commitConfiguration()
        session.startRunning()
        return session.isRunning
    }

    func stop() {
        session.stopRunning()
    }
}

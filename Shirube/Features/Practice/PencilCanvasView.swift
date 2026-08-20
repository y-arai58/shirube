import PencilKit
import Observation
import SwiftUI

@Observable
final class CanvasController {
    weak var canvasView: PKCanvasView?
    private(set) var revision = 0

    var canUndo: Bool { _ = revision; return canvasView?.undoManager?.canUndo == true }
    var canRedo: Bool { _ = revision; return canvasView?.undoManager?.canRedo == true }

    func undo() { canvasView?.undoManager?.undo(); revision += 1 }
    func redo() { canvasView?.undoManager?.redo(); revision += 1 }
    func clear() { canvasView?.drawing = PKDrawing(); revision += 1 }

    func drawingDidChange() { revision += 1 }
}

struct PencilCanvasView: UIViewRepresentable {
    @Binding var drawing: PKDrawing
    let controller: CanvasController
    var isFingerDrawingEnabled: Bool = false

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIView(context: Context) -> PKCanvasView {
        let canvas = PKCanvasView()
        canvas.backgroundColor = .clear
        canvas.isOpaque = false
        canvas.drawing = drawing
        canvas.delegate = context.coordinator
        canvas.tool = PKInkingTool(.pen, color: .label, width: 4)
        #if targetEnvironment(simulator)
        canvas.drawingPolicy = .anyInput
        #else
        canvas.drawingPolicy = isFingerDrawingEnabled ? .anyInput : .pencilOnly
        #endif
        context.coordinator.lastDrawingData = drawing.dataRepresentation()
        controller.canvasView = canvas
        return canvas
    }

    func updateUIView(_ canvas: PKCanvasView, context: Context) {
        let incomingData = drawing.dataRepresentation()
        if incomingData != context.coordinator.lastDrawingData {
            canvas.drawing = drawing
            context.coordinator.lastDrawingData = incomingData
        }
    }

    static func dismantleUIView(_ uiView: PKCanvasView, coordinator: Coordinator) {
        uiView.delegate = nil
    }

    final class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: PencilCanvasView
        var lastDrawingData = Data()

        init(_ parent: PencilCanvasView) {
            self.parent = parent
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            lastDrawingData = canvasView.drawing.dataRepresentation()
            parent.drawing = canvasView.drawing
            parent.controller.drawingDidChange()
        }
    }
}

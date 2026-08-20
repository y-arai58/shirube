import Foundation
import PencilKit

extension PKDrawing {
    var persistenceData: Data {
        dataRepresentation()
    }

    init(persistenceData: Data) throws {
        try self.init(data: persistenceData)
    }
}

import Foundation
import SwiftData

@Observable
final class ProjectsViewModel {
    func deleteProject(_ project: Project, modelContext: ModelContext) {
        modelContext.delete(project)
        try? modelContext.save()
    }

    func deleteProjects(at offsets: IndexSet, from projects: [Project], modelContext: ModelContext) {
        for index in offsets {
            modelContext.delete(projects[index])
        }
        try? modelContext.save()
    }
}

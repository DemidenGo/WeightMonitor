//
//  MeasurementStore.swift
//  Weight Monitor
//
//  Created by Юрий Демиденко on 10.05.2023.
//

import Foundation
import CoreData

final class MeasurementsStore: NSObject {

    weak var delegate: MeasurementsStoreDelegate?
    private let context: NSManagedObjectContext

    private lazy var fetchedResultsController: NSFetchedResultsController<MeasurementCoreData> = {
        let fetchRequest = MeasurementCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        controller.delegate = self
        try? controller.performFetch()
        return controller
    }()

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    override convenience init() {
        self.init(context: appDelegate.persistentContainer.viewContext)
    }

    private func tryFetchExistingCoreDataEntity(for measurement: MeasurementViewModel) -> MeasurementCoreData? {
        let request = NSFetchRequest<MeasurementCoreData>(entityName: "MeasurementCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(MeasurementCoreData.date), measurement.date as CVarArg)
        if let measurementCoreData = try? context.fetch(request).first {
            return measurementCoreData
        }
        return nil
    }

    private func save(coreDataEntity: MeasurementCoreData, with measurement: MeasurementViewModel) throws {
        let weight = measurement.weight.floatFromString
        let roundedWeight = round(weight * 10) / 10
        coreDataEntity.weight = roundedWeight
        coreDataEntity.date = measurement.date
        try context.save()
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension MeasurementsStore: NSFetchedResultsControllerDelegate {

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateMeasurements()
    }
}

// MARK: - CategoryStoreProtocol

extension MeasurementsStore: MeasurementsStoreProtocol {

    var measurements: [MeasurementCoreData] {
        fetchedResultsController.fetchedObjects ?? []
    }

    func save(_ measurement: MeasurementViewModel) throws {
        if let measurementCoreData = tryFetchExistingCoreDataEntity(for: measurement) {
            try save(coreDataEntity: measurementCoreData, with: measurement)
            return
        }
        let measurementCoreData = MeasurementCoreData(context: context)
        try save(coreDataEntity: measurementCoreData, with: measurement)
    }

    func deleteFromStore(at indexPath: IndexPath) throws {
        let measurementCoreData = fetchedResultsController.object(at: indexPath)
        context.delete(measurementCoreData)
        try context.save()
    }
}

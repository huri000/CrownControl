//
//  ContactManager.swift
//  CrownControlDemo
//
//  Created by Daniel Huri on 11/14/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import Foundation
import Contacts
import UIKit

class ContactManager {
    
    // MARK: - Types
    
    typealias AccessRequestCompletionHandler = (AccessState) -> Void
    typealias LoadCompletionHandler = () -> Void

    enum AccessState {
        case granted
        case denied
        case unknown
        
        var isGranted: Bool {
            return self == .granted
        }
    }
    
    // MARK: - Properties
    
    var accessState: AccessState {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .denied, .restricted:
            return .denied
        case .authorized:
            return .granted
        case .notDetermined:
            return .unknown
        }
    }
    
    private(set) var firstLetters: [Character] = []
    private(set) var contactByFirstLetter: [Character: [Contact]] = [:]
        
    // MARK: - Request Access
    
    func requestAccess(completionHandler: @escaping AccessRequestCompletionHandler) {
        switch accessState {
        case .unknown:
            CNContactStore().requestAccess(for: .contacts) { granted, error in
                DispatchQueue.main.async {
                    completionHandler(error == nil && granted ? .granted : .denied)
                }
            }
        case .granted:
            DispatchQueue.main.async {
                completionHandler(.granted)
            }
        case .denied:
            DispatchQueue.main.async {
                completionHandler(.denied)
            }
        }
    }
    
    // MARK: - Load
    
    func loadContacts(completionHandler: @escaping LoadCompletionHandler) {
        DispatchQueue.global().async {
            do {
                let contactStore = CNContactStore()
                let accessKeys = [CNContactGivenNameKey, CNContactMiddleNameKey, CNContactFamilyNameKey]
                let allContainers = try contactStore.containers(matching: nil)
                var contacts: [Contact] = []
                allContainers.forEach { container in
                    let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                    let containerContacts = try? contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: accessKeys as [CNKeyDescriptor])
                    if let containerContacts = containerContacts {
                        contacts += containerContacts.compactMap {
                            guard let contact = Contact(identifier: $0.identifier, givenName: $0.givenName, familyName: $0.familyName) else {
                                return nil
                            }
                            self.add(contact: contact)
                            return contact
                        }
                    }
                }
                self.firstLetters.sort()
                for key in self.contactByFirstLetter.keys {
                    self.contactByFirstLetter[key]!.sort()
                }
            } catch let error as NSError {
                print(error)
            }
            DispatchQueue.main.async {
                completionHandler()
            }
        }
    }
    
    private func add(contact: Contact) {
        let firstLetter = contact.firstLetter
        if contactByFirstLetter[firstLetter] != nil {
           contactByFirstLetter[firstLetter]!.append(contact)
        } else {
            contactByFirstLetter[firstLetter] = [contact]
            firstLetters.append(firstLetter)
        }
    }
    
    // MARK: - Getters
    
    func contact(by firstLetter: Character, and index: Int) -> Contact {
        return contactByFirstLetter[firstLetter]![index]
    }
    
    func thumb(by contactId: String) -> UIImage? {
        let contact = try? CNContactStore().unifiedContact(withIdentifier: contactId, keysToFetch: [CNContactThumbnailImageDataKey as CNKeyDescriptor])
        if let data = contact?.thumbnailImageData {
            return UIImage(data: data)
        } else {
            return nil
        }
    }
    
    func numberOfContacts(with firstLetter: Character) -> Int {
        return contactByFirstLetter[firstLetter]!.count
    }
}

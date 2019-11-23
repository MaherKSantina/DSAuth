//
//  OrganizationFirstDegreeRelation.swift
//  App
//
//  Created by Maher Santina on 8/3/19.
//

import Foundation

public protocol OrganizationFirstDegreeRelationByKeyPath {
    static var organizationIDKeyPath: KeyPath<Self, OrganizationRow.ID> { get }
}

public protocol OrganizationOptionalFirstDegreeRelationByKeyPath {
    static var organizationIDKeyPath: KeyPath<Self, OrganizationRow.ID?> { get }
}

public protocol OrganizationFirstDegreeRelationByKey {
    static var organizationIDKey: String { get }
}

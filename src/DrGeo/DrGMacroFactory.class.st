"
DrGMacroFactory is a unique factory to hold macro construction definition.

Class Instance Variables:
	uniqueInstance	is the unique macro factory instance
"
Class {
	#name : #DrGMacroFactory,
	#superclass : #DrGFactory,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'DrGeo-Factories'
}

{ #category : #'instance creation' }
DrGMacroFactory class >> new [
	^ uniqueInstance ifNil: [uniqueInstance := super new]
]

{ #category : #'as yet unclassified' }
DrGMacroFactory class >> purge [
	"self purge"
	self new purge
]

{ #category : #accessing }
DrGMacroFactory >> addUnique: aMacro [
	^ (self findInPool: aMacro) 
		ifNil: [self add: aMacro].
]

{ #category : #accessing }
DrGMacroFactory >> titles [
	^ self pool collect: [:m | m title]
]

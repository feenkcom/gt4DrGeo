Class {
	#name : #DGMathItemUpdated,
	#superclass : #Announcement,
	#instVars : [
		'mathItem'
	],
	#category : #'Gt4DrGeo-Announcements'
}

{ #category : #'instance creation' }
DGMathItemUpdated class >> for: aMathItem [
	^ self new
		mathItem: aMathItem;
		yourself
]

{ #category : #accessing }
DGMathItemUpdated >> mathItem [
	^ mathItem
]

{ #category : #accessing }
DGMathItemUpdated >> mathItem: anObject [
	mathItem := anObject
]

"
A tool to edit the style of the costume.
"
Class {
	#name : #DrGStyleTool,
	#superclass : #DrGTool,
	#category : #'DrGeo-Presenter-Tool'
}

{ #category : #documentation }
DrGStyleTool class >> description [ 
	^ 'Edit an object style.' translated
]

{ #category : #documentation }
DrGStyleTool class >> title [
	^ 'Edit Style' translated
]

{ #category : #accessing }
DrGStyleTool >> description [ 
	^ self class description
]

{ #category : #'initialize-release' }
DrGStyleTool >> initialize [
	super initialize.
	self reset.
]

{ #category : #testing }
DrGStyleTool >> isBuilding [
	^ false
]

{ #category : #accessing }
DrGStyleTool >> morphStyle [
	^ self morph style
]

{ #category : #private }
DrGStyleTool >> myMorphsNear: aPoint [
"return the list of morph at position aPoint"
	^self drawable itemViews select: [:aMorph |
		(self isWanted: aMorph mathItem)			and: [aMorph containsPoint: aPoint]]
]

{ #category : #accessing }
DrGStyleTool >> presenter: aPresenter [
	super presenter: aPresenter.
	self drawable forcedVisibility: true.
]

{ #category : #'initialize-release' }
DrGStyleTool >> release [
	self drawable forcedVisibility: false.
	self presenter controlsManager stylerFor: nil.
	DrGeoSystem showVirtualKeyboard: false.
	super release.
]

{ #category : #accessing }
DrGStyleTool >> relevantMorphsNear: aPoint [
	^self pointMorphsFirstNear: aPoint 
]

{ #category : #updating }
DrGStyleTool >> reset [
	super reset.
	presenter controlsManager stylerFor: nil.
	self switchState: DrGStyleToolState.
]

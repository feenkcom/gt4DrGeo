Class {
	#name : #DrGSegmentStyle,
	#superclass : #DrGFinitCurveStyle,
	#instVars : [
		'mark'
	],
	#category : #'DrGeo-Model-Style'
}

{ #category : #'initialize-release' }
DrGSegmentStyle >> initialize [
	super initialize.
	self color: (DrGeoSystem preferences at: #segmentColor).
	self lineStyle: (DrGeoSystem preferences at: #segmentStyle).
	self thickness: (DrGeoSystem preferences at: #segmentThickness).
	self mark: (DrGeoSystem preferences at: #segmentMark).
	self arrow: (DrGeoSystem preferences at: #segmentArrow)
]

{ #category : #accessing }
DrGSegmentStyle >> mark [
	^ mark ifNil: [mark := #none]
]

{ #category : #accessing }
DrGSegmentStyle >> mark: aSymbol [
	mark := aSymbol.
	morph redrawNeeded
]

{ #category : #widget }
DrGSegmentStyle >> markIndex [
	mark ifNil: [mark := #none].
	^DrGTypeMark markIndexOf: mark
]

{ #category : #widget }
DrGSegmentStyle >> markIndex: index [
	self mark: (DrGTypeMark markFor: index).
	self changed: #markIndex:.
]

{ #category : #widget }
DrGSegmentStyle >> markMorphCollection [
	^ DrGTypeMark markMorphCollection
]

{ #category : #widget }
DrGSegmentStyle >> markWidget [
	^ self widget: (
		(DropDownButtonMorph 
			model: self
			listGetter: #markMorphCollection
			indexGetter: #markIndex
			indexSetter: #markIndex:)
			autoDeselect: false;
			yourself)
		named: 'Mark' translated 
		help: 'Set a mark to the segment.' translated
]

{ #category : #widget }
DrGSegmentStyle >> myWidgets [ 
	^ super myWidgets addAll: {self markWidget}; yourself
]

{ #category : #'xml writing' }
DrGSegmentStyle >> writeAttributesTo: aNode [
	super writeAttributesTo: aNode.
	aNode attributeAt: #mark put: self mark
]

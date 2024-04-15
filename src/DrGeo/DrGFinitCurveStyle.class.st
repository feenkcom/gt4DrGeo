Class {
	#name : #DrGFinitCurveStyle,
	#superclass : #DrGCurveStyle,
	#instVars : [
		'arrow'
	],
	#category : #'DrGeo-Model-Style'
}

{ #category : #accessing }
DrGFinitCurveStyle >> arrow [
	"Answer the value of arrows"

	^ arrow
]

{ #category : #accessing }
DrGFinitCurveStyle >> arrow: anObject [
	"Set the value of arrows"
	arrow := anObject.
	morph arrow: anObject;
		redrawNeeded 
]

{ #category : #widget }
DrGFinitCurveStyle >> arrowIndex [
	"Answer the index of arrows"

	^ DrGTypeArrow arrowIndexOf: arrow
]

{ #category : #widget }
DrGFinitCurveStyle >> arrowIndex: index [
	"Set the value of arrows"
	self arrow: (DrGTypeArrow arrowFor: index).
	self changed: #arrowIndex:
]

{ #category : #widget }
DrGFinitCurveStyle >> arrowMorphCollection [
	^ DrGTypeArrow arrowMorphCollection
]

{ #category : #widget }
DrGFinitCurveStyle >> arrowWidget [
	^ self widget: (
		(DropDownButtonMorph 
			model: self
			listGetter: #arrowMorphCollection  
			indexGetter: #arrowIndex 
			indexSetter: #arrowIndex:)
			autoDeselect: false;
			yourself)
		named: 'Arrow' translated 
		help: 'Set arrow(s) to the line.' translated
]

{ #category : #widget }
DrGFinitCurveStyle >> myWidgets [
	^ (morph isSegment or: [morph isArc]) 
		ifTrue: [super myWidgets addAll: {self arrowWidget}; yourself]
		ifFalse: [super myWidgets]
]

{ #category : #'xml writing' }
DrGFinitCurveStyle >> writeAttributesTo: aNode [
	super writeAttributesTo: aNode.
	morph isCircle ifFalse: [aNode attributeAt: #arrow put: self arrow.]
]

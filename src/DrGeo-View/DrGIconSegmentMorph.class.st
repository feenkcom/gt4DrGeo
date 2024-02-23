"
A morph to draw in an icon a line shape, depending on its style.
"
Class {
	#name : #DrGIconSegmentMorph,
	#superclass : #DrGSegmentMorph,
	#category : #'DrGeo-View'
}

{ #category : #accessing }
DrGIconSegmentMorph >> forcedMark: symbol [
	self style mark: symbol
]

{ #category : #accessing }
DrGIconSegmentMorph >> getVertices [
"No update of the vertices attributes, use its values as is"
]

{ #category : #accessing }
DrGIconSegmentMorph >> initialize [
	super initialize.
	style
		mark: #none;
		arrow: #none
	
]

{ #category : #accessing }
DrGIconSegmentMorph >> labelMorph: anObject [
"No label morph"
]

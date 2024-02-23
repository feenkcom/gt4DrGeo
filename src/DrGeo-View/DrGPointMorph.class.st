Class {
	#name : #DrGPointMorph,
	#superclass : #DrGMorph,
	#category : #'DrGeo-View-Item'
}

{ #category : #label }
DrGPointMorph >> constrainedLabelPosition: unconstrainedPosition [
	|center |
	center := self drawable worldToMorph: mathItem point.
	self computeLabelPositionDelta: unconstrainedPosition - center
	
]

{ #category : #obselete }
DrGPointMorph >> distanceTo: aPoint [
	^ self morphCenter dist: aPoint  
]

{ #category : #drawing }
DrGPointMorph >> drawOn: aCanvas [
| shape center |
	self isDrawNeeded ifFalse: [^ self].
	center := self morphCenter.
	(self isNotForAway or: [self drawable morphLocalBounds containsPoint: center]) ifFalse: [
		labelMorph ifNotNil: [labelMorph hide].
		^ false].
	self updateLabelStatus.
	shape := style shape.
	shape == #square ifTrue:	 	[
		aCanvas 
			fillRectangle: (Rectangle center: center extent: style pointExtent)
			color: color.
		^ self].
	shape == #round ifTrue:		[
		aCanvas fillColor: color  do: [ 		aCanvas circleCenter: center radius: style pointExtent x / 2.0].
		^ self].
	shape == #cross ifTrue:[ | e |
		e := style pointExtent / 2.0.
		aCanvas line: center - e to: center + e width: 1.5 color: color.
		aCanvas line: center + (e * (-1@1)) to: center + (e * (1@ -1)) width: 1.5 color: color]
]

{ #category : #'testing type' }
DrGPointMorph >> isPoint [
	^ true
]

{ #category : #label }
DrGPointMorph >> labelPosition [
	^(self drawable worldToMorph: mathItem point) + labelPositionDelta
]

{ #category : #accessing }
DrGPointMorph >> morphCenter [
	^ self drawable worldToMorph: mathItem point
]

{ #category : #accessing }
DrGPointMorph >> styleClass [
	^DrGPointStyle
]

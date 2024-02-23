"
I am circle. 
I can be drawn as a circle or a line when my radius goes toward the infinit
"
Class {
	#name : #DrGCircleMorph,
	#superclass : #DrGCurveMorph,
	#category : #'DrGeo-View-Item'
}

{ #category : #testing }
DrGCircleMorph >> containsPoint: localPoint [
	^ self containsPointInWorld: localPoint
]

{ #category : #drawing }
DrGCircleMorph >> drawCircleOn: aCanvas [
	| center r |
	center := self drawable worldToMorph: mathItem center.
	r := self drawable worldToPixel: mathItem radius.
	style isFilled 
		ifTrue: [	
			aCanvas strokeWidth: borderWidth color: borderColor fillColor: color do: [			
				aCanvas circleCenter: center radius: r]			]
		ifFalse: [
			aCanvas strokeWidth: borderWidth color: borderColor 
				strokeDashArray: dashedBorder strokeDashArrayOffset: 0.0 do: [
					aCanvas circleCenter: center  radius: r] ]
]

{ #category : #drawing }
DrGCircleMorph >> drawLineOn: aCanvas [
	| origin u points area |
	area := self drawable.
	origin := mathItem closestPointTo: 
		(area morphToWorld: self activeHand morphPosition - area morphPositionInWorld).
	u := (mathItem pointAt: (mathItem abscissaOf: origin) + 0.01) - origin.
	points := DrGLineMorph 
		extend: (area worldToMorph: origin)
		inDirection: (area vectorToMorph: u)
		toBorder: area morphExtent.
	points size = 2 ifTrue: [
		aCanvas strokeWidth: borderWidth color: borderColor 
			strokeDashArray: dashedBorder strokeDashArrayOffset: 0.0 do: [
				aCanvas moveTo: points first; lineTo: points second				] ]
]

{ #category : #drawing }
DrGCircleMorph >> drawOn: aCanvas [
	self isDrawNeeded ifFalse: [^ self].
	self updateLabelStatus.
	self isDrawnAsCircle 
		ifTrue: [self drawCircleOn: aCanvas]
		ifFalse: [self drawLineOn: aCanvas]
		
]

{ #category : #'testing type' }
DrGCircleMorph >> isCircle [
	^ true
]

{ #category : #testing }
DrGCircleMorph >> isDrawnAsCircle [
	^ mathItem radius < 1e5 
]

{ #category : #accessing }
DrGCircleMorph >> styleClass [
	^DrGCircleStyle
]

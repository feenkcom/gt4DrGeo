"
A DrGArcMorph is sampling an arc defined by
- its center
- its radius
- a starting point
- a signed length in radian
"
Class {
	#name : #DrGArcMorph,
	#superclass : #DrGCurveMorph,
	#category : #'DrGeo-View-Item'
}

{ #category : #accessing }
DrGArcMorph >> arrow: aSymbol [ 
	self flag: #drgeo
]

{ #category : #testing }
DrGArcMorph >> containsPoint: localPoint [
	^ self containsPointInWorld: localPoint
]

{ #category : #drawing }
DrGArcMorph >> drawOn: canvas [
	| center start end mid r orientation alpha1 alpha2 largeFlag |
	self isDrawNeeded ifFalse: [^ self].
	self updateLabelStatus.
	start := self drawable worldToMorph: (mathItem pointAt: 0).
	mid := self drawable worldToMorph: (mathItem pointAt: 0.5).
	end  := self drawable worldToMorph: (mathItem pointAt: 1).
	center := self drawable worldToMorph: mathItem center.
	alpha1 := ((mid - center) theta radiansToDegrees - (start - center) theta radiansToDegrees) \\ 360.
	alpha2 := ((end - center) theta radiansToDegrees - (start - center) theta radiansToDegrees) \\ 360.
	r := self drawable worldToPixel: mathItem radius.
	alpha1 > alpha2 		ifTrue: [	alpha2 := alpha2 - 360].
	orientation := mathItem length negative.
	largeFlag := alpha2 abs > 180.
	style isFilled 
		ifTrue: [
			canvas strokeWidth: borderWidth color: borderColor fillColor: color do: [
				canvas moveTo: start;
					arcTo: end radius: r angleOfXAxis: 0 
					largeFlag: largeFlag sweepFlag: orientation		 ] 	]
		ifFalse: [	
			canvas strokeWidth: borderWidth color: borderColor 
				strokeDashArray: dashedBorder strokeDashArrayOffset: 0.0 do: [
					canvas moveTo: start;
						arcTo: end radius: r angleOfXAxis: 0 
						largeFlag: largeFlag sweepFlag: orientation		] 	]
]

{ #category : #drawing }
DrGArcMorph >> drawOn: canvas from: start to: end radius: r lF: largeFlag sF: orientation [
	canvas moveTo: start;
		arcTo: end radius: r angleOfXAxis: 0 largeFlag: largeFlag sweepFlag: orientation	
]

{ #category : #'testing type' }
DrGArcMorph >> isArc [
	^ true
]

{ #category : #accessing }
DrGArcMorph >> styleClass [
	^DrGArcStyle
]

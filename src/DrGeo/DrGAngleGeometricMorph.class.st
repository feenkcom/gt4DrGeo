Class {
	#name : #DrGAngleGeometricMorph,
	#superclass : #DrGMorph,
	#instVars : [
		'origin',
		'length',
		'center',
		'vector1',
		'vector2',
		'screenCenter'
	],
	#category : #'DrGeo-View-Item'
}

{ #category : #drawing }
DrGAngleGeometricMorph >> canComputeArcData [
" Check the angle can be computed and compute its origin and length in radian "
	| parents end |
	parents := mathItem parents.
	center := parents second point.
	vector1 := parents first point - center.
	vector2 := parents third point - center.
	(vector1 = (0@0) or: [vector2 = (0@0)]) ifTrue: [^false].
	origin := vector1 y asFloat arcTan: vector1 x.
	end := vector2 y asFloat arcTan: vector2 x.
	origin < 0 ifTrue: [origin := origin + Float twoPi].
	end < 0 ifTrue: [end := end + Float twoPi].
	length := (end - origin) cos arcCos.
	(end - origin > Float pi 	or: [end - origin < 0 		and: [end - origin > Float pi negated]])	
		ifTrue: [length := length negated].
	^ true
]

{ #category : #accessing }
DrGAngleGeometricMorph >> constrainedLabelPosition: aPoint [ 
"Does nothing the label position is not user moveable"
]

{ #category : #drawing }
DrGAngleGeometricMorph >> drawArcOn: canvas [
	| radius |
	radius := self drawable pixelToWorld: 15.
	vector1 := self drawable worldToMorph: (center  + (radius * vector1 / vector1 r)).
	vector2 := self drawable worldToMorph: (center + (radius * vector2 / vector2 r)).
	canvas strokeWidth: 1 color: color do: [
		canvas moveTo: vector1.
		canvas 
			arcTo: vector2 
			radius: 15 
			angleOfXAxis: 0 
			largeFlag: (length abs > (Float pi))  
			sweepFlag: length negative	]
]

{ #category : #drawing }
DrGAngleGeometricMorph >> drawOn: canvas [
	| angleString font |
	self isDrawNeeded ifFalse: [^ self].
	self canComputeArcData ifFalse: [^ self].	
	self updateLabelStatus.
	(mathItem radianAngle closeTo: Float halfPi)
		ifTrue: 	[self drawRecOn: canvas]
		ifFalse: 	[self drawArcOn: canvas].
	font := DrGeoSystem canvasFont.
	angleString := self roundedValueString.
	canvas 
		drawString: angleString 
		at: self labelPosition - ((font widthOfString: angleString) @ font pointSize / 2.0)
		font: font
		color: color.
]

{ #category : #drawing }
DrGAngleGeometricMorph >> drawRecOn: canvas [
	| size p |
	size := self drawable pixelToWorld: 10.
	vector1 := self drawable vectorToMorph: (size * vector1 / vector1 r).
	vector2 := self drawable vectorToMorph: (size * vector2 / vector2 r).
	screenCenter := self drawable worldToMorph: center.
	canvas strokeWidth: 1 color: color do: [
		p := screenCenter + vector1.
		canvas moveTo: p.
		p := p + vector2.
		canvas lineTo: p.
		p := screenCenter + vector2.
		canvas lineTo: p	]

]

{ #category : #'testing type' }
DrGAngleGeometricMorph >> isAngle [
	^ true
]

{ #category : #accessing }
DrGAngleGeometricMorph >> labelMorph: object [
"No label morph for angle"
]

{ #category : #label }
DrGAngleGeometricMorph >> labelPosition [
	|angle|
	angle := self length negated / 2 + origin negated.
	^ (self drawable worldToMorph: center) + (35 * (angle cos @ angle sin))
]

{ #category : #accessing }
DrGAngleGeometricMorph >> length [
	^ length ifNil: [
		self canComputeArcData.
		length]
]

{ #category : #accessing }
DrGAngleGeometricMorph >> roundedValueString [
	| roundedValueString |
	roundedValueString := mathItem degreeAngle rounded asString, '°'.
	mathItem name isEmptyOrNil ifFalse: [
		roundedValueString := String streamContents: [ :str |
				str nextPutAll: mathItem name;
					nextPutAll: ' = ';
					nextPutAll: roundedValueString] ].
	^roundedValueString 	
]

{ #category : #accessing }
DrGAngleGeometricMorph >> styleClass [
	^ DrGValueStyle 
]

{ #category : #testing }
DrGAngleGeometricMorph >> wantsContour [
	^ false
]

Extension { #name : #Point }

{ #category : #'*DrGeo' }
Point >> closeTo: aPoint [
 	^ (x closeTo: aPoint x) and: [ y closeTo: aPoint y ]
]

{ #category : #'*DrGeo' }
Point >> printCouple [
	^ String streamContents: [:str | self printCoupleOn: str]

]

{ #category : #'*DrGeo' }
Point >> printCoupleOn: aStream [
" print as 'x,y' "
	x printOn: aStream.
	aStream nextPut: $,.
	y printOn: aStream
]

{ #category : #'*DrGeo' }
Point >> printMini [
	^ String streamContents: [:str | self printMinimumOn: str]

]

{ #category : #'*DrGeo' }
Point >> printMinimumOn: aStream [
" print as 'x,y' "
	x printOn: aStream.
	aStream nextPut: Character space.
	y printOn: aStream
]

{ #category : #'*DrGeo' }
Point >> printShowingDecimalPlaces: placeDesired [ 
"do not round when coordinate is a fraction"
	|stringX stringY|
	x isFraction
		ifTrue: [stringX := x printString]
		ifFalse: [stringX := x printShowingDecimalPlaces: placeDesired].
	y isFraction
		ifTrue: [stringY := y printString] 
		ifFalse: [stringY := y printShowingDecimalPlaces: placeDesired].		
	^ stringX, '@', stringY
]

{ #category : #'*DrGeo' }
Point >> reflexionBy: aPoint direction: aDirection [
"the reflected point according to the axe defined by aPoint and aDirection"
	^ ((self - aPoint) vectorReflexionBy: aDirection) + aPoint
]

{ #category : #'*DrGeo' }
Point >> rotateBy: angle about: center [ 
	"This method returns the point obtained after rotating myself (counter clockwise) 
	around the #center point of an #angle given as parameter. The #angle provided as 
	parameter is interpreted as being in radian."
	| p r theta |
	p := self - center.
	r := p r.
	theta := angle asFloat - p theta.
	^ (center x asFloat + (r * theta cos)) @ (center y asFloat - (r * theta sin))
]

{ #category : #'*DrGeo' }
Point >> rotateVector: anAngle [
|cosa sina|
	cosa := anAngle cos.
	sina := anAngle sin.
	^ (x * cosa - (y * sina))@(x * sina + (y * cosa))
]

{ #category : #'*DrGeo' }
Point >> roundTo: quantum [
	^ (x roundTo: quantum) @ (y roundTo: quantum)
]

{ #category : #'*DrGeo' }
Point >> vectorReflexionBy: aDirection [
"the reflected vector according to the direction"
	| unit normal |
	[unit := aDirection normalized.
	normal := unit normal] 
		on: ZeroDivide 
		do: [	unit := 0@0.
			normal := 0@0].
	^((self dotProduct: unit) * unit) - ((self dotProduct: normal) * normal)

]

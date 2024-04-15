Class {
	#name : #DrGPointItem,
	#superclass : #DrGMathItem,
	#instVars : [
		'point'
	],
	#category : #'DrGeo-Model-Item'
}

{ #category : #private }
DrGPointItem >> adaptiveDescriptiveName [
	^ 'This point %1' translated
]

{ #category : #accessing }
DrGPointItem >> basicType [
	^#point
]

{ #category : #computing }
DrGPointItem >> closestPointTo: aPoint [
	^ self point  
]

{ #category : #'testing-model' }
DrGPointItem >> isGeometricItem [
	^ true
]

{ #category : #'testing-model' }
DrGPointItem >> isPointItem [
	^ true
]

{ #category : #testing }
DrGPointItem >> isPropertyEditable [
	^ self isFreePointItem 
]

{ #category : #accessing }
DrGPointItem >> morphClass [ 
	^DrGPointMorph
]

{ #category : #updating }
DrGPointItem >> moveAt: aPoint [

]

{ #category : #updating }
DrGPointItem >> moveParent: aPoint [
	^false
]

{ #category : #scripting }
DrGPointItem >> moveTo: aPoint [
	self moveAt: aPoint.
	self update.
	self rehash.
]

{ #category : #accessing }
DrGPointItem >> point [
	^point 
]

{ #category : #accessing }
DrGPointItem >> point: aPoint [
	point := aPoint .
]

{ #category : #printing }
DrGPointItem >> printOn: aStream [
	self printType: DrGFlyPointBuilder title on: aStream.
	self printCoordinates: point on: aStream



]

{ #category : #accessing }
DrGPointItem >> x [
	^ point x 
]

{ #category : #accessing }
DrGPointItem >> y [
	^ point y
]

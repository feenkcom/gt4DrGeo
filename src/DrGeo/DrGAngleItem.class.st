Class {
	#name : #DrGAngleItem,
	#superclass : #DrGValueItem,
	#instVars : [
		'radianValue',
		'degreeValue'
	],
	#category : #'DrGeo-Model-Item'
}

{ #category : #private }
DrGAngleItem >> adaptiveDescriptiveName [
	^ 'This oriented angle %1' translated
]

{ #category : #accessing }
DrGAngleItem >> basicType [
	^#angle
]

{ #category : #accessing }
DrGAngleItem >> degreeAngle [
"return the angle in degree"
	^degreeValue 
]

{ #category : #'testing-model' }
DrGAngleItem >> isAngleItem [
	^true
]

{ #category : #printing }
DrGAngleItem >> printOn: aStream [
	self printType: DrGAngleOrientedBuilder title on: aStream.
	aStream nextPut: Character space.
	self printInteger: self degreeAngle on: aStream.
	aStream nextPutAll: '°'.
]

{ #category : #accessing }
DrGAngleItem >> radianAngle [
"return the angle in radian"
	^radianValue 
]

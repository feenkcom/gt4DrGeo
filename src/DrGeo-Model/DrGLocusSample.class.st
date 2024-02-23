"
I am a linked sample of a locus with: 
- the curvilinear abscissa of the free point
- my screen coordinates
- my world coordinates
- offScreen is sample offScreen (the display device)
- exist does this sample exist for  its abscissa 
"
Class {
	#name : #DrGLocusSample,
	#superclass : #Link,
	#instVars : [
		'abscissa',
		'pointScreen',
		'pointWorld',
		'offScreen',
		'exist'
	],
	#category : #'DrGeo-Model-Item'
}

{ #category : #testing }
DrGLocusSample >> isNotValid [
	^ exist not
]

{ #category : #testing }
DrGLocusSample >> isValid [
	^ exist
]

{ #category : #accessing }
DrGLocusSample >> isValid: aBoolean [
	^ exist := aBoolean 
]

{ #category : #testing }
DrGLocusSample >> isValidAndOnScreen [
	^ exist and: [offScreen not]
]

{ #category : #testing }
DrGLocusSample >> offScreen [ 
	^ offScreen 
]

{ #category : #accessing }
DrGLocusSample >> offScreen: aBoolean [
	offScreen  := aBoolean 
]

{ #category : #accessing }
DrGLocusSample >> pointScreen [

	^ pointScreen
]

{ #category : #accessing }
DrGLocusSample >> pointScreen: anObject [

	pointScreen := anObject
]

{ #category : #accessing }
DrGLocusSample >> pointWorld [

	^ pointWorld
]

{ #category : #accessing }
DrGLocusSample >> pointWorld: anObject [

	pointWorld := anObject
]

{ #category : #accessing }
DrGLocusSample >> x [

	^ abscissa
]

{ #category : #accessing }
DrGLocusSample >> x: anObject [

	abscissa := anObject
]

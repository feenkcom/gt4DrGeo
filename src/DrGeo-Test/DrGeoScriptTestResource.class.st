"
I set up a canvas to use.
"
Class {
	#name : #DrGeoScriptTestResource,
	#superclass : #TestResource,
	#instVars : [
		'sketch'
	],
	#category : #'DrGeo-Test'
}

{ #category : #testing }
DrGeoScriptTestResource >> isAvailable [ 
	^ sketch notNil
]

{ #category : #running }
DrGeoScriptTestResource >> setUp [
	sketch := DrGeoSketch new
]

{ #category : #accessing }
DrGeoScriptTestResource >> sketch [ 
	^ sketch
]

{ #category : #running }
DrGeoScriptTestResource >> tearDown [
	sketch release.
	sketch := nil
]

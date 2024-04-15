"
I am an abstract user script. 
My subclass 'DrGeoScriptXXXXXXX' are created from the Dr. Geo script wizard, menu: Script>Create a Script.

From the wizard, the user set :
- the script name (script class side method #scriptName)
- the scritp description (script class side method #description)
- the argumentType (script sclass side method #newArgumentType)

Next, from the source code browser (class browser), the user write the scription computation in the script  method #compute

A set of helpers are present to use in the #compute method:
- #arg1 to #arg4: to access first to fourth mathItem arguments as selected by the user
- #costume1 to #costume4: to access the first to fourth mathitem's view (morph)


Instance Variables
- arguments : Array of DrGCostum, arguments this script uses in its computation
- cosutme : the costume representing this script on the canvas, access only from its #costume message.
		
"
Class {
	#name : #DrGeoUserScript,
	#superclass : #Object,
	#instVars : [
		'arguments',
		'costume'
	],
	#classInstVars : [
		'argumentsType'
	],
	#category : #'DrGeo-Model-Script'
}

{ #category : #private }
DrGeoUserScript class >> argumentsType [
"return a collection of Math item, one for each argument type for this script"
	^ argumentsType ifNil: [ argumentsType := self newArgumentsType ]
]

{ #category : #public }
DrGeoUserScript class >> description [
	^ 'I am the description of this script. Please edit me.' translated
]

{ #category : #private }
DrGeoUserScript class >> newArgumentsType [
"The arguments type I need to work"
	self subclassResponsibility 
]

{ #category : #private }
DrGeoUserScript class >> reset [
	argumentsType := nil.
]

{ #category : #public }
DrGeoUserScript class >> scriptName [
"I appear in the scripts menu"
	^ 'A script' translated
]

{ #category : #helpers }
DrGeoUserScript >> arg1 [
	^ arguments first mathItem
]

{ #category : #helpers }
DrGeoUserScript >> arg2 [
	^ arguments second mathItem
]

{ #category : #helpers }
DrGeoUserScript >> arg3 [
	^ arguments third mathItem
]

{ #category : #helpers }
DrGeoUserScript >> arg4 [
	^ arguments fourth mathItem
]

{ #category : #private }
DrGeoUserScript >> arguments: aCollectionOfCostume [
	arguments := aCollectionOfCostume 
]

{ #category : #public }
DrGeoUserScript >> compute [
	"return a value, the returned value by the script"
	self subclassResponsibility 
]

{ #category : #helpers }
DrGeoUserScript >> costume [
"Search for the morph of my instance, then cache it"
	^ costume ifNil: [ 
		DrGDrawable allInstances 
			detect: [ :aDrawable | 
				aDrawable itemViews 
					detect: [:aMorph | aMorph mathItem isScriptItem and: [ aMorph mathItem script == self] ]
					ifFound: [ :theCostume | costume := theCostume. true]
					ifNone: [ false ] ]		
			ifFound: [costume ]
			ifNone: [ nil ]
		 ]
]

{ #category : #helpers }
DrGeoUserScript >> costume1 [
	^ arguments first
]

{ #category : #helpers }
DrGeoUserScript >> costume2 [
	^ arguments second
]

{ #category : #helpers }
DrGeoUserScript >> costume3 [
	^ arguments third
]

{ #category : #helpers }
DrGeoUserScript >> costume4 [
	^ arguments fourth
]

{ #category : #helpers }
DrGeoUserScript >> presenter [
"Access to the presenter handling my instance"
	^ self costume ifNotNil: [ costume presenter ]
]

"
I am a DrGeo view without toolbar, I only come with the wheels and the top menu. I am used to display computed sketches (i.e. sketches constrcuted from Smalltalk code with the DrGeo API)
"
Class {
	#name : #DrGeoMiniView,
	#superclass : #LayoutMorph,
	#instVars : [
		'drawable',
		'presenter'
	],
	#category : #'DrGeo-View'
}

{ #category : #'instance creation' }
DrGeoMiniView class >> for: aPresenter [
	^ self basicNew 
		presenter: aPresenter ;
		initialize;
		beColumn;
		yourself
]

{ #category : #'new-morph participation' }
DrGeoMiniView class >> includeInNewMorphMenu [
	^ false
]

{ #category : #'geometry testing' }
DrGeoMiniView >> clipsSubmorphs [
	^ false
]

{ #category : #'initialize-release' }
DrGeoMiniView >> defaultColor [
	^ Theme current paneBackgroundFrom: Theme current defaultWindowColor 
]

{ #category : #'initialize-release' }
DrGeoMiniView >> deleteWithoutConfirmation [
	self delete
]

{ #category : #accessing }
DrGeoMiniView >> drawable [
	^ drawable
]

{ #category : #accessing }
DrGeoMiniView >> fullScreen [
	self
		morphPosition: 0@0;
		morphExtent: RealEstateAgent maximumUsableArea extent
]

{ #category : #'initialize-release' }
DrGeoMiniView >> initialize [
	super initialize.
	self color: self defaultColor .
	drawable := DrGDrawable newOn: presenter .
	self morphExtent: 750@500
]

{ #category : #'initialize-release' }
DrGeoMiniView >> installTools [ 
	self beColumn
		addMorphUseAll: drawable
]

{ #category : #accessing }
DrGeoMiniView >> label [
	^ 'A Dr. Geo sketch' translated
]

{ #category : #menus }
DrGeoMiniView >> macroMenu: aMenuMorph [ 
	self flag: #drgeoTodo
]

{ #category : #accessing }
DrGeoMiniView >> presenter [
	^ presenter
]

{ #category : #accessing }
DrGeoMiniView >> presenter: anObject [
	presenter := anObject
]

{ #category : #'initialize-release' }
DrGeoMiniView >> release [
	presenter := drawable := nil.
]

{ #category : #menus }
DrGeoMiniView >> scriptMenu: aMenu [
self flag: #drgeoTodo
]

{ #category : #accessing }
DrGeoMiniView >> setLabel: aString [ 
	"There is not such things as a label for a minimal view"
]

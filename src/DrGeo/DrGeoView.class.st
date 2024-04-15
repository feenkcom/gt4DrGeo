"
I am full featured view of a DrGeo app
"
Class {
	#name : #DrGeoView,
	#superclass : #SystemWindow,
	#instVars : [
		'presenter',
		'drawable'
	],
	#category : #'DrGeo-View'
}

{ #category : #'initialize-release' }
DrGeoView class >> for: aPresenter [
	"A new model with an existing domain. For multiple MVP on a same
	Domain "
	^ super basicNew presenter: aPresenter ;
		 initialize
]

{ #category : #'open/close' }
DrGeoView >> delete [
	super delete.
	presenter ifNotNil: [presenter release]
]

{ #category : #'open/close' }
DrGeoView >> deleteWithoutConfirmation [
	super delete.
	presenter ifNotNil: [presenter release]
]

{ #category : #accessing }
DrGeoView >> domain [
	^ presenter domain 
]

{ #category : #accessing }
DrGeoView >> drawable [
	^ drawable
]

{ #category : #initialization }
DrGeoView >> initialize [
	super initialize.
	self model: self domain.
	self setLabel: 'Dr. Geo --  ' , Date today yyyymmdd.
	drawable := DrGDrawable newOn: presenter
]

{ #category : #accessing }
DrGeoView >> presenter [ 
	^ presenter
]

{ #category : #accessing }
DrGeoView >> presenter: aPresenter [
	presenter := aPresenter 
]

{ #category : #label }
DrGeoView >> relabel [
" Not authorized. Label is changed accordingly to the sketch name "
]

{ #category : #initialization }
DrGeoView >> release [
	presenter ifNotNil: [presenter removeActionsWithReceiver: self].
	drawable release.
	drawable := nil.
	presenter := nil
]

{ #category : #stepping }
DrGeoView >> step [
	DrGeoSystem ifTablet: [
		"track device rotation"
		self fullScreen].
]

{ #category : #stepping }
DrGeoView >> stepTime [
	^ 1000

]

{ #category : #stepping }
DrGeoView >> wantsSteps [
	^ DrGeoSystem isTablet
]

{ #category : #initialization }
DrGeoView >> windowColor [
	^Theme current browser
]

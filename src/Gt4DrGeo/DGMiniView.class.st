"
I subclass DrGeoMiniView for GT.

I am a DrGeo view without toolbar. I only come with the wheels and the top menu. I am used to display computed sketches (i.e. sketches constructed from Smalltalk code with the DrGeo API)
"
Class {
	#name : #DGMiniView,
	#superclass : #DrGeoMiniView,
	#category : #'Gt4DrGeo-View'
}

{ #category : #'instace creation' }
DGMiniView class >> for: aPresenter [
	^ self basicNew 
		presenter: aPresenter ;
		initialize;
		"beColumn;"
		yourself
]

{ #category : #'initialize-release' }
DGMiniView >> initialize [
	drawable := DGDrawable newOn: presenter .
]

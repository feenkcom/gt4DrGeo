Extension { #name : #DarkTheme }

{ #category : #'*DrGeo-canvas' }
DarkTheme >> canvasBackground [
	^ (Color black)
]

{ #category : #'*DrGeo-UI' }
DarkTheme >> drgeoButtonColor [
	^ (Color black lighter lighter lighter)

]

{ #category : #'*DrGeo-UI' }
DarkTheme >> drgeoButtonSelectedColor [
	^ (Color lightGray lighter)
]

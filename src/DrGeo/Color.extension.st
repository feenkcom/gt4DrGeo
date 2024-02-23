Extension { #name : #Color }

{ #category : #'*DrGeo' }
Color >> hexHtml [
	^ '#', self hexStringRGB 
]

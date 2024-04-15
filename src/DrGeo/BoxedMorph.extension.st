Extension { #name : #BoxedMorph }

{ #category : #'*DrGeo' }
BoxedMorph >> morphCenter [
	^ extent // 2
]

{ #category : #'*DrGeo' }
BoxedMorph >> morphCenter: aPoint [
"Positionning centered in its owner, according to its extent"
	self morphPosition: aPoint - (extent // 2) + ((1@1))
]

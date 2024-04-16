Extension { #name : #WorldMorph }

{ #category : #'*DrGeo-testing' }
WorldMorph >> isStepping: aMorph [
" Does this morph stepping? "
	^ stepList 		anySatisfy: [:aStepMessage | aStepMessage receiver == aMorph] 
]

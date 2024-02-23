Extension { #name : #SequenceableCollection }

{ #category : #'*DrGeo' }
SequenceableCollection >> shiftRight [
	^ self allButFirst, (Array with: self first)
]

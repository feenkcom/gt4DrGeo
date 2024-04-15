Class {
	#name : #DrGLocusTransformedMorph,
	#superclass : #DrGLocusMorph,
	#category : #'DrGeo-View-Item'
}

{ #category : #accessing }
DrGLocusTransformedMorph >> getVertices [
	vertices := 	mathItem points collect: [:point | self drawable worldToMorph: point].
]

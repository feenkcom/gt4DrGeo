Extension { #name : #RealEstateAgent }

{ #category : #'*DrGeo' }
RealEstateAgent class >> leftMaximumUsableArea [
"Return the left half of the usable area"
	| rectangle |
	rectangle := self maximumUsableArea.
	^ rectangle origin corner: rectangle bottomCenter
]

{ #category : #'*DrGeo' }
RealEstateAgent class >> rightMaximumUsableArea [
	"Return the left half of the usable area"
	| rectangle |
	rectangle := self maximumUsableArea.
	^ rectangle topCenter corner: rectangle corner
]

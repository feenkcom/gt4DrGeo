Extension { #name : #DrGeoSketch }

{ #category : #'*Gt4DrGeo' }
DrGeoSketch >> initialize [
	"Put stuff here!"
]

{ #category : #'*Gt4DrGeo' }
DrGeoSketch >> morphOf: item [
	| finalItem |
	
	true ifTrue: [
		^ item
	].
	
	finalItem := self domain createFromMathItemNoCommand: item.
	^ finalItem == item 
		ifTrue: [	self drawable lastItemView ] "We create a new one, get its morph just created"
		ifFalse: [	self drawable viewOf: finalItem] "For twin items, search for the former item"
]

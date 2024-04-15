Extension { #name : #MorphicEruditeDocRenderer }

{ #category : #'*DrGeo' }
MorphicEruditeDocRenderer >> createButton: aForm action: aBlock balloonText: balloonText [

	| button |
	
	button := ImageMorph new image: aForm; yourself.
	button setBalloonText: balloonText.
	button setProperty: #handlesMouseDown: toValue: true.
	button setProperty: #'mouseButton1Down:localPosition:' toValue: [:keyEvent :pos | aBlock value].
	
	^ button

	
]

{ #category : #'*DrGeo' }
MorphicEruditeDocRenderer >> renderCodeCopyToDrGeo: aDocCode [
	self deprecatedMethod.
	self renderCodeWithDrGeoActions: aDocCode 
]

{ #category : #'*DrGeo' }
MorphicEruditeDocRenderer >> renderCodeWithDrGeoActions: aDocCode [

	|text button textModel |
	
	text := Text string: aDocCode code.							.
							
	textModel := EruditeSmalltalkTextModel withText: text.
	textModel formatAndStyle.
		
	stream nextPut: textModel actualContents.
	stream nextPut: ' '.
	
	"Add as many buttons as you need here: "
	
	button := self createButton: Theme current openIcon 
			action: [requestor triggerEvent: #askToCopyCode with: aDocCode code]
			balloonText: 'Copy to the code editor.' translated. 
	stream nextPut: (Text streamContents: [:s | button printOn: s]).
	
	stream nextPut: ' '. "separation between buttons"
	" No additional DrGeo action for now...
	button := self createButton: Theme current imageIcon 
			action: [ self someDrGeoAction: aDocCode]
			balloonText: 'Preview the resulting Sketch when this code is executed.' translated. 
	stream nextPut: (Text streamContents: [:s | button printOn: s]).
	"
]

{ #category : #'*DrGeo' }
MorphicEruditeDocRenderer >> someDrGeoAction: aDocCode [

	^ self shouldBeImplemented 
]

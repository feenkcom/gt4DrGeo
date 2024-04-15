"
- app: a DrGeo instance
- firstPoint, current: initial/current point of a path
- pathNode : the XML node of the current path in construction

"
Class {
	#name : #DrGSvgCanvas,
	#superclass : #Object,
	#instVars : [
		'presenter',
		'svgTree',
		'firstPoint',
		'currentPoint',
		'pathNode'
	],
	#category : #'DrGeo-File'
}

{ #category : #private }
DrGSvgCanvas >> add: addArg toAttribute: symbol [
"
	Append the arguments (addArg) to the existing ones of the current pathNode 
"
	| prevArg newArg |
	prevArg := pathNode attributeAt: symbol ifAbsent: [''].
	newArg := String streamContents: [:str |
		str nextPutAll: prevArg ;
			nextPut: Character space;
			nextPutAll: addArg ].
	pathNode attributeAt: symbol put: newArg .
	^ addArg 
		
		
	
	
	
]

{ #category : #private }
DrGSvgCanvas >> addPathCommands: cmds [
"
	Append the commands (cmds) to the existing ones of the current pathNode 
"
	^ self add: cmds toAttribute: #d
		
	
	
	
]

{ #category : #drawing }
DrGSvgCanvas >> arcTo: point radius: radius angleOfXAxis: theta largeFlag: doLargerArc sweepFlag: useIncreasingAngles [
	self addPathCommands: (		String streamContents: [:str |	
		str nextPutAll: 'A ';
			nextPutAll: 	radius asPoint printMini; nextPut: Character space;
			nextPutAll: theta asString; nextPut: Character space;
			nextPutAll: (doLargerArc ifTrue: ['1 '] ifFalse: ['0 ']);
			nextPutAll: (useIncreasingAngles ifTrue: ['1 '] ifFalse: ['0 ']);
			nextPutAll: point printMini ]).
	currentPoint := point
]

{ #category : #drawing }
DrGSvgCanvas >> circleCenter: c radius: r [
	pathNode ifNil: [^ self]. "This method must be called in the context of a xxxxx:do: method"
	pathNode name: #circle.
	pathNode attributeAt: #cx put: c x asString.
	pathNode attributeAt: #cy put: c y asString.
	pathNode attributeAt: #r put: r asString.
]

{ #category : #private }
DrGSvgCanvas >> doPath: pathCommandsBlock ensureClosePath: ensureClosePath [
"Evaluate a sequence of path commands"
	self initializePath.
	pathCommandsBlock valueWithPossibleArgument:self.
	self finalizePath: ensureClosePath
]

{ #category : #drawing }
DrGSvgCanvas >> drawString: s at: pt font: fontOrNil color: aColor [
	| text fontSize zoom | 
	zoom := 1.4.
	fontSize := fontOrNil ifNil: [10] ifNotNil: [fontOrNil pointSize].
	text := XMLElement 
		named: #text 
		attributes: {
			#x -> pt x asString . #y -> (pt y + fontSize + 1) asString .
			#'font-size' -> (fontSize * zoom) asString .
			#fill -> aColor hexHtml } asDictionary.
	text addContent: (XMLStringNode string: s).
	svgTree addElement: text 

]

{ #category : #drawing }
DrGSvgCanvas >> drawTextComposition: aTextComposition at: aPoint extent: anEextent color: c selectionColor: sc [
" This is a short cut. I am but lazy to implement complet Morphic Canvas compatibility "
	| position delta |
	position := aPoint.
	delta := 0 @ aTextComposition defaultFont lineSpacing.
	(aTextComposition textComposed asString substringsSeparatedBy: Character lf) do: [:aString |
		self 
			drawString: aString 
			at: position 
			font: aTextComposition defaultFont
			color: c.
		position := position + delta]
]

{ #category : #accessing }
DrGSvgCanvas >> drawable [
	^presenter drawable 
]

{ #category : #drawing }
DrGSvgCanvas >> ellipseCenter: center radius: radius borderWidth: bw borderColor: bc fillColor: fillColor [
	| ellipse |
	ellipse := XMLElement 
		named: #ellipse
		attributes: {
			#cx -> center x asString . #cy -> center y asString .
			#rx -> radius asPoint x asString . #ry -> radius asPoint y asString} asDictionary.
	self styleOf: ellipse StrokeWidth: bw color: bc fillColor: 	fillColor.
	svgTree addElement: ellipse 
]

{ #category : #accessing }
DrGSvgCanvas >> engine [
"In case the Morph uses directly the VectorGraphics engine.
We are our own engine, there is no such things as a SVG engine"
	^ self
]

{ #category : #path }
DrGSvgCanvas >> fillColor: fillColor do: pathCommandsBlock [
	self pathStrokeWidth: nil color: nil fillColor: fillColor.
	self doPath: pathCommandsBlock ensureClosePath: true
]

{ #category : #drawing }
DrGSvgCanvas >> fillRectangle: rect color: fillColor [
	| rectNode |
	rectNode := self rectangle: rect.
	self styleOf: rectNode StrokeWidth: nil color: nil fillColor: fillColor.
	svgTree addElement: rectNode
]

{ #category : #drawing }
DrGSvgCanvas >> fillRectangle: aRectangle color: fillColor borderWidth: bw borderStyleSymbol: aSymbol baseColorForBorder: bc [
	| rect |
	rect := self rectangle: aRectangle .
	self styleOf: rect	 StrokeWidth: bw color: bc fillColor: 		fillColor.
	svgTree addElement: rect
]

{ #category : #private }
DrGSvgCanvas >> finalizePath: ensureClosePath [
	ensureClosePath ifTrue: [
		pathNode name caseOf: {
			[#path] -> [	self lineTo: firstPoint] .
			[#polyline] -> [self add: firstPoint printCouple toAttribute: #points] 
	} otherwise: []].
	svgTree addElement: pathNode.
	pathNode := nil
]

{ #category : #drawing }
DrGSvgCanvas >> frameRectangle: aRectangle color: bc borderWidth: bw borderStyleSymbol: aSymbol [
	| rect |
	rect := self rectangle: aRectangle.
	self styleOf: rect StrokeWidth: bw color: bc fillColor: nil.
	svgTree addElement: rect
]

{ #category : #private }
DrGSvgCanvas >> initializePath [
"Perform any initialization needed before starting a Path"
	firstPoint := nil.
	currentPoint := (0.0@0.0).

]

{ #category : #drawing }
DrGSvgCanvas >> line: pt1 to: pt2 width: w color: c [
	| line |
	line := XMLElement 
		named: #line 
		attributes: {
			#x1 -> pt1 x asString . #y1 -> pt1 y asString .
			#x2 -> pt2 x asString . #y2 -> pt2 y asString 	.
			#'stroke-width' -> w asString. #stroke -> c hexHtml .
			#'stroke-linecap' -> 'round' } asDictionary.
	svgTree addElement: line
	
]

{ #category : #drawing }
DrGSvgCanvas >> lineTo: point [
	firstPoint ifNil: [^ self].
	self addPathCommands: 'L ', point printMini.
	currentPoint := point 
]

{ #category : #drawing }
DrGSvgCanvas >> moveTo: point [
	firstPoint ifNil: [firstPoint := point].
	self addPathCommands: 'M ', point printMini.
	currentPoint := point 
]

{ #category : #private }
DrGSvgCanvas >> pathStrokeWidth: strokeWidth color: strokeColor fillColor: fillColor [
	self pathStrokeWidth: strokeWidth color: strokeColor 
		strokeDashArray: nil strokeDashArrayOffset: nil fillColor: fillColor 
]

{ #category : #private }
DrGSvgCanvas >> pathStrokeWidth: strokeWidth color: strokeColor strokeDashArray: sda strokeDashArrayOffset: sdao fillColor: fillColor [
	pathNode := XMLElement named: #path.
	self styleOf: pathNode StrokeWidth: strokeWidth color: strokeColor strokeDashArray: sda strokeDashArrayOffset: sdao fillColor: fillColor.
	^ pathNode

]

{ #category : #drawing }
DrGSvgCanvas >> polyLine: vertices [
	| coordinates |
	pathNode name: #polyline.
	firstPoint := vertices first. "In case we need to close the polyline"
	coordinates := String streamContents: [:str |
		vertices do: [:point | point printCoupleOn: str] separatedBy: [str nextPut: Character space] ].
	pathNode attributeAt: #points put: 	coordinates
		
		
]

{ #category : #accessing }
DrGSvgCanvas >> presenter: aPresenter [
	presenter := aPresenter 
]

{ #category : #private }
DrGSvgCanvas >> rectangle: rect [
	| rectNode |
	rectNode := XMLElement 
		named: #rect 
		attributes: {
			#x -> rect topLeft x asString . #y -> rect topLeft y asString .
			#width -> rect width asString . #height -> rect height asString } asDictionary.
	^ rectNode
]

{ #category : #rendering }
DrGSvgCanvas >> renderAxes [
	self drawable axesVisible ifTrue: [self drawable drawAxesOn: self]
]

{ #category : #rendering }
DrGSvgCanvas >> renderGrid [
	self drawable gridVisible ifTrue: [self drawable drawGridOn: self]
]

{ #category : #rendering }
DrGSvgCanvas >> renderLabelOf: aMorph [
	aMorph labelMorph ifNotNil: [
		self drawString: aMorph mathItem name 
		at: aMorph labelPosition
		font: DrGeoSystem canvasFont 
		color: Color black]
]

{ #category : #path }
DrGSvgCanvas >> strokeWidth: strokeWidth color: strokeColor do: pathCommandsBlock [
	self pathStrokeWidth: strokeWidth color: strokeColor fillColor: nil.
	self doPath: pathCommandsBlock ensureClosePath: false
]

{ #category : #path }
DrGSvgCanvas >> strokeWidth: strokeWidth color: strokeColor fillColor: fillColor do: pathCommandsBlock [
	self pathStrokeWidth: strokeWidth color: strokeColor fillColor: fillColor.
	self doPath: pathCommandsBlock ensureClosePath: true
]

{ #category : #path }
DrGSvgCanvas >> strokeWidth: strokeWidth color: strokeColor strokeDashArray: sda strokeDashArrayOffset: sdao do: pathCommandsBlock [
	self pathStrokeWidth: strokeWidth color: strokeColor strokeDashArray: sda strokeDashArrayOffset: sdao fillColor: nil.
	self doPath: pathCommandsBlock ensureClosePath: false
]

{ #category : #private }
DrGSvgCanvas >> styleOf: element StrokeWidth: strokeWidth color: strokeColor fillColor: fillColor [
	self styleOf: element StrokeWidth: strokeWidth color: strokeColor 
		strokeDashArray: nil strokeDashArrayOffset: nil fillColor: fillColor 
]

{ #category : #private }
DrGSvgCanvas >> styleOf: element StrokeWidth: strokeWidth color: strokeColor strokeDashArray: sda strokeDashArrayOffset: sdao fillColor: fillColor [
"
	Apply style to a given element (node) 
"
	strokeWidth ifNotNil: [element attributeAt: #'stroke-width' put: strokeWidth asString].
	strokeColor ifNotNil: [		element attributeAt: #stroke put: 
		(strokeColor isTransparent ifTrue: ['transparent'] ifFalse:		strokeColor hexHtml)].
	sda ifNotNil: [
		element 
			attributeAt: #'stroke-dasharray' 
			put: (String streamContents: [:s | sda do: [:e | s store: e] separatedBy: [ s space]])].
	sdao ifNotNil: [element attributeAt: #'stroke-dashoffset' put: sdao asString].
	fillColor 
		ifNotNil: [
			element attributeAt: #fill put: fillColor hexHtml.
			fillColor isOpaque ifFalse: [element attributeAt: #'fill-opacity' put: fillColor alpha asString] ]
		ifNil: [element attributeAt: #fill put: 'none']

]

{ #category : #accessing }
DrGSvgCanvas >> topNode: xmlNode [
	svgTree := 	xmlNode 
]

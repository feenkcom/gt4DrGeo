"
A DrGeoXml is an helper to load or save as an XML representation a DrGeo instance, including export to SVG.

"
Class {
	#name : #DrGeoXml,
	#superclass : #Object,
	#instVars : [
		'presenter'
	],
	#category : #'DrGeo-File'
}

{ #category : #accessing }
DrGeoXml >> domain [
	^ presenter domain
]

{ #category : #accessing }
DrGeoXml >> drawable [
	^ presenter drawable
]

{ #category : #'svg write' }
DrGeoXml >> exportToSvg: stream [
	| doc writer root canvas |
	doc := XMLDocument new.
	writer := XMLWriter on: stream.
	root := XMLElement 
		named: #svg 
		attributes: {
			#version -> '1.1'.
			#width -> self drawable morphExtent x asString.
			#height -> self drawable morphExtent y asString.
			#xmlns -> 'http://www.w3.org/2000/svg' } asDictionary.
	canvas := DrGSvgCanvas new 
		presenter: presenter;
		topNode: root;
		renderGrid;
		renderAxes;
		yourself.
	self factory pool do: [:item | | aMorph |
		aMorph := self drawable viewOf: item.
		aMorph isDrawNeeded ifTrue: [
			aMorph drawOn: canvas.
			canvas renderLabelOf: aMorph]	
	].
	doc addElement: root.
	doc printXMLOn: writer.
]

{ #category : #accessing }
DrGeoXml >> factory [
	^ self domain factory
]

{ #category : #'xml read item' }
DrGeoXml >> instantiateItemFrom: aNode [
 "instantiate an item from this node"
	^ self 
		perform: (self methodToParse: aNode) 
		with: aNode.
]

{ #category : #'xml read item' }
DrGeoXml >> instantiateStyle: aNode for: item [
 "instantiate the style for this item"
	self 
		perform: (#parseStyleOf , aNode tag capitalized , #':with:') asSymbol
		with: item
		with: aNode
]

{ #category : #testing }
DrGeoXml >> isCreatingMacro [
	^ presenter isNil
]

{ #category : #'xml read' }
DrGeoXml >> load: fileEntry for: constructor [
	^ self 
		loadFrom: (fileEntry readStream) 
		for: constructor 
]

{ #category : #'xml read' }
DrGeoXml >> loadFigureFrom: doc for: constructor [
"One XML document may contain several drgeo figure instances, parse it all,
and return a DrGeo for each one"
	|instances |
	instances := OrderedCollection new.
	(doc elementAt: #drgenius) ifNil: [^nil].
	(doc elementAt: #drgenius)
		tagsNamed: #drgeo
		do: [:each | instances add: (self parseOneFigure: each for: constructor)].
	^ instances
]

{ #category : #'xml read' }
DrGeoXml >> loadFrom: stream for: constructor [
"One XML document may contain several drgeo figure instances, parse it all,
and return a DrGeo for each one"
	| doc instances |
	doc := XMLDOMParser parseDocumentFrom: stream.
	stream close.
	self loadMacroFrom: doc.
	^ self loadFigureFrom: doc for: constructor.
]

{ #category : #'xml read' }
DrGeoXml >> loadMacroFrom: doc [
	(doc elementAt: #drgenius) ifNil: [^self].
	(doc elementAt: #drgenius)
		tagsNamed: #macro
		do: [:each | DrGMacroFactory new addUnique: (self parseOneMacro: each)].

]

{ #category : #'xml read' }
DrGeoXml >> loadOnlyFigureFrom: stream for: constructor [
"One XML document may contain several drgeo figure instances, parse it all,
and return a DrGeo for each one"
	| doc |
	doc := XMLDOMParser parseDocumentFrom: stream.
	stream close.
	^ self loadFigureFrom: doc	for: constructor
]

{ #category : #'xml read item' }
DrGeoXml >> methodToParse: aNode [
 "find which method to use to parse this node"
	|type|
	type := ((aNode attributeAt: #type) copyWithoutAll: '_' ) capitalized asSymbol.
	 ^(#parse , aNode tag capitalized , type , #':') asSymbol 
]

{ #category : #accessing }
DrGeoXml >> ox [
	 ^ self drawable ox
]

{ #category : #accessing }
DrGeoXml >> ox: aNumber [
	self drawable ox: aNumber
]

{ #category : #accessing }
DrGeoXml >> oy [
	 ^ self drawable oy
]

{ #category : #accessing }
DrGeoXml >> oy: aNumber [
	self drawable oy: aNumber
]

{ #category : #'xml read macro' }
DrGeoXml >> parentMacroNodesIn: macro from: aNode [ 
	"return a collection of parent macro nodes  given theirs id in the attribute
	elements <parent id=xxx>"
	|collection|
	collection := OrderedCollection new.
	aNode	elementsDo: [:each | 
		(each tag = #parent) ifTrue: [
			collection add: (macro detectId: (each attributeAt: 'ref') asSymbol)]].
	^collection 
]

{ #category : #'parse item' }
DrGeoXml >> parentsById: aNode [ 
	"return a collection of the item parent given theirs id in the attribute
	elements <parent id=xxx>"
	|collection|
	collection := OrderedCollection new.
	aNode	elementsDo: [:each | (each tag = #parent) ifTrue: [collection
				add: (self factory findInPoolById: (each attributeAt: 'ref') asSymbol)]].
	^collection 
]

{ #category : #'parse item' }
DrGeoXml >> parseAngle3pts: aNode [
	^ self parseItem: aNode with: DrGAngleGeometricBuilder.
]

{ #category : #'parse item' }
DrGeoXml >> parseAngle3ptsOriented: aNode [
	^ self parseItem: aNode with: DrGAngleOrientedBuilder.
]

{ #category : #'parse item' }
DrGeoXml >> parseAngleVectors: aNode [
	^ self parseItem: aNode with: DrGAngleOrientedBuilder.

]

{ #category : #'parse item' }
DrGeoXml >> parseArc3pts: aNode [
	^ self parseItem: aNode with: DrGArcBuilder.
]

{ #category : #'parse item' }
DrGeoXml >> parseArcCenterAngle: aNode [
	^ self parseItem: aNode with: DrGArcCenterBuilder.
]

{ #category : #'parse item' }
DrGeoXml >> parseArcCircle3pts: aNode [
"Dr.Geo 1.1 compatibility"
	^ self parseArc3pts: aNode
]

{ #category : #'parse item' }
DrGeoXml >> parseArcCircleReflexion: aNode [
"Dr.Geo 1.1 compatibility"
	^ self parseArcReflexion: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseArcCircleRotation: aNode [
"Dr.Geo 1.1 compatibility"
	^ self parseArcRotation: aNode
]

{ #category : #'parse item' }
DrGeoXml >> parseArcCircleScale: aNode [ 
"Dr.Geo 1.1 compatibility"
	^self parseArcHomothety: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseArcCircleSymmetry: aNode [ 
"Dr.Geo 1.1 compatibility"
	^ self parseArcSymmetry: aNode
]

{ #category : #'parse item' }
DrGeoXml >> parseArcCircleTranslation: aNode [
"Dr.Geo 1.1 compatibility"
	^self parseArcTranslation: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseArcHomothety: aNode [ 
	^self parseHomothety: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseArcReflexion: aNode [
	^ self parseReflexion: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseArcRotation: aNode [
	^ self parseRotation: aNode
]

{ #category : #'parse item' }
DrGeoXml >> parseArcSymmetry: aNode [ 
	^ self parseSymmetry: aNode
]

{ #category : #'parse item' }
DrGeoXml >> parseArcTranslation: aNode [
	^self parseTranslation: aNode 
]

{ #category : #'parse style' }
DrGeoXml >> parseArrowWith: aNode [ 
	| arrow |
	arrow := (aNode attributeAt: #arrow ifAbsent: [#none]) asSymbol.
	"Compatible with version <= 19.09"
	^ arrow 
		caseOf:  {
			[#makeForwardArrow] -> [#forward] .
			[#makeBackArrow] -> [#back] .
			[#makeBothArrows] -> [#both].
			[#makeNoArrows] -> [#none] 		}
		otherwise: [arrow].
	
]

{ #category : #'parse item' }
DrGeoXml >> parseBitmapFree: aNode [
"We do not have a builder yet for free bitmap"
	^ self parseItem: aNode with: DrGBitmapBuilder 
		
]

{ #category : #'parse item' }
DrGeoXml >> parseCircle2pts: aNode [
	^ self parseItem: aNode with: DrGCircleBuilder.
]

{ #category : #'parse item' }
DrGeoXml >> parseCircleHomothety: aNode [
	^self parseHomothety: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseCircleRadius: aNode [
	^ self parseItem: aNode with: DrGCircleBuilder.
]

{ #category : #'parse item' }
DrGeoXml >> parseCircleReflexion: aNode [
	^ self parseReflexion: aNode
]

{ #category : #'parse item' }
DrGeoXml >> parseCircleRotation: aNode [
	^ self parseRotation: aNode
]

{ #category : #'parse item' }
DrGeoXml >> parseCircleScale: aNode [
"Dr.Geo 1.1 compatibility"
	^self parseCircleHomothety: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseCircleSegment: aNode [
	^ self parseItem: aNode with: DrGCircleBuilder.
]

{ #category : #'parse item' }
DrGeoXml >> parseCircleSymmetry: aNode [ 
	^ self parseSymmetry:  aNode
]

{ #category : #'parse item' }
DrGeoXml >> parseCircleTranslation: aNode [
	^ self parseTranslation: aNode 
]

{ #category : #'parse style' }
DrGeoXml >> parseColorAt: colorAttribute with: aNode [ 
| attribute |
	attribute := (aNode attributeAt: colorAttribute ifAbsent: ['Transparent']) asLowercase.
	(attribute = 'darkgrey' or: [attribute = 'darkgray'])	ifTrue: [attribute := #darkGray].
	(attribute = 'grey' or: [attribute = 'gray']) ifTrue: [attribute := #gray].
	attribute = 'darkgreen' ifTrue: [attribute := #green].
	attribute = 'darkblue' ifTrue: [attribute := #blue].
	attribute = 'bordeaux' ifTrue: [attribute := #red].
	^ Color perform: attribute asSymbol
]

{ #category : #'parse item' }
DrGeoXml >> parseCoordinates: aNode [
	^ self parseItem: aNode with: DrGCoordinatesBuilder.
]

{ #category : #'parse item' }
DrGeoXml >> parseEquationCircle: aNode [
	^ self parseCoordinates: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseEquationLine: aNode [
	^ self parseCoordinates: aNode 
]

{ #category : #'xml read' }
DrGeoXml >> parseFigureFrom: drgeoNode [
"We parse from the view, because only the view knows both the domain and the view"
	|  itemStatut |
	self setScaleTo: (drgeoNode attributeAt: #scale ifAbsent: [self scale]).
	self ox: (drgeoNode attributeAt: #'origin_x' ifAbsent: [self ox]).
	self oy: (drgeoNode attributeAt: #'origin_y' ifAbsent: [self oy]).
	self view setLabel: (drgeoNode attributeAt: 'name' ifAbsent: ['no name' translated]). 
	(drgeoNode attributeAt: #grid) = 'True'	ifTrue: [presenter gridOnOff].
	(drgeoNode attributeAt: #axes) = 'True'	ifTrue: [presenter axesOnOff].
	(drgeoNode attributeAt: #gridded) = 'True'	ifTrue: [presenter gridStuckOnOff].
		
	self parseScript: drgeoNode.
	drgeoNode elementsDo: [:aNode | 
		aNode name ~= #controls ifTrue: [ 
			itemStatut := self instantiateItemFrom: aNode.
			itemStatut second ifTrue: [self instantiateStyle: aNode for: itemStatut first]
		]
	].
]

{ #category : #'parse item' }
DrGeoXml >> parseHalfLine2pts: aNode [
"Dr.Geo 1.1 compatibility"
	^self parseRay2pts: aNode
]

{ #category : #'parse item' }
DrGeoXml >> parseHalfLineReflexion: aNode [
"Dr.Geo 1.1 compatibility"
	^self parseRayReflexion: aNode
]

{ #category : #'parse item' }
DrGeoXml >> parseHalfLineRotation: aNode [
"Dr.Geo 1.1 compatibility"
	^self parseRayRotation: aNode
]

{ #category : #'parse item' }
DrGeoXml >> parseHalfLineScale: aNode [ 
"Dr.Geo 1.1 compatibility"
	^self parseRayHomothety: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseHalfLineSymmetry: aNode [ 
"Dr.Geo 1.1 compatibility"
	^self parseRaySymmetry: aNode
]

{ #category : #'parse item' }
DrGeoXml >> parseHalfLineTranslation:aNode [
"Dr.Geo 1.1 compatibility"
	^ self parseRayTranslation: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseHomothety: aNode [ 
	^ self parseItem: aNode with: DrGHomothetyBuilder
]

{ #category : #'xml read macro' }
DrGeoXml >> parseInput: node inMacro: macro [
	(node elementAt: #input) elementsDo: [:each | |item|
		item := DrGMacroMathItem new
			id: (each attributeAt: #id) asSymbol; 
			basicType: each tag;
			yourself.
		macro addNode: (DrGMacroInputNode new itemTemplate: item; yourself)]
]

{ #category : #'parse item' }
DrGeoXml >> parseItem: aNode with: builderClass [ 
	^ self isCreatingMacro 
		ifFalse: [builderClass itemFrom: aNode in: presenter "an itemStatut"]
		ifTrue: [builderClass basicItemFrom: aNode "an item"].

]

{ #category : #'parse item' }
DrGeoXml >> parseLine2pts: aNode [
	^self parseItem: aNode with: DrGLineBuilder.
]

{ #category : #'parse item' }
DrGeoXml >> parseLineAngleBisector3pts: aNode [
	^ self parseItem: aNode with: DrGAngleBisectorBuilder
]

{ #category : #'parse item' }
DrGeoXml >> parseLineAngleBisector: aNode [
	^ self parseItem: aNode with: DrGAngleBisectorBuilder
]

{ #category : #'parse item' }
DrGeoXml >> parseLineHomothety: aNode [
	^self parseHomothety: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseLineParallel: aNode [
	^self parseItem: aNode with: DrGParallelBuilder.
]

{ #category : #'parse item' }
DrGeoXml >> parseLinePerpendicular: aNode [ 
	^ self parseItem: aNode with: DrGPerpendicularBuilder.

]

{ #category : #'parse item' }
DrGeoXml >> parseLinePerpendicularBisector2pts: aNode [
	^ self parseItem: aNode with: DrGPerpendicularBisectorBuilder
]

{ #category : #'parse item' }
DrGeoXml >> parseLinePerpendicularBisector: aNode [
	^ self parseItem: aNode with: DrGPerpendicularBisectorBuilder
]

{ #category : #'parse item' }
DrGeoXml >> parseLineReflexion: aNode [ 
	^ self parseItem: aNode with: DrGReflectionBuilder.

]

{ #category : #'parse item' }
DrGeoXml >> parseLineRotation: aNode [
	^self parseRotation: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseLineScale: aNode [
"Dr.Geo 1.1 compatibility"
	^self parseLineHomothety: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseLineSymmetry: aNode [
	^ self parseSymmetry: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseLineTranslation: aNode [
	^self parseTranslation: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseLocus2pts: aNode [
	^ self parseItem: aNode with: DrGLocusBuilder.
]

{ #category : #'parse item' }
DrGeoXml >> parseLocusHomothety: aNode [
	^ self parseItem: aNode with: DrGHomothetyBuilder 
]

{ #category : #'parse item' }
DrGeoXml >> parseLocusNone: aNode [
"DrGeo 1.1 compatibility"
	 ^ self parseLocus2pts: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseLocusReflexion: aNode [ 
	^ self parseReflexion:  aNode
]

{ #category : #'parse item' }
DrGeoXml >> parseLocusRotation: aNode [
	^ self parseItem: aNode with: DrGRotationBuilder
]

{ #category : #'parse item' }
DrGeoXml >> parseLocusScale: aNode [
	^ self parseLocusHomothety: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseLocusSymmetry: aNode [ 
	^ self parseItem: aNode with: DrGSymmetryBuilder
]

{ #category : #'parse item' }
DrGeoXml >> parseLocusTranslation: aNode [
	^self parseTranslation: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseNumericArclength: aNode [
"Dr.Geo 1.1 compatibility"
	^ self parseValueArclength: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseNumericCircleperimeter: aNode [
"Dr.Geo 1.1 compatibility"
	^ self parseValueCircleperimeter: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseNumericDistance2pts: aNode [
"Dr.Geo 1.1 compatibility"
	^ self parseValueDistance2pts: aNode
]

{ #category : #'parse item' }
DrGeoXml >> parseNumericDistanceptline: aNode [
"Dr.Geo 1.1 compatibility"
	^ self parseValueDistanceptline: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseNumericSegmentlength: aNode [
"Dr.Geo 1.1 compatibility"
	^ self parseValueSegmentlength: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseNumericSlope: aNode [
"Dr.Geo 1.1 compatibility"
	^ self parseValueSlope: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseNumericValue: aNode [
"Dr.Geo 1.1 compatibility"
	^ self parseValueValue: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseNumericVectornorm: aNode [
"Dr.Geo 1.1 compatibility"
	^ self parseValueVectornorm: aNode 
]

{ #category : #'xml read' }
DrGeoXml >> parseOneFigure: node for: constructor [
" Instantiate this node in a DrGeo app and return it"
	self presenter: (DrGeo perform: constructor).
	presenter notInteractive: true.
	self parseFigureFrom: node.
	self drawable forcedVisibility: false.
	presenter 	notInteractive: false.
	self drawable redrawNeeded .
	presenter 	saved: true.
	^ presenter
]

{ #category : #'xml read macro' }
DrGeoXml >> parseOneMacro: node [
" parse one macro and return it"
	| macro|
	macro := DrGMacro new.
	macro title: (node attributeAt: #name).
	macro description: (node contentStringAt: #description).
	self parseInput: node inMacro: macro.
	self parseOutput: node inMacro: macro.
	macro saved: true. "We just load this macro, nothing to save"
	^ macro
]

{ #category : #'xml read macro' }
DrGeoXml >> parseOutput: node inMacro: macro [
	(node elementAt: #output) elementsDo: [:aNode | |macroNodeClass|
		aNode tag = #hidden ifTrue: [macroNodeClass := DrGMacroHiddenNode].
		aNode tag = #final ifTrue: [macroNodeClass := DrGMacroOutputNode].
		aNode elementsDo: [:child | 
			macro addNode: (
				macroNodeClass new 
					itemTemplate: (self instantiateItemFrom: child); 
					parentNodes: (self parentMacroNodesIn: macro from: child);
					yourself)]]
]

{ #category : #'parse item' }
DrGeoXml >> parsePointBlock: aNode [
	self notYetImplemented.
	"^ self parseItem: aNode with: DrGPointBlockBuilder."
]

{ #category : #'parse item' }
DrGeoXml >> parsePointCoordinate: aNode [
	^ self parseItem: aNode with: DrGPointByCoordinatesBuilder.
]

{ #category : #'parse item' }
DrGeoXml >> parsePointFree: aNode [
	^ self parseItem: aNode with: DrGFreePointBuilder 
		
]

{ #category : #'parse item' }
DrGeoXml >> parsePointHomothety: aNode [
	^ self parseItem: aNode with: DrGHomothetyBuilder 
]

{ #category : #'parse item' }
DrGeoXml >> parsePointIntersection: aNode [
	^ self parseItem: aNode with: DrGPointIntersectionBuilder
]

{ #category : #'parse item' }
DrGeoXml >> parsePointMiddle2pts: aNode [
^ self parseItem: aNode with: DrGMiddleBuilder.
]

{ #category : #'parse item' }
DrGeoXml >> parsePointMiddlesegment: aNode [
	^self parseItem: aNode with: DrGMiddleBuilder.
]

{ #category : #'parse item' }
DrGeoXml >> parsePointOncurve: aNode [
	^ self parseItem: aNode with: DrGFreePointBuilder 
]

{ #category : #'parse item' }
DrGeoXml >> parsePointReflexion: aNode [ 
	^ self parseReflexion:  aNode
]

{ #category : #'parse item' }
DrGeoXml >> parsePointRotation: aNode [
	^ self parseItem: aNode with: DrGRotationBuilder
]

{ #category : #'parse item' }
DrGeoXml >> parsePointScale: aNode [
"Dr.Geo 1.1 compatibility"
	^ self parsePointHomothety: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parsePointScript: aNode [
	^ self parseItem: aNode with: DrGPointByCoordinatesBuilder.
]

{ #category : #'parse item' }
DrGeoXml >> parsePointSymmetry: aNode [ 
	^ self parseItem: aNode with: DrGSymmetryBuilder
]

{ #category : #'parse item' }
DrGeoXml >> parsePointTranslation: aNode [
	^self parseTranslation: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parsePolygonHomothety: aNode [ 
	^self parseHomothety: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parsePolygonNpts: aNode [
	^ self parseItem: aNode with: DrGPolygonBuilder
]

{ #category : #'parse item' }
DrGeoXml >> parsePolygonReflexion: aNode [
	^ self parseReflexion: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parsePolygonRegular: aNode [
	^ self parseItem: aNode with: DrGPolygonRegularBuilder
]

{ #category : #'parse item' }
DrGeoXml >> parsePolygonRotation: aNode [
	^ self parseRotation: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parsePolygonScale: aNode [ 
"Dr.Geo 1.1 compatibility"
	^self parsePolygonHomothety: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parsePolygonSymmetry: aNode [ 
	^self parseSymmetry: aNode
]

{ #category : #'parse item' }
DrGeoXml >> parsePolygonTranslation: aNode [
	^self parseTranslation: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseRay2pts: aNode [
	^self parseItem: aNode with: DrGRayBuilder.
]

{ #category : #'parse item' }
DrGeoXml >> parseRayHomothety: aNode [ 
	^self parseHomothety: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseRayReflexion: aNode [
	^self parseReflexion: aNode
]

{ #category : #'parse item' }
DrGeoXml >> parseRayRotation: aNode [
	^self parseRotation: aNode
]

{ #category : #'parse item' }
DrGeoXml >> parseRaySymmetry: aNode [ 
	^self parseSymmetry: aNode
]

{ #category : #'parse item' }
DrGeoXml >> parseRayTranslation:aNode [
	^ self parseTranslation: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseReflexion: aNode [ 
	^ self parseItem: aNode with: DrGReflectionBuilder
]

{ #category : #'parse item' }
DrGeoXml >> parseRotation: aNode [ 
	^ self parseItem: aNode with: DrGRotationBuilder
]

{ #category : #'xml read' }
DrGeoXml >> parseScript: drgeoNode [
"First do one pass to compile all the script Smalltalk source code"
	drgeoNode elementsDo: [: node |
		(node tag = #value and: [(node attributeAt: #type) = #script]) ifTrue:
			[(node contentStringAt: #code) readStream fileInAnnouncing: 'Compile']]
]

{ #category : #'parse item' }
DrGeoXml >> parseScriptNitems: aNode [
	"Do nothing!, compatibility for Dr. Geo 1.1
	See method parseValueScript:"
]

{ #category : #'parse item' }
DrGeoXml >> parseSegment2pts: aNode [ 
	^ self parseItem: aNode with: DrGSegmentBuilder
]

{ #category : #'parse item' }
DrGeoXml >> parseSegmentHomothety: aNode [
	^self parseHomothety: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseSegmentReflexion: aNode [
	^ self parseReflexion: aNode
]

{ #category : #'parse item' }
DrGeoXml >> parseSegmentRotation: aNode [
	^self parseRotation: aNode
]

{ #category : #'parse item' }
DrGeoXml >> parseSegmentScale: aNode [
"Dr.Geo 1.1 compatibility"
	^self parseSegmentHomothety: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseSegmentSymmetry: aNode [
	^self parseSymmetry: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseSegmentTranslation: aNode [
	^self parseTranslation: aNode 
]

{ #category : #'parse style' }
DrGeoXml >> parseStyleOf: costume with: aNode [ 
	costume name: (aNode attributeAt: #name).
	costume labelPositionDelta: (Point readFrom: (aNode attributeAt: #delta ifAbsent: ['7@7'])).
	costume style hidden: (aNode attributeAt: #masked) = 'True'.
	costume style feedback: (aNode attributeAt: #feedback ifAbsent: ['True']) = 'True'.
	costume style color: (self parseColorAt: #color with: aNode).
]

{ #category : #'parse style' }
DrGeoXml >> parseStyleOfAngle: item with: aNode [ 
	self parseStyleOfNumeric: item  with: aNode 
]

{ #category : #'parse style' }
DrGeoXml >> parseStyleOfArc: item with: aNode [ 
	|costume|
	costume := self parseStyleOfCurve: item with: aNode.
	costume style arrow: (self parseArrowWith: aNode).
	self parseStyleOfFilledCircle: costume with: aNode
]

{ #category : #'parse style' }
DrGeoXml >> parseStyleOfArcCircle: item with: aNode [ 
	self parseStyleOfArc: item with: aNode
]

{ #category : #'parse style' }
DrGeoXml >> parseStyleOfBitmap: item with: aNode [ 
	| morph |
	morph := self drawable fastLastItemView .
	self parseStyleOf: morph with: aNode
]

{ #category : #'parse style' }
DrGeoXml >> parseStyleOfCircle: item with: aNode [ 
	|costume|
	costume := self parseStyleOfCurve: item with: aNode.
	self parseStyleOfFilledCircle: costume with: aNode
]

{ #category : #'parse style' }
DrGeoXml >> parseStyleOfCurve: item with: aNode [ 
	| morph attribute |
	morph := self drawable fastLastItemView .
	self parseStyleOf: morph with: aNode.
	morph anchorAbscissa: (aNode attributeAt: #anchor ifAbsent: ['0.5']) asNumber.
	
	attribute := aNode attributeAt: #thickness.
	(DrGTypeThickness thicknessSymbols includes: attribute asSymbol)
		ifTrue: [morph style thickness: attribute asSymbol]
		ifFalse: ["DrGeo 1.1"
			attribute = 'Dashed' ifTrue: [morph style lineStyle: #dash.].
			attribute = 'Thick' ifTrue: [morph style thickness: #medium]].
	attribute := aNode attributeAt: #style ifAbsent: [^ morph].
	morph style lineStyle: attribute.
	^ morph
]

{ #category : #'parse style' }
DrGeoXml >> parseStyleOfEquation: item with: aNode [ 
	| morph |
	morph := self drawable fastLastMorph .
	self parseStyleOf: morph with: aNode.
]

{ #category : #'parse style' }
DrGeoXml >> parseStyleOfFilledCircle: costume with: aNode [ 
	costume style fill: (aNode attributeAt: #filled ifAbsent: ['False']) = 'True'.
	costume style translucent: 	(aNode attributeAt: #translucent ifAbsent: ['True']) = 'True'.

]

{ #category : #'parse style' }
DrGeoXml >> parseStyleOfFilledPolygon: costume with: aNode [ 
	costume style fill: (aNode attributeAt: #filled ifAbsent: ['True']) = 'True'.
	costume style translucent: 	(aNode attributeAt: #translucent ifAbsent: ['True']) = 'True'.

]

{ #category : #'parse style' }
DrGeoXml >> parseStyleOfHalfLine: item with: aNode [ 
"DrGeo 1.1 xml compatibility"
	self parseStyleOfRay: item with: aNode
]

{ #category : #'parse style' }
DrGeoXml >> parseStyleOfLine: item with: aNode [ 
	self parseStyleOfCurve: item with: aNode
]

{ #category : #'parse style' }
DrGeoXml >> parseStyleOfLocus: item with: aNode [ 
	self parseStyleOfCurve: item with: aNode
]

{ #category : #'parse style' }
DrGeoXml >> parseStyleOfNumeric: item with: aNode [ 
 "DrGeo 1.1 xml compatibility"
	self parseStyleOfValue: item with: aNode
]

{ #category : #'parse style' }
DrGeoXml >> parseStyleOfPoint: item with: aNode [ 
	| morph attribute |
	morph := self drawable fastLastItemView .
	self parseStyleOf: morph with: aNode.
	attribute := aNode attributeAt: #thickness.
	attribute = 'Dashed'
		ifTrue: [attribute := #small].
	attribute = 'Normal'
		ifTrue: [attribute := #medium].
	attribute = 'Thick'
		ifTrue: [attribute := #large].
	morph style pointSize: attribute.
	attribute := aNode attributeAt: #style.
	(#('Rectangular' 'RectangularEmpty' ) includes: attribute)
		ifTrue: [attribute := #square].
	attribute = 'RoundEmpty'
		ifTrue: [attribute := #round].
	morph style shape: attribute asLowercase asSymbol
]

{ #category : #'parse style' }
DrGeoXml >> parseStyleOfPolygon: item with: aNode [ 
	| costume |
	costume := self parseStyleOfCurve: item with: aNode.
	self parseStyleOfFilledPolygon: costume with: aNode
]

{ #category : #'parse style' }
DrGeoXml >> parseStyleOfRay: item with: aNode [ 
	self parseStyleOfCurve: item with: aNode
]

{ #category : #'parse style' }
DrGeoXml >> parseStyleOfSegment: item with: aNode [ 
	| costume |
	costume := self parseStyleOfCurve: item with: aNode.
	costume style mark: (aNode attributeAt: #mark ifAbsent: [#none]) asSymbol.
	costume style arrow: (self parseArrowWith: aNode)
]

{ #category : #'parse style' }
DrGeoXml >> parseStyleOfText: item with: aNode [ 
	| morph |
	morph := self drawable fastLastItemView .
	self parseStyleOf: morph with: aNode.
	morph style
		setTranslucent: (self parseColorAt: #background with: aNode).
	morph style
		borderColor: (self parseColorAt: #border with: aNode).
	morph style
		fontSize: (aNode attributeAt: #fontSize ifAbsent: DrGeoSystem canvasFontSize) asNumber.
]

{ #category : #'parse style' }
DrGeoXml >> parseStyleOfValue: item with: aNode [ 
	self parseStyleOfText: item with: aNode
]

{ #category : #'parse style' }
DrGeoXml >> parseStyleOfVector: item with: aNode [ 
	self parseStyleOfCurve: item with: aNode.
	item origin: (Point readFrom: (aNode attributeAt: #origin ifAbsent: [^self]))
]

{ #category : #'parse item' }
DrGeoXml >> parseSymmetry: aNode [ 
	^ self parseItem: aNode with: DrGSymmetryBuilder
]

{ #category : #'parse item' }
DrGeoXml >> parseTextFree: aNode [
	^ self parseItem: aNode with: DrGTextBuilder
]

{ #category : #'parse item' }
DrGeoXml >> parseTranslation: aNode [ 
	^ self parseItem: aNode with: DrGTranslationBuilder
]

{ #category : #'parse item' }
DrGeoXml >> parseValueArclength: aNode [
	^ self parseValueComputation: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseValueCircleperimeter: aNode [
	^ self parseValueComputation: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseValueComputation: aNode [
	^ self parseItem: aNode with: DrGValueBuilder.
]

{ #category : #'parse item' }
DrGeoXml >> parseValueDistance2pts: aNode [
	^ self parseValueComputation: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseValueDistanceptline: aNode [
	^ self parseValueComputation: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseValuePolygonperimeter: aNode [
	^ self parseValueComputation: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseValuePtabscissa: aNode [
	^ self parseCoordinates: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseValuePtordinate: aNode [
	^ self parseCoordinates: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseValueScript: aNode [
	^ self parseItem: aNode with: DrGScriptPlayer.
]

{ #category : #'parse item' }
DrGeoXml >> parseValueSegmentlength: aNode [
	^ self parseValueComputation: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseValueSlope: aNode [
	^ self parseValueComputation: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseValueValue: aNode [
	^ self parseValueComputation: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseValueVectorabscissa: aNode [
	^ self parseCoordinates: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseValueVectornorm: aNode [
	^ self parseValueComputation: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseValueVectorordinate: aNode [
	^ self parseCoordinates: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseVector2pts: aNode [
	^self parseItem: aNode with: DrGVectorBuilder.
]

{ #category : #'parse item' }
DrGeoXml >> parseVectorHomothety: aNode [ 
	^self parseHomothety: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseVectorReflexion: aNode [
	^self parseReflexion: aNode
]

{ #category : #'parse item' }
DrGeoXml >> parseVectorRotation: aNode [
	^self parseRotation: aNode
]

{ #category : #'parse item' }
DrGeoXml >> parseVectorScale: aNode [ 
"Dr.Geo 1.1 compatibility"
	^self parseVectorHomothety: aNode 
]

{ #category : #'parse item' }
DrGeoXml >> parseVectorSymmetry: aNode [ 
	^ self parseSymmetry: aNode
]

{ #category : #accessing }
DrGeoXml >> presenter: aDrGeoPresenter [ 
	presenter := aDrGeoPresenter
]

{ #category : #'xml write' }
DrGeoXml >> saveMultiple: sketchesAndMacros on: stream [
	| doc writer root |
	doc := XMLDocument new version: '1.0'.
	writer := XMLWriter on: stream.
	root := XMLElement named: #drgenius.
	(sketchesAndMacros select: [:each | each class = DrGeoView]) do: [:view |
		self presenter: view presenter.
		self writeFigureAsXmlTo: root].
	(sketchesAndMacros select: [:each | each class = DrGMacro]) do: [:macro |
		macro writeAsXmlTo: root].
	doc addElement: root.
	doc printXMLOn: writer.
]

{ #category : #'xml write' }
DrGeoXml >> saveOn: stream [
	| doc writer root |
	doc := XMLDocument new version: '1.0'.
	writer := XMLWriter on: stream.
	root := XMLElement named: #drgenius.
	self writeFigureAsXmlTo: root.
	doc addElement: root.
	doc printXMLOn: writer.
]

{ #category : #accessing }
DrGeoXml >> scale [
	 ^ self drawable scale
]

{ #category : #accessing }
DrGeoXml >> setScaleTo: aNumber [
	self drawable setScaleTo: aNumber
]

{ #category : #accessing }
DrGeoXml >> view [
	^ presenter view
]

{ #category : #'xml write' }
DrGeoXml >> writeFigureAsXmlTo: aNode [ 
	| drgeoNode attr |
	attr := Dictionary new.
	attr 	at: #scale put: self scale asString;
		at: #'origin_x' put: self ox asString;
		at: #'origin_y' put: self oy asString;
		at: #grid put: presenter isGridVisible asString capitalized;
		at: #gridded put: presenter isGridded asString capitalized;
		at: #axes put: presenter isAxesVisible asString capitalized;
		at: #name put: presenter sketchName. "Can't be nil, it's the base name for the file name"
	drgeoNode := XMLElement named: #drgeo attributes: attr.
	"Write the items"
	self factory pool do: [:anItem |
		(self drawable viewOf: anItem) writeAsXmlTo: drgeoNode].
	aNode addElement: drgeoNode
]

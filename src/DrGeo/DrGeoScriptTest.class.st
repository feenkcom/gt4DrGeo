"
These tests are based on the Smalltalk Sketch API to construct programmatically geometric sketches.
"
Class {
	#name : #DrGeoScriptTest,
	#superclass : #TestCase,
	#instVars : [
		'sketch'
	],
	#category : #'DrGeo-Test'
}

{ #category : #'as yet unclassified' }
DrGeoScriptTest class >> resources [ 
	^ {DrGeoScriptTestResource}
]

{ #category : #running }
DrGeoScriptTest >> setUp [ 
	sketch := DrGeoScriptTestResource current sketch
]

{ #category : #running }
DrGeoScriptTest >> tearDown [ 
	sketch := nil
]

{ #category : #'testing-value' }
DrGeoScriptTest >> testAbscissaOfPoint [
	| coordinate point |
	point := sketch point: 10@15.
	coordinate := sketch abscissaOf: point.
	self should: (coordinate mathItem valueItem closeTo: 10).
]

{ #category : #'testing-value' }
DrGeoScriptTest >> testAbscissaOfVector [
	| coordinate vector |
	vector := sketch vector: 10@15.
	coordinate := sketch abscissaOf: vector.
	self should: (coordinate mathItem valueItem closeTo: 10).
]

{ #category : #'testing-line' }
DrGeoScriptTest >> testAngleBisector [
	| bisector geometricAngle |
	geometricAngle := sketch angle: 1@0 to: 0@0 to: 0@1.
	bisector := sketch angleBisector: geometricAngle.
	""
	self assert: (bisector mathItem contains: 0@0).
	self assert: (bisector mathItem contains: 1@1).
	self assert: (bisector mathItem contains: -10@ -10).
	self deny: (bisector mathItem contains: -1@ -10).


]

{ #category : #'testing-line' }
DrGeoScriptTest >> testAngleBisector3Points [
	| bisector |
	bisector := sketch angleBisectorSummit: 0@0 side1: 1@0 side2: 0@1.
	""
	self assert: (bisector mathItem contains: 0@0).
	self assert: (bisector mathItem contains: 1@1).
	self assert: (bisector mathItem contains: -10@ -10).
	self deny: (bisector mathItem contains: -1@ -10).


]

{ #category : #'testing-line' }
DrGeoScriptTest >> testAngleBisectorVectors [
"there is no such things as bisector to an angle formed with two vectors"
	| orientedAngle |
	orientedAngle := sketch angle: 1@0 to: 0@1.
	self should: [sketch angleBisector: orientedAngle] raise: MessageNotUnderstood.


]

{ #category : #'testing-value' }
DrGeoScriptTest >> testAngleGeometric [
	| angle |
	angle := sketch geometricAngle: 1@0 to: 1@1 to: 0@1.
	self assert: (angle mathItem degreeAngle closeTo: 90).
	self assert: (angle mathItem radianAngle closeTo: Float pi / 2).
	""
	angle := sketch geometricAngle: 2@1 to: 1@1 to: 2@2.
	self assert: (angle mathItem degreeAngle closeTo: 45).
	self assert: (angle mathItem radianAngle closeTo: Float pi / 4).

]

{ #category : #'testing-value' }
DrGeoScriptTest >> testAngleOriented3Points [
	| angle |
	angle := sketch angle: 1@0 to: 1@1 to: 0@1.
	self assert: (angle mathItem degreeAngle closeTo: 270).
	self assert: (angle mathItem radianAngle closeTo: (Float pi / 2) negated ).
	""
	angle := sketch angle: 2@1 to: 1@1 to: 2@2.
	self assert: (angle mathItem degreeAngle closeTo: 45).
	self assert: (angle mathItem radianAngle closeTo: Float pi / 4).

]

{ #category : #'testing-value' }
DrGeoScriptTest >> testAngleOrientedVector [
"Oriented angle from two vectors"
	| angle |
	angle := sketch angle: 1@0 to: 0@1.
	self assert: (angle mathItem degreeAngle closeTo: 90).
	self assert: (angle mathItem radianAngle closeTo: Float pi / 2).
	""
	angle := sketch angle: 0@1 to: 1@0.
	self assert: (angle mathItem degreeAngle closeTo: 90 negated).
	self assert: (angle mathItem radianAngle closeTo: Float pi negated / 2).
	""
	angle := sketch angle: 1@1 to: -1@1.
	self assert: (angle mathItem degreeAngle closeTo: 90).
	self assert: (angle mathItem radianAngle closeTo: Float pi / 2).
	""
	angle := sketch angle: -1@0 to: 1@1.
	self assert: (angle mathItem degreeAngle closeTo: 135 negated).
	self assert: (angle mathItem radianAngle closeTo: Float pi negated * 3 / 4).

]

{ #category : #'testing-arc' }
DrGeoScriptTest >> testArc [
	| arc|
	arc := sketch arc: (sketch point: 8@2) to:  (sketch point: 6@6) to: (sketch point: 3@7).
	self assert: arc mathItem isArcItem.
	self assert: arc mathItem isGeometricItem.
	self assert: arc mathItem isCurveItem.
	""
	self should: (arc mathItem radius closeTo: 5).
	self should: (arc mathItem center = (3@2)).
	self should: (arc mathItem length closeTo: Float pi / 2 ).
	self should: (arc mathItem contains: 8@2).
	self shouldnt: (arc mathItem contains: 3@ -3).
	self shouldnt: (arc mathItem contains: -2@ 2).  
]

{ #category : #'testing-arc' }
DrGeoScriptTest >> testArcReflexion [
	| arc1 arc2 d|
	d := sketch line: 0@0 to: 1@2.
	arc1 := sketch arc: 8@2 to:  6@6 to: 3@7.
	arc2 := sketch reflect: arc1 axis: d.
	""
	self should: (arc2 mathItem radius closeTo: 5).
	self should: (arc2 mathItem center closeTo: (-0.2@3.6)).
	self should: (arc1 mathItem length closeTo: Float pi / 2 ).
	self should: (arc2 mathItem length closeTo: Float pi negated / 2 ).
	self should: (arc2 mathItem contains: -3.2@7.6).
	self should: (arc2 mathItem contains: 1.2@8.4).
	self should: (arc2 mathItem contains: 3.8@6.6).  
]

{ #category : #'testing-arc' }
DrGeoScriptTest >> testArcRotation [
	| arc1 arc2 |
	arc1 := sketch arc: 8@2 to: 6@6 to: 3@7.
	arc2 := sketch rotate: arc1 center: 1@1 angle: Float pi / 3.
	""
	self should: (arc2 mathItem radius closeTo: 5).
	self should: (arc2 mathItem center closeTo: (1.1339745962155614@3.232050807568877)).
	self should: (arc1 mathItem length closeTo: Float pi / 2 ).
	self should: (arc2 mathItem length closeTo: Float pi / 2 ).
	self should: (arc2 mathItem contains: (3.6339745962155625@7.56217782649107)).
	self should: (arc2 mathItem contains: (-0.8301270189221928@7.830127018922194)).
	self should: (arc2 mathItem contains: (-3.196152422706631@5.7320508075688785)).  
]

{ #category : #'testing-arc' }
DrGeoScriptTest >> testArcScale [
	| arc1 arc2 |
	arc1 := sketch arc: 8@2 to: 6@6 to: 3@7.
	arc2 := sketch scale: arc1 center: 1@1 factor: 3.
	""
	self should: (arc2 mathItem radius closeTo: 5 * 3).
	self should: (arc2 mathItem center closeTo: 7@4).
	self should: (arc1 mathItem length closeTo: Float pi / 2 ).
	self should: (arc2 mathItem length closeTo: Float pi / 2 ).
	self should: (arc2 mathItem contains: 22@4).
	self should: (arc2 mathItem contains: 16@16).
	self should: (arc2 mathItem contains: 7@19).
	
]

{ #category : #'testing-arc' }
DrGeoScriptTest >> testArcTranslation [
	| arc1 arc2 |
	arc1 := sketch arc: 8@2 to: 6@6 to: 3@7.
	arc2 := sketch translate: arc1 vector: 2@1.
	""
	self should: (arc2 mathItem radius closeTo: 5 ).
	self should: (arc2 mathItem center closeTo: 5@3).
	self should: (arc2 mathItem length closeTo: Float pi / 2 ).
	self should: (arc2 mathItem contains: 10@3).
	self should: (arc2 mathItem contains: 8@7).
	self should: (arc2 mathItem contains: 5@8).
	
]

{ #category : #'testing-arc' }
DrGeoScriptTest >> testArcUnicity [
	| arc1 arc2 a b c |
	a := sketch point: 788@985.
	b := sketch point: 700@980.
	c := sketch point: 650@900.
	arc1 := sketch arc: a to: b to: c. 
	arc2 := sketch arc: a to: b to: c.
	self assert: arc1 mathItem == arc2 mathItem.
	""
	arc2 := sketch arc: c to: b to: a.   
	self assert: arc1 mathItem == arc2 mathItem.
	""
	arc2 := sketch arc: a to: c to: b.   
	self shouldnt: arc1 mathItem == arc2 mathItem.
	""
	arc2 := sketch arc: b to: a to: c.   
	self shouldnt: arc1 mathItem == arc2 mathItem.
]

{ #category : #'testing-circle' }
DrGeoScriptTest >> testCircle [
	| c|
	c := sketch circleCenter: (sketch point: 3@2) to: (sketch point: 6@6).
	self assert: c mathItem isCircleItem.
	self assert: c mathItem isGeometricItem.
	self assert: c mathItem isCurveItem.
	""
	self should: (c mathItem radius closeTo: 5).
	self should: (c mathItem center = (3@2)).
	self should: (c mathItem contains: 8@2)	
]

{ #category : #'testing-circle' }
DrGeoScriptTest >> testCircleRadius [
	| c |
	c := sketch circleCenter: (sketch point: 3@2) radius: (sketch freeValue: 5).
	self assert: c mathItem isCircleItem.
	self assert: c mathItem isGeometricItem.
	self assert: c mathItem isCurveItem.
	""
	self should: (c mathItem radius closeTo: 5).
	self should: (c mathItem center = (3@2)).
	self should: (c mathItem contains: 8@2)	
]

{ #category : #'testing-circle' }
DrGeoScriptTest >> testCircleRadiusUnicity [
	| a r c1 c2|
	a := sketch point: 788@985.
	r := sketch freeValue: 5.
	c1 := sketch circleCenter: a radius: r.   
	c2 := sketch circleCenter: a radius: r.  
	self assert: c1 mathItem == c2 mathItem.
	""
	r := sketch freeValue: 5.
	c2 := sketch circleCenter: a radius: r.  
	self shouldnt: c1 mathItem == c2 mathItem.
]

{ #category : #'testing-circle' }
DrGeoScriptTest >> testCircleReflexion [
	| d c1 c2|
	d := sketch line: 0@0 to: 1@2.
	c1 := sketch circleCenter: 1@0 to: 6@0.
	c2 := sketch reflect: c1 axis: d.
	""
	self assert: c2 mathItem isCircleItem.
	self assert: c2 mathItem isGeometricItem.
	self assert: c2 mathItem isCurveItem.
	""
	self should: (c2 mathItem radius closeTo: 5).
	self should: (c2 mathItem center closeTo: (-0.6@0.8)).	
	
]

{ #category : #'testing-circle' }
DrGeoScriptTest >> testCircleRotation [
	| c1 c2|
	c1 := sketch circleCenter: 3@2 to: 3@12.
	c2 := sketch rotate: c1 center: 1@1 angle: Float pi / 3.
	""
	self assert: c2 mathItem isCircleItem.
	self assert: c2 mathItem isGeometricItem.
	self assert: c2 mathItem isCurveItem.
	""
	self should: (c2 mathItem radius closeTo: 10).
	self should: (c2 mathItem center closeTo: 1.13397@3.23205).	
	
]

{ #category : #'testing-circle' }
DrGeoScriptTest >> testCircleScale [
	| c1 c2|
	c1 := sketch circleCenter: 3@2 to: 3@12.
	c2 := sketch scale: c1 center: 1@1 factor: 3.
	""
	self assert: c2 mathItem isCircleItem.
	self assert: c2 mathItem isGeometricItem.
	self assert: c2 mathItem isCurveItem.
	""
	self should: (c2 mathItem radius closeTo: 30).
	self should: (c2 mathItem center closeTo: 7@4).
	""
	c2 := sketch scale: c1 center: 1@1 factor: -3.	
	self should: (c2 mathItem radius closeTo: 30).
	self should: (c2 mathItem center closeTo: -5@ -2).
	
]

{ #category : #'testing-circle' }
DrGeoScriptTest >> testCircleSegment [
	| c|
	c := sketch circleCenter: (sketch point: 3@2) segment: (sketch segment: 10@6 to: 20@6).
	self assert: c mathItem isCircleItem.
	self assert: c mathItem isGeometricItem.
	self assert: c mathItem isCurveItem.
	""
	self should: (c mathItem radius closeTo: 10).
	self should: (c mathItem center = (3@2)).
	self should: (c mathItem contains: 13@2).
	self should: (c mathItem contains: 3@12)
]

{ #category : #'testing-circle' }
DrGeoScriptTest >> testCircleSymmetry [
	| c1 c2|
	c1 := sketch circleCenter: 3@2 to: 3@12.
	c2 := sketch symmetry: c1 center: 2@2.
	""
	self assert: c2 mathItem isCircleItem.
	self assert: c2 mathItem isGeometricItem.
	self assert: c2 mathItem isCurveItem.
	""
	self should: (c2 mathItem radius closeTo: 10).
	self should: (c2 mathItem center closeTo: 1@2).
]

{ #category : #'testing-circle' }
DrGeoScriptTest >> testCircleTranslation [
	| c1 c2|
	c1 := sketch circleCenter: 3@2 to: 3@12.
	c2 := sketch translate: c1 vector: 2@1.
	""
	self assert: c2 mathItem isCircleItem.
	self assert: c2 mathItem isGeometricItem.
	self assert: c2 mathItem isCurveItem.
	""
	self should: (c2 mathItem radius closeTo: 10).
	self should: (c2 mathItem center closeTo: 5@3).
	""
	c2 := sketch translate: c1 vector: -2@ -1.
	self should: (c2 mathItem radius closeTo: 10).
	self should: (c2 mathItem center closeTo: 1@1).

]

{ #category : #'testing-circle' }
DrGeoScriptTest >> testCircleUnicity [
	| a b c1 c2|
	a := sketch point: 788@985.
	b := sketch point: 788@1085.
	c1 := sketch circleCenter:  a to: b.
	c2 := sketch circleCenter: a to: b.  
	self assert: c1 mathItem == c2 mathItem.
	""
	c2 := sketch circleCenter: b to: a.  
	self shouldnt: c1 mathItem == c2 mathItem.
	""
	b := sketch point: 780 @ 900.
	c2 := sketch circleCenter: a to:  b.
	self shouldnt: c1 mathItem == c2 mathItem   
	
]

{ #category : #'testing-direction' }
DrGeoScriptTest >> testDirectionCollinear [
	| d1 d2|
	d1 := sketch segment: (sketch point: 5@5) to: (sketch point: 8 @7).
	d2 := sketch segment: (sketch point: 5@5) to: (sketch point: 8 @13).
	self shouldnt: (d1 mathItem isCollinearWith: d2 mathItem).
	d2 := sketch segment: (sketch point: 15@5) to: (sketch point: 18@7).
	self should: (d1 mathItem isCollinearWith: d2 mathItem).
	""
	d2 := sketch line: (sketch point: 6@5) to: (sketch point: 9@7) .
	self should: (d1 mathItem isCollinearWith: d2 mathItem)  .
	""
	d2 := sketch ray: (sketch point: 6@4) to: (sketch point: 9@6) .
	self should: (d1 mathItem isCollinearWith: d2 mathItem)  .
	""
	d2 := sketch vector: (sketch point: 3@2) to: (sketch point: 6@4) .
	self should: (d1 mathItem isCollinearWith: d2 mathItem)  

]

{ #category : #'testing-direction' }
DrGeoScriptTest >> testDirectionDirection [
	| d n v |
	d := sketch segment: (sketch point: 5@5) to: (sketch point: 8 @7).
	v := d mathItem direction.
	self should: v = (3@2).
	n := d mathItem normal.
	self should: ((n dotProduct:  v) closeTo: 0).
	self should: (n x * n x + (n y * n y) closeTo: 1)  
]

{ #category : #'testing-direction' }
DrGeoScriptTest >> testDirectionIntersection [
	| d1 d2|
	d1 := sketch segment: (sketch point: -5@ -5) to: (sketch point: 5 @5).
	d2 := sketch segment: (sketch point: -5@5) to: (sketch point: 5@ -5).
	"only test if not collinenear in fact"
	self should: (((d1 mathItem intersectionWithDirection: d2 mathItem) closeTo: 0@0)).
	""
	d2 := sketch segment: (sketch point: -4@ -5) to: (sketch point: 6@ 5).
	self assert: (d1 mathItem intersectionWithDirection: d2 mathItem) isNil
]

{ #category : #'testing-value' }
DrGeoScriptTest >> testDistancePointLine [
	| distance a d recomputed|
	a := sketch point: 10@15.
	d := sketch line: -5 @ -5 to: 2@3.
	distance := sketch distance: a to: d.
	recomputed := ((10@15 - (-5 @ -5)) dotProduct: (d mathItem normal)) abs.
	self should: (distance mathItem valueItem closeTo: recomputed).
]

{ #category : #'testing-value' }
DrGeoScriptTest >> testDistancePoints [
	| distance a b |
	a := sketch point: 10@15.
	b := sketch point: -5 @ -5.
	distance := sketch distance: a to: b.
	self should: (distance mathItem valueItem closeTo: (400 + 225) sqrt).
]

{ #category : #'testing-value' }
DrGeoScriptTest >> testLengthArc [
	| length arc |
	arc := sketch arc: 8@2 to: 6@6 to: 3@7.
	length := sketch lengthOf: arc.
	self should: (length mathItem valueItem closeTo: 7.853981633974483).
]

{ #category : #'testing-value' }
DrGeoScriptTest >> testLengthCircle [
	| length circle |
	circle := sketch circleCenter: 8@2 to: 6@6.
	length := sketch lengthOf: circle.
	self should: (length mathItem valueItem closeTo: 20 sqrt * 2 * Float pi).
]

{ #category : #'testing-value' }
DrGeoScriptTest >> testLengthPolygon [
	| length polygon |
	polygon := sketch regularPolygonCenter: 4@1 vertex: 3@2 sides: 4.
	length := sketch lengthOf: polygon.
	self should: (length mathItem valueItem closeTo: 8).
]

{ #category : #'testing-value' }
DrGeoScriptTest >> testLengthSegment [
	| length segment |
	segment := sketch segment: 8@2 to: 6@6.
	length := sketch lengthOf: segment.
	self should: (length mathItem valueItem closeTo: 20 sqrt).
]

{ #category : #'testing-value' }
DrGeoScriptTest >> testLengthVector [
	| length vector |
	vector := sketch segment: 8@2 to: 6@6.
	length := sketch lengthOf: vector.
	self should: (length mathItem valueItem closeTo: 20 sqrt).
]

{ #category : #'testing-line' }
DrGeoScriptTest >> testLine [
	| a b l|
	a := sketch point: 88@985.
	b := sketch point: 98@1085.
	l := sketch line: a to: b.
	self assert: l mathItem isCurveItem.
	self assert: l mathItem isGeometricItem.
	self assert: l mathItem isDirectionItem.
	self assert: l mathItem isLineItem.
	""
	self should: (l mathItem contains: 89@995).
	self should: (l mathItem contains: 87@975).
	self should: (l mathItem contains: 188@1985).
	self shouldnt: (l mathItem contains: 5 @4)    
]

{ #category : #'testing-line' }
DrGeoScriptTest >> testLineReflexion [
	| axe l1 l2  |
	axe := sketch line: (sketch point: 0 @ 0) to: (sketch point: 1 @ 2).
	""
	l1 := sketch line: (sketch point: 3@2) to: (sketch point: 2@4).
	l2 := sketch reflect: l1 axis: axe.
	self assert:(l2 mathItem origin closeTo:  -0.2@3.6).
	self assert: (l2 mathItem direction closeTo: 2.2@0.4)  

]

{ #category : #'testing-line' }
DrGeoScriptTest >> testLineRotation [
	| l1 l2 c k |
	c := sketch point: 1 @ 1.
	k := sketch freeValue: Float pi / 3.
	""
	l1 := sketch line: (sketch point: 3@2) to: (sketch point: 2@4).
	l2 := sketch rotate: l1 center: c angle: k.
	self assert:( l2 mathItem origin closeTo:  1.13397@3.23205).
	self assert: (l2 mathItem direction closeTo: -2.23205@0.133974)  

]

{ #category : #'testing-line' }
DrGeoScriptTest >> testLineScale [
	| l1 l2 c k |
	c := sketch point: 1 @ 1.
	k := sketch freeValue: 3.
	""
	l1 := sketch line: (sketch point: 3@2) to: (sketch point: 2@4).
	l2 := sketch scale: l1 center: c factor: k.
	self assert: (l2 mathItem origin closeTo: 7@4).
	self assert: (l2 mathItem direction = (l1 mathItem direction * 3)).
	""
	k := sketch freeValue: -3.
	l2 := sketch scale: l1 center: c factor: k.
	self assert: (l2 mathItem origin closeTo: -5@ -2).
	self assert: (l2 mathItem direction = (l1 mathItem direction * -3))  

]

{ #category : #'testing-line' }
DrGeoScriptTest >> testLineSymmetry [
	| c l1 l2|
	c := sketch point: 2@2.
	""
	l1 := sketch line: (sketch point: 3@2) to: (sketch point: 2@4).
	l2 := sketch symmetry: l1 center:  c.
	self assert: l2 mathItem origin = (1@2).
	self assert: l2 mathItem direction = l1 mathItem direction negated 

]

{ #category : #'testing-line' }
DrGeoScriptTest >> testLineTranslation [
	| l1 l2 t |
	l1 := sketch line: (sketch point: 3@2) to: (sketch point: 2@4).
	t := sketch vector: (sketch point: 1@1) to: (sketch point: 3@2).
	""
	l2 := sketch translate: l1 vector:  t.  
	self assert: l2 mathItem origin = (5@3).
	self assert: l2 mathItem direction = l1 mathItem direction.
	""  
	t := sketch vector: (sketch point: 3@2) to: (sketch point: 1@1).
	l2 := sketch translate: l1 vector:  t.  
	self assert: l2 mathItem origin = (1@1).
	self assert: l2 mathItem direction = l1 mathItem direction.

]

{ #category : #'testing-line' }
DrGeoScriptTest >> testLineUnicity [
	| a b s1 s2|
	a := sketch point: 788@985.
	b := sketch point: 788@1085.
	s1 := sketch line: a to: b.
	s2 := sketch line: a to: b.  
	self assert: s1 mathItem == s2 mathItem.
	"Lines are oriented"
	s2 := sketch line: b to: a.  
	self shouldnt: s1 mathItem == s2 mathItem.
	""
	b := sketch point: 780 @ 900.
	s2 := sketch line: a to:  b.
	self shouldnt: s1 mathItem == s2 mathItem   
	
]

{ #category : #'testing-value' }
DrGeoScriptTest >> testOrdianteOfPoint [
	| coordinate point |
	point := sketch point: 10@15.
	coordinate := sketch ordinateOf: point.
	self should: (coordinate mathItem valueItem closeTo: 15).
]

{ #category : #'testing-value' }
DrGeoScriptTest >> testOrdianteOfVector [
	| coordinate vector |
	vector := sketch vector: 10@15.
	coordinate := sketch ordinateOf: vector.
	self should: (coordinate mathItem valueItem closeTo: 15).
]

{ #category : #'testing-line' }
DrGeoScriptTest >> testParallelLine [
	| l p |
	l := sketch line: (sketch point: 3@2) to: (sketch point: 2@4).
	p := sketch parallel: l at: 2@2.
	""
	self assert: (p mathItem contains: 2@2).
	self assert: ((p mathItem direction crossProduct: l mathItem direction) closeTo: 0).
	""  

]

{ #category : #'testing-line' }
DrGeoScriptTest >> testParallelRay [
	| r p |
	r := sketch ray: (sketch point: 3@2) to: (sketch point: 2@4).
	p := sketch parallel: r at: 2@2.
	""
	self assert: (p mathItem contains: 2@2).
	self assert: ((p mathItem direction crossProduct: r mathItem direction) closeTo: 0).
	""  

]

{ #category : #'testing-line' }
DrGeoScriptTest >> testParallelSegment [
	| s p |
	s := sketch segment: (sketch point: 3@2) to: (sketch point: 2@4).
	p := sketch parallel: s at: 2@2.
	""
	self assert: (p mathItem contains: 2@2).
	self assert: ((p mathItem direction crossProduct: s mathItem direction) closeTo: 0).
	""  

]

{ #category : #'testing-line' }
DrGeoScriptTest >> testPerpendicularBisector [
	| s p |
	s := sketch segment: (sketch point: 3@2) to: (sketch point: 2@4).
	p := sketch perpendicularBisector: s.
	""
	self assert: (p mathItem contains: (3@2 + (2@4) / 2)).
	self assert: ((p mathItem direction dotProduct: s mathItem direction) closeTo: 0).

]

{ #category : #'testing-line' }
DrGeoScriptTest >> testPerpendicularBisector2Points [
	| p |
	p := sketch perpendicularBisector: 3@2 to: 2@4.
	""
	self assert: (p mathItem contains: (3@2 + (2@4) / 2)).
	self assert: ((p mathItem direction dotProduct: (2@4 - (3@2))) closeTo: 0).

]

{ #category : #'testing-line' }
DrGeoScriptTest >> testPerpendicularLine [
	| l p |
	l := sketch line: (sketch point: 3@2) to: (sketch point: 2@4).
	p := sketch perpendicular: l at: 2@2.
	""
	self assert: (p mathItem contains: 2@2).
	self assert: ((p mathItem direction dotProduct: l mathItem direction) closeTo: 0).
	""  

]

{ #category : #'testing-line' }
DrGeoScriptTest >> testPerpendicularRay [
	| r p |
	r := sketch ray: (sketch point: 3@2) to: (sketch point: 2@4).
	p := sketch perpendicular: r at: 2@2.
	""
	self assert: (p mathItem contains: 2@2).
	self assert: ((p mathItem direction dotProduct: r mathItem direction) closeTo: 0).

]

{ #category : #'testing-line' }
DrGeoScriptTest >> testPerpendicularSegment [
	| s p |
	s := sketch segment: (sketch point: 3@2) to: (sketch point: 2@4).
	p := sketch perpendicular: s at: 2@2.
	""
	self assert: (p mathItem contains: 2@2).
	self assert: ((p mathItem direction dotProduct: s mathItem direction) closeTo: 0).

]

{ #category : #'testing-point' }
DrGeoScriptTest >> testPointByCoordinates [
	|x y p|
	x := sketch freeValue: 12.
	y := sketch freeValue: -18.
	p := sketch pointX: x Y: y.
	self assert: p coordinates = (12 @ -18)   
]

{ #category : #'testing-point' }
DrGeoScriptTest >> testPointByCoordinatesUnicity [
	|x y p q|
	x := sketch freeValue: 12.
	y := sketch freeValue: -18.
	p := sketch pointX: x Y: y.
	q := sketch pointX: x Y: y.
	self should: p mathItem == q mathItem.
	q := sketch pointX: x Y:  (sketch freeValue: -18.1).
	self shouldnt: p mathItem == q mathItem    
]

{ #category : #'testing-point' }
DrGeoScriptTest >> testPointFree [
	| a b |
	a := sketch point: 55 @ 5.
	self assert: a coordinates = (55 @ 5).
	b := sketch point: -35 @ -45.
	self assert: b coordinates = (-35 @ -45).

]

{ #category : #'testing-point' }
DrGeoScriptTest >> testPointFreeUnicity [
	| a b |
	a := sketch point: 788@985.
	b := sketch point: 788@985.
	self assert: a mathItem == b mathItem.
	""
	b := sketch point: 788 @ 986.
	b moveTo: 788@985.
	sketch update.  
	self shouldnt: a mathItem == b mathItem.
	self should: a coordinates = b coordinates.
]

{ #category : #'testing-point' }
DrGeoScriptTest >> testPointMiddle [
	| a b m s |
	a := sketch point: 5 @ 5.
	b := sketch point: -5 @ -5.
	m := sketch middleOf: a and: b.
	self assert: m coordinates = (0 @ 0).
	b := sketch point: -13 @ 8.
	m := sketch middleOf: a and: b.
	self assert: m coordinates = (-4 @ (13 / 2)).
	s := sketch
				segment: (sketch point: 8 @ 7)
				to: (sketch point: -15 @ -10).
	m := sketch middleOf: s.
	self assert: m coordinates = (-7 / 2 @ (-3 / 2))
]

{ #category : #'testing-point' }
DrGeoScriptTest >> testPointMiddleUnicity [
	| a b s p q |
	a := sketch point: 5 @ 5.
	b := sketch point: -5 @ -5.
	p := sketch middleOf: a and: b.
	q := sketch middleOf: a and: b.
	self should: p mathItem == q mathItem.
	q := sketch middleOf: b and: a.
	self should: p mathItem == q mathItem.
	""
	s := sketch	segment: (sketch point: 8 @ 7) to: (sketch point: -15 @ -10).
	p := sketch middleOf: s.
	q := sketch middleOf: s.
	self should: p mathItem == q mathItem  
]

{ #category : #'testing-point' }
DrGeoScriptTest >> testPointOnArc [
	| a b c curve p |
	a := sketch point: -5 @ 0.
	b := sketch point: 0 @ 5.
	c := sketch point: 5 @ 0.
	curve := sketch arc: a to: b to: c.
	""
	p := sketch pointOnLine: curve at: 0.
	self assert: (p coordinates closeTo: -5 @ 0).
	""
	p mathItem setCurveAbscissa: 0.5.
	self assert: (p coordinates closeTo: 0 @ 5).
	""
	p mathItem setCurveAbscissa: 1.
	self assert: (p coordinates closeTo: 5 @ 0).
	""
	p mathItem setCurveAbscissa: 1/3  .
	self assert: (p coordinates closeTo: -2.5 @ 4.3301)
]

{ #category : #'testing-point' }
DrGeoScriptTest >> testPointOnArcUnicity [
	| a b c curve p q|
	a := sketch point: -5 @ 0.
	b := sketch point: 0 @ 5.
	c := sketch point: 5 @ 0.
	curve := sketch arc: a to: b to: c.
	""
	p := sketch pointOnLine: curve at: 0.9.
	q := sketch pointOnLine: curve at: 0.9.
	self should: p mathItem == q mathItem.
	""  
	q := sketch pointOnLine: curve at: 0.89.
	self shouldnt: p mathItem == q mathItem   

]

{ #category : #'testing-point' }
DrGeoScriptTest >> testPointOnCircle [
	| a b curve p |
	a := sketch point: -5 @ -5.
	b := sketch point: 0 @ -5.
	curve := sketch circleCenter: a to: b.
	""
	p := sketch pointOnLine: curve at: 0.
	self assert: (p coordinates closeTo: 0 @ -5).
	""
	p := sketch pointOnLine: curve at: 1/4.
	self assert: (p coordinates closeTo: -5 @ 0).
	""
	p := sketch pointOnLine: curve at: 1/2.
	self assert: (p coordinates closeTo: -10 @ -5).
	""
	p := sketch pointOnLine: curve at: 3/4.
	self assert: (p coordinates closeTo: -5 @ -10).
	""
	p := sketch pointOnLine: curve at: 3/8.
	self assert: (p coordinates closeTo: -8.5355 @ -1.4645).

]

{ #category : #'testing-point' }
DrGeoScriptTest >> testPointOnCircleUnicity [
	| a b curve p q |
	a := sketch point: -5 @ -5.
	b := sketch point: 0 @ -5.
	curve := sketch circleCenter: a to: b.
	""
	p := sketch pointOnLine: curve at: 0.4.
	q := sketch pointOnLine: curve at: 0.4.
	self should: p mathItem == q mathItem.
	""
	q := sketch pointOnLine: curve at: 0.41.
	self shouldnt: p mathItem == q mathItem  


]

{ #category : #'testing-point' }
DrGeoScriptTest >> testPointOnLine [
	| a b curve p |
	a := sketch point: -15 @ -45.
	b := sketch point: -13 @ -44.
	curve := sketch line: a to: b.
	p := sketch pointOnLine: curve at: 0.35.
	self
		assert: (p coordinates closeTo: -15.4557 @ -45.2279)
]

{ #category : #'testing-point' }
DrGeoScriptTest >> testPointOnLineUnicity [
	| a b curve p q|
	a := sketch point: -15 @ -45.
	b := sketch point: -13 @ -44.
	curve := sketch line: a to: b.
	p := sketch pointOnLine: curve at: 0.35.
	q := sketch pointOnLine: curve at: 0.35.
	self should: p mathItem == q mathItem.
	""
	q := sketch pointOnLine: curve at: 0.34.
	self shouldnt: p mathItem == q mathItem.

]

{ #category : #'testing-point' }
DrGeoScriptTest >> testPointOnRay [
	| a b curve p |
	a := sketch point: -15 @ -45.
	b := sketch point: -13 @ -44.
	curve := sketch ray: a to: b.
	p := sketch pointOnLine: curve at: 0.
	self assert: p coordinates = (-15 @ -45).
	""
	p mathItem setCurveAbscissa: 0.5.
	self
		assert: (p coordinates closeTo: -14.1056 @ -44.5528)
]

{ #category : #'testing-point' }
DrGeoScriptTest >> testPointOnRayUnicity [
	| a b curve p q|
	a := sketch point: -15 @ -45.
	b := sketch point: -13 @ -44.
	curve := sketch ray: a to: b.
	p := sketch pointOnLine: curve at: 0.21.
	q := sketch pointOnLine: curve at: 0.21.
	self should: p mathItem == q mathItem.
	""
	q := sketch pointOnLine: curve at: 0.22.
	self shouldnt: p mathItem == q mathItem   
]

{ #category : #'testing-point' }
DrGeoScriptTest >> testPointOnSegment [
	| a b curve p |
	a := sketch point: -5 @ -5.
	b := sketch point: 5 @ 5.
	curve := sketch segment: a to: b.
	p := sketch pointOnLine: curve at: 0.
	self assert: p coordinates = (-5 @ -5).
	p mathItem setCurveAbscissa: 1.
	self assert: p coordinates = (5 @ 5).
	p mathItem setCurveAbscissa: 0.5.
	self assert: p coordinates = (0 @ 0).
	p mathItem setCurveAbscissa: 1 / 3.
	self assert: p coordinates = (-5 / 3 @ (-5 / 3)).
	""
	a mathItem moveTo: 0 @ 0.
	sketch update.
	self assert: p coordinates = (5 / 3 @ (5 / 3)).
	""  
]

{ #category : #'testing-point' }
DrGeoScriptTest >> testPointOnSegmentUnicity [
	| a b curve p q |
	a := sketch point: -25 @ -5.
	b := sketch point: 25 @ 5.
	curve := sketch segment: a to: b.
	p := sketch pointOnLine: curve at: 0.7.
	q := sketch pointOnLine: curve at: 0.7.
	self should: p mathItem == q mathItem.
	q := sketch pointOnLine: curve at: 0.71.
	self shouldnt: p mathItem = q mathItem   
]

{ #category : #'testing-point' }
DrGeoScriptTest >> testPointReflexion [
	| d a b|
	d := sketch line: (sketch point: 0@0) to: (sketch point: 1@2).
	""
	a := sketch point: 1@0.
	b := sketch reflect: a axis: d.  
	self assert: (b coordinates closeTo: -0.6@0.8).
	""
	a := sketch point: 1@2.
	b := sketch reflect: a axis: d.  
	self assert: (b coordinates = (1@2)).
	""
	a := sketch point: 0@3.
	b := sketch reflect: a axis: d.  
	self assert: (b coordinates closeTo:  2.4@1.8).

]

{ #category : #'testing-point' }
DrGeoScriptTest >> testPointRotation [
	| c v a b|
	c := sketch point: 1@1.
	v := sketch freeValue: Float pi / 3.  
	""
	a := sketch point: 2@1.
	b := sketch rotate: a center: c angle: v.
	self assert: (b coordinates closeTo: 1.5@1.8660).
	""
	v := sketch freeValue:  (Float pi / 3) negated.  
	b := sketch rotate: a center: c angle: v.
	self assert: (b coordinates closeTo: 1.5@0.13397).

]

{ #category : #'testing-point' }
DrGeoScriptTest >> testPointScale [
	| c k a b|
	c := sketch point: 1@1.
	k := sketch freeValue: 3.  
	""
	a := sketch point: 2@1.
	b := sketch scale: a center: c factor: k.
	self assert: b coordinates = (4@1).
	""
	a := sketch point: 3@2.
	b := sketch scale: a center: c factor: k.
	self assert: b coordinates = (7@4).
	""
	a := sketch point: 2@1.
	k := sketch freeValue: -3.  
	b := sketch scale: a center: c factor: k.
	self assert: b coordinates = (-2@1).
	""
	a := sketch point: 3@2.
	b := sketch scale: a center: c factor: k.
	self assert: b coordinates = (-5@ -2).

]

{ #category : #'testing-point' }
DrGeoScriptTest >> testPointSymmetry [
	| c a b|
	c := sketch point: 2@2.
	""
	a := sketch point: 4@2.
	b := sketch symmetry: a center:  c.
	self assert: b coordinates = (0@2).
	""
	a := sketch point: 4@3.
	b := sketch symmetry: a center:  c.
	self assert: b coordinates = (0@1).
	""
	a := sketch point: 4@4.
	b := sketch symmetry: a center:  c.
	self assert: b coordinates = (0@0)
]

{ #category : #'testing-point' }
DrGeoScriptTest >> testPointTranslation [
	| u a|
	u := sketch vector: (sketch point: 1@1) to: (sketch point: 3@2).
	a := sketch translate: (sketch point: 2@1) vector: u.
	self assert: a coordinates = (4@2).
	""
	u := sketch vector: (sketch point: 3@2) to: (sketch point: 1@1).
	a := sketch translate: (sketch point: 2@1) vector: u.
	self assert: a coordinates = (0@0).

]

{ #category : #'testing-polygon' }
DrGeoScriptTest >> testPolygon [
	| polygon summit |
	summit := Array withAll: {
		sketch point: -3@ -3.
		sketch point: -3@3.
		sketch point: 3@3.
		sketch point: 3@ -3}.
	polygon := sketch polygon: summit.
	self assert: polygon mathItem isGeometricItem.
	self assert: polygon mathItem isPolygonItem. 
	self assert: polygon mathItem isCurveItem.
	self should: polygon mathItem length = 24.  
]

{ #category : #'testing-polygon' }
DrGeoScriptTest >> testPolygonReflexion [
	| p1 p2 |
	p1 := sketch regularPolygonCenter: 3@2 vertex: 2@4 sides: 4.
	p2 := sketch reflect: p1 axis: (sketch line: 0@0 to: 1@2).
	""
	self should: (p2 mathItem length closeTo: 4 * 10 sqrt).
	self should: p2 mathItem points size = 4.
	self should: (p2 mathItem points anySatisfy: [:aPoint | aPoint closeTo: -2.4@3.2]).

]

{ #category : #'testing-polygon' }
DrGeoScriptTest >> testPolygonRegular [
	| polygon vertices|
	"Test a square as a regular polygon"
	polygon := sketch regularPolygonCenter: 1@1 vertex: 0@2 sides: 4.
	self assert: polygon mathItem isGeometricItem.
	self assert: polygon mathItem isPolygonItem. 
	self assert: polygon mathItem isCurveItem.
	self should: polygon mathItem length = 8.
	""
	vertices := polygon mathItem points.
	self should: vertices size = 4.
	self should: (vertices anySatisfy: [:aPoint | aPoint closeTo: 0@2]).
	self should: (vertices anySatisfy: [:aPoint | aPoint closeTo: 2@2]).
	self should: (vertices anySatisfy: [:aPoint | aPoint closeTo: 2@0]).
	self should: (vertices anySatisfy: [:aPoint | aPoint closeTo: 0@0]).
	""
	polygon := sketch regularPolygonCenter: 3@2 vertex: 2@4 sides: 4.
	self should: (polygon mathItem length closeTo: 4 * 10 sqrt).
	vertices := polygon mathItem points.
	self should: (vertices anySatisfy: [:aPoint | aPoint closeTo: 2@4]).
	self should: (vertices anySatisfy: [:aPoint | aPoint closeTo: 5@3]).
	self should: (vertices anySatisfy: [:aPoint | aPoint closeTo: 4@0]).
	self should: (vertices anySatisfy: [:aPoint | aPoint closeTo: 1@1]).
]

{ #category : #'testing-polygon' }
DrGeoScriptTest >> testPolygonRotation [
	| p1 p2 |
	p1 := sketch regularPolygonCenter: 4@1 vertex: 3@2 sides: 4.
	p2 := sketch rotate: p1 center: 1@1 angle: Float pi / 3.
	""
	self should: (p2 mathItem length closeTo: 8).
	self should: p2 mathItem points size = 4.
	self should: (p2 mathItem points anySatisfy: [:aPoint | aPoint closeTo: 1.13397@3.23205]).

]

{ #category : #'testing-polygon' }
DrGeoScriptTest >> testPolygonSymmetry [
	| p1 p2 |
	p1 := sketch regularPolygonCenter: 4@1 vertex: 3@2 sides: 4.
	p2 := sketch symmetry: p1 center: 2@2.
	""
	self should: (p2 mathItem length closeTo: 8).
	self should: p2 mathItem points size = 4.
	self should: (p2 mathItem points anySatisfy: [:aPoint | aPoint closeTo: 1@2]).

]

{ #category : #'testing-polygon' }
DrGeoScriptTest >> testPolygonTranslation [
	| p1 p2 |
	p1 := sketch regularPolygonCenter: 4@1 vertex: 3@2 sides: 4.
	p2 := sketch translate: p1 vector: 2@1.
	""
	self should: (p2 mathItem length closeTo: 8).
	self should: p2 mathItem points size = 4.
	self should: (p2 mathItem points anySatisfy: [:aPoint | aPoint closeTo: 5@3]).

]

{ #category : #'testing-polygon' }
DrGeoScriptTest >> testPolygonUnicity [
	| p1 p2 summit |
	summit := Array withAll: {
		sketch point: -3@ -3.
		sketch point: -3@3.
		sketch point: 3@3.
		sketch point: 3@ -3}.
	p1 := sketch polygon: summit.
	summit := Array withAll: {
		sketch point: 3@ -3.
		sketch point: -3@ -3.
		sketch point: -3@3.
		sketch point: 3@3}.
	p2 := sketch polygon: summit.
	"we not handle polygon unicity yet"
	self deny: p1 mathItem == p2 mathItem.
	""
	summit := Array withAll: {
		sketch point: -3@3.
		sketch point: -3@ -3.
		sketch point: 3@3.
		sketch point: 3@ -3}.
	p2 := sketch polygon: summit.
	self deny: p1 mathItem == p2 mathItem   
]

{ #category : #'testing-ray' }
DrGeoScriptTest >> testRay [
	| a b r|
	a := sketch point: 88@985.
	b := sketch point: 98@1085.
	r := sketch ray: a to: b.
	self assert: r mathItem isCurveItem.
	self assert: r mathItem isGeometricItem.
	self assert: r mathItem isDirectionItem.
	self assert: r mathItem isRayItem.
	""
	self should: (r mathItem contains: 89@995).
	self should: (r mathItem contains: 188@1985).
	self shouldnt: (r mathItem contains: 87@975).
	self shouldnt: (r mathItem contains: 5 @4)
]

{ #category : #'testing-ray' }
DrGeoScriptTest >> testRayReflexion [
	| axe r1 r2  |
	axe := sketch line: (sketch point: 0 @ 0) to: (sketch point: 1 @ 2).
	""
	r1 := sketch ray: (sketch point: 3@2) to: (sketch point: 2@4).
	r2 := sketch reflect: r1 axis: axe.
	self assert:(r2 mathItem origin closeTo:  -0.2@3.6).
	self assert: (r2 mathItem direction closeTo: 2.2@0.4)  

]

{ #category : #'testing-ray' }
DrGeoScriptTest >> testRayRotation [
	| r1 r2 c k |
	c := sketch point: 1 @ 1.
	k := sketch freeValue: Float pi / 3.
	""
	r1 := sketch ray: 3@2 to: 2@4.
	r2 := sketch rotate: r1 center: c angle: k.
	self assert:(r2 mathItem origin closeTo:  1.13397@3.23205).
	self assert: (r2 mathItem direction closeTo: -2.23205@0.133974)  

]

{ #category : #'testing-ray' }
DrGeoScriptTest >> testRayScale [
	| r1 r2 c k |
	c := sketch point: 1 @ 1.
	k := sketch freeValue: 3.
	""
	r1 := sketch ray: (sketch point: 3@2) to: (sketch point: 2@4).
	r2 := sketch scale: r1 center: c factor: k.
	self assert: (r2 mathItem origin closeTo: 7@4).
	self assert: (r2 mathItem direction = (r1 mathItem direction * 3)).
	""
	k := sketch freeValue: -3.
	r2 := sketch scale: r1 center: c factor: k.
	self assert: (r2 mathItem origin closeTo: -5@ -2).
	self assert: (r2 mathItem direction = (r1 mathItem direction * -3))  

]

{ #category : #'testing-ray' }
DrGeoScriptTest >> testRaySymmetry [
	| c r1 r2|
	c := sketch point: 2@2.
	""
	r1 := sketch ray: (sketch point: 3@2) to: (sketch point: 2@4).
	r2 := sketch symmetry: r1 center:  c.
	self assert: r2 mathItem origin = (1@2).
	self assert: r2 mathItem direction = r1 mathItem direction negated 

]

{ #category : #'testing-ray' }
DrGeoScriptTest >> testRayTranslation [
	| r1 r2 t |
	r1 := sketch ray: (sketch point: 3@2) to: (sketch point: 2@4).
	t := sketch vector: (sketch point: 1@1) to: (sketch point: 3@2).
	""
	r2 := sketch translate: r1 vector:  t.  
	self assert: r2 mathItem origin = (5@3).
	self assert: r2 mathItem direction = r1 mathItem direction.
	""  
	t := sketch vector: (sketch point: 3@2) to: (sketch point: 1@1).
	r2 := sketch translate: r1 vector:  t.  
	self assert: r2 mathItem origin = (1@1).
	self assert: r2 mathItem direction = r1 mathItem direction.

]

{ #category : #'testing-ray' }
DrGeoScriptTest >> testRayUnicity [
	| a b s1 s2|
	a := sketch point: 788@985.
	b := sketch point: 788@1085.
	s1 := sketch ray: a to: b.
	s2 := sketch ray: a to: b.  
	self assert: s1 mathItem == s2 mathItem.
	""
	s2 := sketch ray: b to: a.  
	self shouldnt: s1 mathItem == s2 mathItem.
	""
	b := sketch point: 780 @ 900.
	s2 := sketch ray: a to:  b.
	self shouldnt: s1 mathItem == s2 mathItem   
	
]

{ #category : #'testing-segment' }
DrGeoScriptTest >> testSegment [
	| a b s|
	a := sketch point: 88@985.
	b := sketch point: 98@1085.
	s := sketch segment: a to: b.
	self assert: s mathItem isCurveItem.
	self assert: s mathItem isGeometricItem.
	self assert: s mathItem isDirectionItem.
	self assert: s mathItem isSegmentItem.
	""
	self should: (s mathItem contains: 89@995).
	self shouldnt: (s mathItem contains: 87@975).
	self shouldnt: (s mathItem contains: 188@1095).
	self shouldnt: (s mathItem contains: 5 @4)    
]

{ #category : #'testing-segment' }
DrGeoScriptTest >> testSegmentReflexion [
	| d u v|
	d := sketch
				line: (sketch point: 0 @ 0)
				to: (sketch point: 1 @ 2).
	""
	u := sketch segment: (sketch point: 3@2) to: (sketch point: 2@4).
	v := sketch reflect: u axis:  d.
	self assert:( v mathItem origin closeTo:  -0.2@3.6).
	self assert: (v mathItem direction closeTo: 2.2@0.4)  

]

{ #category : #'testing-segment' }
DrGeoScriptTest >> testSegmentRotation [
	| u v c k |
	c := sketch point: 1 @ 1.
	k := sketch freeValue: Float pi / 3.
	""
	u := sketch segment: (sketch point: 3@2) to: (sketch point: 2@4).
	v := sketch rotate: u center: c angle: k.
	self assert:( v mathItem origin closeTo:  1.13397@3.23205).
	self assert: (v mathItem direction closeTo: -2.23205@0.133974)  

]

{ #category : #'testing-segment' }
DrGeoScriptTest >> testSegmentScale [
	| u v c k |
	c := sketch point: 1 @ 1.
	k := sketch freeValue: 3.
	""
	u := sketch segment: (sketch point: 3@2) to: (sketch point: 2@4).
	v := sketch scale: u center: c factor: k.
	self assert: (v mathItem origin closeTo: 7@4).
	self assert: (v mathItem direction = (u mathItem direction * 3)). 
	""
	k := sketch freeValue: -3.
	v := sketch scale: u center: c factor: k.
	self assert: (v mathItem origin closeTo: -5@ -2).
	self assert: (v mathItem direction = (u mathItem direction * -3))  

]

{ #category : #'testing-segment' }
DrGeoScriptTest >> testSegmentSymmetry [
	| c u v|
	c := sketch point: 2@2.
	""
	u := sketch segment: (sketch point: 3@2) to: (sketch point: 2@4).
	v := sketch symmetry: u center:  c.
	self assert: v mathItem origin = (1@2).
	self assert: v mathItem direction = u mathItem direction negated 

]

{ #category : #'testing-segment' }
DrGeoScriptTest >> testSegmentTranslation [
	| u v t |
	u := sketch segment: (sketch point: 3@2) to: (sketch point: 2@4).
	t := sketch vector: (sketch point: 1@1) to: (sketch point: 3@2).
	""
	v := sketch translate: u vector:  t.  
	self assert: v mathItem origin = (5@3).
	self assert: v mathItem direction = u mathItem direction.
	""  
	t := sketch vector: (sketch point: 3@2) to: (sketch point: 1@1).
	v := sketch translate: u vector:  t.  
	self assert: v mathItem origin = (1@1).
	self assert: v mathItem direction = u mathItem direction.

]

{ #category : #'testing-segment' }
DrGeoScriptTest >> testSegmentUnicity [
	| a b s1 s2|
	a := sketch point: 788@985.
	b := sketch point: 788@1085.
	s1 := sketch segment: a to: b.
	"s2 := canvas segment: a to: b.  
	self assert: s1 mathItem == s2 mathItem."
	""
	s2 := sketch segment: b to: a.  
	self assert: s1 mathItem == s2 mathItem.
	""
	b := sketch point: 780 @ 901.
	s2 := sketch segment: a to:  b.
	self deny: s1 mathItem == s2 mathItem   
	
]

{ #category : #'testing-value' }
DrGeoScriptTest >> testSlope [
	| slope recomputed|
	slope := sketch slopeOf: (sketch line: -5 @ -5 to: 2@3).
	recomputed := (3 - -5) / (2 - -5).
	self should: (slope mathItem valueItem closeTo: recomputed).
]

{ #category : #'testing-value' }
DrGeoScriptTest >> testValueFree [
	| v |
	v := sketch freeValue: Float pi / 3.  
	self assert: (v mathItem valueItem closeTo: Float pi / 3).
	""
	v := sketch freeValue: 0.00001.  
	self assert: (v mathItem valueItem closeTo: 0.00001).

]

{ #category : #'testing-vector' }
DrGeoScriptTest >> testVector [
	| a b v|
	a := sketch point: 88@985.
	b := sketch point: 98@1085.
	v := sketch vector: a to: b.
	self deny: v mathItem isCurveItem.
	self assert: v mathItem isGeometricItem.
	self assert: v mathItem isDirectionItem.
	self assert: v mathItem isVectorItem.
	self deny: v mathItem isSegmentItem.
	""
	self should: (v mathItem direction = (10@100)).
	""
	v mathItem move: 5@4;
		update.
	self should: v mathItem direction = (10@100).
 
]

{ #category : #'testing-vector' }
DrGeoScriptTest >> testVectorUnicity [
	| a b v u|
	a := sketch point: 2@5.
	b := sketch point: 4@8.
	u := sketch vector: a to: b.
	v := sketch vector: a to: b.
	self assert: u mathItem == v mathItem.
	""  
	v := sketch vector: b to: a.
	self deny: u mathItem == v mathItem.
	""
	a := sketch point: -4@ -5.
	b := sketch point: -2@ -2.
	v := sketch vector: a to: b.
	self deny: u mathItem == v mathItem.
	self assert: u mathItem direction = v mathItem direction   
]

Extension { #name : #Object }

{ #category : #'*DrGeo' }
Object >> isAngleItem [
	^false
]

{ #category : #'*DrGeo' }
Object >> isArcItem [
	^false
]

{ #category : #'*DrGeo' }
Object >> isBitmapItem [
	^false
]

{ #category : #'*DrGeo' }
Object >> isCircleItem [
	^false
]

{ #category : #'*DrGeo' }
Object >> isCompositeItem [
	^false
]

{ #category : #'*DrGeo' }
Object >> isConstrainedPointItem [
	^false
]

{ #category : #'*DrGeo' }
Object >> isCurveItem [
"When true, free point can be constrained on this item line"
	^false
]

{ #category : #'*DrGeo' }
Object >> isDirectionItem [
"When true, this item are straight line with normal and unit vector"
	^false
]

{ #category : #'*DrGeo' }
Object >> isEquation [
	^ false
]

{ #category : #'*DrGeo' }
Object >> isFreePointItem [
	^false
]

{ #category : #'*DrGeo' }
Object >> isFreePointOnPlaneItem [
	^false
]

{ #category : #'*DrGeo' }
Object >> isGeometricItem [
	^false
]

{ #category : #'*DrGeo' }
Object >> isIntersectableItem [
"When true, this curve can be intersected"
	^self isCurveItem
]

{ #category : #'*DrGeo' }
Object >> isIntersectionPointItem [
	^false
]

{ #category : #'*DrGeo' }
Object >> isLineItem [
	^false
]

{ #category : #'*DrGeo' }
Object >> isLocusItem [
	^false
]

{ #category : #'*DrGeo' }
Object >> isMathItem [
	^false
]

{ #category : #'*DrGeo' }
Object >> isNumberItem [
	^false
]

{ #category : #'*DrGeo' }
Object >> isPointItem [
	^false
]

{ #category : #'*DrGeo' }
Object >> isPointItemOnCurve [
	^false
]

{ #category : #'*DrGeo' }
Object >> isPolygonItem [
	^false
]

{ #category : #'*DrGeo' }
Object >> isRayItem [
	^false
]

{ #category : #'*DrGeo' }
Object >> isScriptItem [
	^false
]

{ #category : #'*DrGeo' }
Object >> isSegmentItem [
	^false
]

{ #category : #'*DrGeo' }
Object >> isTextItem [
	^false
]

{ #category : #'*DrGeo' }
Object >> isValueItem [
	^false
]

{ #category : #'*DrGeo' }
Object >> isVectorItem [
	^false
]

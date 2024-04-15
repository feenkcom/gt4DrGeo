Class {
	#name : #DrGPolygonRegularBuilder,
	#superclass : #DrGMathItemBuilder,
	#instVars : [
		'center',
		'pointA',
		'value'
	],
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #documentation }
DrGPolygonRegularBuilder class >> description [ 
	^ 'Regular polygon defined by its center, a vertex and its sides number.' translated
]

{ #category : #documentation }
DrGPolygonRegularBuilder class >> title [
	^ 'Regular polygon' translated
]

{ #category : #private }
DrGPolygonRegularBuilder >> addItem: aMathItemCollection at: aPoint [
| item |
	super addItem: aMathItemCollection at: aPoint.
	item := aMathItemCollection first.
	item isPointItem ifTrue: [
		center isNil ifTrue: [^ center := item].
		pointA isNil ifTrue: [^ pointA := item]].
	(item isValueItem and: [value isNil]) ifTrue: [
		value := item]
]

{ #category : #accessing }
DrGPolygonRegularBuilder >> arguments [
	^ {center. pointA. value}
]

{ #category : #testing }
DrGPolygonRegularBuilder >> isWanted: aMathItemCollection [
	^ aMathItemCollection notEmpty and: [
		(aMathItemCollection first isPointItem and: [center isNil or: [pointA isNil]]) or: [
			aMathItemCollection first isValueItem and: [value isNil]]]
]

{ #category : #constant }
DrGPolygonRegularBuilder >> mathItemClass [ 
	^ DrGPolygonRegularItem 
]

{ #category : #testing }
DrGPolygonRegularBuilder >> readyToBuild [
	^(center notNil and: [pointA notNil and: [value notNil ]])
]

{ #category : #updating }
DrGPolygonRegularBuilder >> reset [
	super reset.
	center := pointA := value := nil
]

"
I am an oriented (anti-clockwised) arc defined by its center, a startingPoint and endingPoint. 
endingPoint is not necessary on the arc but it provides the arc angle
"
Class {
	#name : #DrGArcCenterAngleItem,
	#superclass : #DrGArcItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #'xml writing' }
DrGArcCenterAngleItem >> nodeType [
	^ #centerAngle
]

{ #category : #updating }
DrGArcCenterAngleItem >> update [
| u v |
	self doParentsExist ifTrue: 
		[center := parents first point.
		u := parents second point - center.
		v := parents third point - center.
		(u = (0@0) or: [v = (0@0)]) 
			ifTrue: [exist := false]
			ifFalse: 
				[radius := u r.
				origin := u y asFloat arcTan: u x.
				length := (u crossProduct: v) asFloat arcTan: (u dotProduct: v).
				length < 0 ifTrue: [ length := length + Float twoPi]]]
]

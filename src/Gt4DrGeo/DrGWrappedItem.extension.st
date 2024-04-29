Extension { #name : #DrGWrappedItem }

{ #category : #'*Gt4DrGeo' }
DrGWrappedItem >> gtMessageLogFor: aView [
	<gtView>
	^ aView forward
		title: 'Messages';
		priority: 20;
		object: [ morph ];
		view: #gtMessagesFor:
]

{ #category : #'*Gt4DrGeo' }
DrGWrappedItem >> gtSummaryFor: aView [
	<gtView>
	^ aView forward
		title: 'Summary';
		priority: 10;
		object: [ self morph dgItem ];
		view: #gtSummaryFor:;
		actionUpdateButton
]

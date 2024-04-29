Extension { #name : #DrGMathItem }

{ #category : #'*Gt4DrGeo' }
DrGMathItem >> gtSummary [
	^ {{'name'.
			self name.
			self}}
]

{ #category : #'*Gt4DrGeo' }
DrGMathItem >> gtSummaryFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Summary';
		priority: 10;
		items: [ self gtSummary ];
		column: 'Index'
			text: [ :eachItem :eachIndex | eachIndex asRopedText foreground: Color gray ]
			width: 45;
		column: 'Key'
			text: #first
			width: 100;
		column: 'Value' text: #second;
		send: #last
]

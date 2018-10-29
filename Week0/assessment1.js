/*
Task 1: Repeating Numbers
*/


var repeatNumbers = function(data){
	var output = "";
	
	for (var i = 0; i < data.length; i++) {
		var number = data[i][0];
		var numRepeats = data[i][1];

		if(i != 0){
			output += ", ";
		}

		for (var j = 0; j < numRepeats; j++){
			output += number;
		}

	}

	return output;
};

//console.log(repeatNumbers([[1, 10]]));
//console.log(repeatNumbers([[1, 2], [2, 3]]));
//console.log(repeatNumbers([[10, 4], [34, 6], [92, 2]]));

/*
Task 2: Conditional Sums
*/

var conditionalSum = function(values, condition){
	var output = 0;

	for(var i = 0; i < values.length; i++){
		if(condition == "even"){
			if(values[i] % 2 == 0){
				output += values[i];
			}
		}
		else{
			if(values[i] % 2 != 0){
				output += values[i];
			}

		}
	}

	return output;
};

//console.log(conditionalSum([1, 2, 3, 4, 5], "even"));
//console.log(conditionalSum([1, 2, 3, 4, 5], "odd"));
//console.log(conditionalSum([13, 88, 12, 44, 99], "even"));
//console.log(conditionalSum([], "odd"));

/*
Task 3: Talking Calendar
*/

var talkingCalendar = function(date){
	var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

	var year = date.substring(0,4);
	var month = date.substring(5,7);
	var day = date.substring(8);

	if(day == "01" || day == "21" || day == "31"){
		dayText = "st";
	}
	else if(day == "02" || day == "22"){
		dayText = "nd";
	}
	else if(day == "03" || day == "23"){
		dayText = "rd";
	}
	else{
		dayText = "th";
	}

	if(day[0] == "0"){
		day = day[1];
	}

	return months[month - 1] + " " + day +dayText + ", " + year;

};

//console.log(talkingCalendar("2017/12/02"));
//console.log(talkingCalendar("2007/11/11"));
//console.log(talkingCalendar("1987/08/24"));


/*
Task 4: Challenge Calculator
*/

var calculateChange = function(total, cash){
	var changeInCents = cash - total;
	var numTwentys = 0;
	var numTens = 0;
	var numFives = 0;
	var numTwos = 0;
	var numDollars = 0;
	var numQuarters = 0;
	var numDimes = 0;
	var numNickels = 0;
	var numPennies = 0;

	if(changeInCents >= 2000){
		numTwentys = Math.floor(changeInCents / 2000);
		changeInCents = changeInCents % 2000;
	}
	if(changeInCents >= 1000){
		numTens = Math.floor(changeInCents / 1000);
		changeInCents = changeInCents % 1000;
	}
	if(changeInCents >= 500){
		numFives = Math.floor(changeInCents / 500);
		changeInCents = changeInCents % 500;
	}
	if(changeInCents >= 200){
		numTwos = Math.floor(changeInCents / 200);
		changeInCents = changeInCents % 200;
	}
	if(changeInCents >= 100){
		numDollars = Math.floor(changeInCents / 100);
		changeInCents = changeInCents % 100;
	}
	if(changeInCents >= 25){
		numQuarters = Math.floor(changeInCents / 25);
		changeInCents = changeInCents % 25;
	}
	if(changeInCents >= 10){
		numDimes = Math.floor(changeInCents / 10);
		changeInCents = changeInCents % 10;
	}
	if(changeInCents >= 5){
		numNickels = Math.floor(changeInCents / 5);
		changeInCents = changeInCents % 5;
	}
	
	numPennies = changeInCents;
	

	var output = {};

	if(numTwentys > 0){
		output["twenty"] = numTwentys;
	}

	if(numTens > 0){
		output["ten"] = numTens;
	}

	if(numFives > 0){
		output["five"] = numFives;
	}

	if(numTwos > 0){
		output["twoDollar"] = numTwos;
	}

	if(numDollars > 0){
		output["dollar"] = numDollars;
	}

	if(numQuarters > 0){
		output["quarter"] = numQuarters;
	}

	if(numDimes > 0){
		output["dime"] = numDimes;
	}

	if(numNickels > 0){
		output["nickel"] = numNickels;
	}

	if(numPennies > 0){
		output["penny"] = numPennies;
	}

	return output;

};

console.log(calculateChange(1787, 2000));
console.log(calculateChange(2623, 4000));
console.log(calculateChange(501, 1000));







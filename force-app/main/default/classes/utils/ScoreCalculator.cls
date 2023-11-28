public class ScoreCalculator {

    public static Integer calculateScore(Integer[] diceValues, BoxType bType) {
        switch on bType {
            when ONES, TWOS, THREES, FOURS, FIVES, SIXES {
                return calculateSum(diceValues, bType);
            }
            when MAX, MIN {
                return calculateSum(diceValues);
            }
            when TRIPS {
                return calculateTrips(diceValues);
            }
            when STRAIGHT {
                return calculateStraight(diceValues);
            }
            when BOAT {
                return calculateBoat(diceValues);
            }
            when CARRIAGE {
                return calculateCarriage(diceValues);
            }
            when YAMB {
                return calculateYamb(diceValues);
            }
            when else {
                throw new BoxUnavailableException();
            }
        }
    }

    // returns sum of all dice values
	private static Integer calculateSum(Integer[] diceValues) {
		Integer sum = 0;
        for (Integer dice : diceValues) {
            sum += dice;
        }
        return sum;
	}

	// returns sum of dice  values that equal the selected box type 
	// only applicable for box types [ONES-SIXES]
	private static Integer calculateSum(Integer[] diceValues, BoxType bType) {
		Integer sum = 0;
        for (Integer value : diceValues) {
			// if dice value is equal to box type add to sum
            if (value == (bType.ordinal() + 1)) {
                sum += value;
            }
        }
        return sum;
	}

	private static Integer calculateTrips(Integer[] diceValues) {
		Integer sum = calculateRecurringValueSum(diceValues, 3);
		if (sum > 0) {
			sum += GameConstants.BONUS_TRIPS;
		}
		return sum;
	}

	// returns bonus scores if dice values contain small or large straights
	// small straight [1, 2, 3, 4 , 5]
	// large straight [2, 3, 4, 5, 6]
	private static Integer calculateStraight(Integer[] diceValues) {
		Boolean[] foundValues = new Boolean[]{ false, false, false, false, false, false };
		for (Integer value : diceValues) {
			foundValues[value - 1] = true;
		}
		if (foundValues[0] && foundValues[1] && foundValues[2] && foundValues[3] && foundValues[4]) {
			return GameConstants.BONUS_STRAIGHT_SMALL;
		} else if (foundValues[1] && foundValues[2] && foundValues[3] && foundValues[4] && foundValues[5]) {
			return GameConstants.BONUS_STRAIGHT_LARGE;
		}
		return 0;
	}
	
	// boat consists of a pair and trips
	private static Integer calculateBoat(Integer[] diceValues) {
		Integer pairSum = calculateRecurringValueSum(diceValues, 2);
		Integer tripsSum = calculateRecurringValueSum(diceValues, 3);
        if (pairSum > 0 && tripsSum > 0 && (pairSum / 2) != (tripsSum / 3)) {
            return pairSum + tripsSum + GameConstants.BONUS_BOAT;
        }
        return 0;
	}

	// four of a kind
	private static Integer calculateCarriage(Integer[] diceValues) {
		Integer sum = calculateRecurringValueSum(diceValues, 4);
		if (sum > 0) {
			sum += GameConstants.BONUS_CARRIAGE;
		}
		return sum;
	}

	// five of a kind
	private static Integer calculateYamb(Integer[] diceValues) {
		Integer sum = calculateRecurringValueSum(diceValues, 5);
		if (sum > 0) {
			sum += GameConstants.BONUS_YAMB;
		}
		return sum;
	}

	// returns sum of dice values if the number of times that the value ocurrs is equal to or larger than the threshold
	// values exceeding the threshold are ignored 
	private static Integer calculateRecurringValueSum(Integer[] diceValues, Integer threshold) {
		Integer sum = 0;
        for (Integer i = 1; i <= 6; i++) {
            Integer count = 0;
            for (Integer value : diceValues) {
                if (value == i) {
                    count++;
                }
            }
			// if count has reached given number return sum increased by given bonus
            if (count >= threshold) {
                sum = i * threshold; // multiply by repeat number instead of count (having 4 dice of same value has no added value for TRIPS)
                break;
            }
        }
        return sum; // if count has not reached given number for any dice value return 0
	}
}
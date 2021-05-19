/**
 * ____________________________________________________________
 * This utility class contains static methods used when calculating scores based on
 * rolled dice values and box type that needs to be filled.
 * ____________________________________________________________
 * 
 * @author Matej Đanić <matej.danic@triple-innovations.com>
 * @version 0.1
 * 
 * @created 19.5.2021
 * ____________________________________________________________
 * 
 */

public with sharing class ScoreUtil {

    /**
     * 
     * Calculates score based on rolled dice values and type of box to be filled.
     * 
     * @param diceList the values of rolled dice
     * @param boxType  the type of box to be filled
     * @return the calculated score result
     */
    public static Integer calculateScore(List<Dice> diceList, BoxType boxType) {
		Integer result = 0;
		switch on boxType { 
			// determine method to be used for score calculation based on type of box to be
			// filled
			when ONES, TWOS, THREES, FOURS, FIVES, SIXES {
				result = calculateSumByType(diceList, boxType);
            }
            when MAX, MIN {
				result = calculateSum(diceList);
            }
            when TRIPS {
				result = calculateSumOfRepeatingValue(diceList, 3, GameConstants.BONUS_TRIPS);
            }
            when STRAIGHT {
				result = calculateStraight(diceList);
            }
			when FULL {
				result = calculateFull(diceList, GameConstants.BONUS_FULL);
            }
			when POKER {
				result = calculateSumOfRepeatingValue(diceList, 4, GameConstants.BONUS_POKER);
            }
            when YAHTZEE {
				result = calculateSumOfRepeatingValue(diceList, 5, GameConstants.BONUS_JAMB);
            }
		}
		return result;
	}

	/**
	 * Calculates sum of all dice values from received list.
	 * 
	 * @param diceList the values of rolled dice
	 * @return the sum of all dice values
	 */
	public static Integer calculateSum(List<Dice> diceList) {
		Integer sum = 0;
		for (Dice dice : diceList) {
			sum += dice.getValue();
		}
		return sum;
	}

	/**
	 * Calculates sum of all dice values equal to box type.
	 * 
	 * @param diceList the values of rolled dice
	 * @return the sum of all dice values equal to box type
	 */
	public static Integer calculateSumByType(List<Dice> diceList, BoxType boxType) {
		Integer sum = 0;
		for (Dice dice : diceList) {
			if ((dice.getValue() - 1) == boxType.ordinal()) {
				sum += dice.getValue(); // if dice value is equal to box type add to sum
			}
		}
		return sum;
	}

	/**
	 * Calculates sum of dice values that occur at least a certain number of times.
	 * 
	 * @param diceList      the values of rolled dice
	 * @param repeatCounter the minimal number of times value has to occur to be
	 *                      summed in the total
	 * @param bonus         the predefined bonus added to the sum if a value occured
	 *                      at least a certain number of times
	 * 
	 * @return the sum of dice values that they occured at least a certain
	 *         number of times; 0 if all values occured less than given number of
	 *         times
	 */
	public static Integer calculateSumOfRepeatingValue(List<Dice> diceList, Integer repeatNumber, Integer bonus) {
		Integer sum = 0;
        for (Integer i = 1; i <= 6; i++) {
            Integer count = 0;
            for (Dice dice : diceList) {
                if (dice.getValue() == i) {
                    count++;
                }
            }
			if (count >= repeatNumber) { // if count has reached given number return sum increased by given bonus
				sum = i * repeatNumber + bonus; // multiply by repeat number instead of count
                break;
			}
		}
		return sum; // if count has not reached given number for any dice value return 0
	}

	/**
	 * Checks if a straight occures in dice list. Straight is defined as 5 consecutive numbers, and can be either a small (1, 2, 3, 4 , 5), or big (2, 3, 4, 5, 6) straight.
	 * 
	 * @param diceList      the values of rolled dice
	 * 
	 * @return the predefined value of a small or big straight if it occured and 0 otherwise.
	 */
	public static Integer calculateStraight(List<Dice> diceList) {
        Boolean hasElements = false;
        for (Integer i = 2; i <= 5; i++) {
            hasElements = false;
            for (Dice dice : diceList) {
                if (dice.getValue() == i) {
                    hasElements = true;
                    break;
                }
            }
            if (!hasElements) {
                break;
            }
        }
        if (hasElements) {
            for (Dice dice : diceList) {
                if (dice.getValue() == 1) {
                    return GameConstants.BONUS_STRAIGHT_SMALL;
                } else if (dice.getValue() == 6) {
                    return GameConstants.BONUS_STRAIGHT_BIG;
                }
            }
        }
		return 0;
	}

	/**
	 * Checks if a full occures in dice list.
	 * 
	 * @param diceList      the values of rolled dice
	 * @param bonus         the predefined bonus added to the sum if a full occured
	 * 
	 * @return the sum of dice if both a pair and trips occured
	 */
	public static Integer calculateFull(List<Dice> diceList, Integer bonus) {
		Integer valueOfPair = 0;
		Integer valueOfTrips = 0;
		for (Integer i = 1; i <= 6; i++) {
			Integer count = 0;
            for (Dice dice : diceList) {
                if (dice.getValue() == i) {
                    count++;
                }
            }
			if (count == 2) {
				valueOfPair = i * count;
			} else if (count == 3) {
				valueOfTrips = i * count;
			}
		}
		if (valueOfPair > 0 && valueOfTrips > 0) {
			return valueOfPair + valueOfTrips + bonus;
		}
		return 0;
	}
}

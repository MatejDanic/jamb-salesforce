public class GameConstants {

    public static final Integer DICE_ROLL_LIMIT = 3;
	public static final Integer DICE_LIMIT = 5;

	public static final Integer BONUS_TRIPS = 10;
	public static final Integer BONUS_STRAIGHT_SMALL = 35;
	public static final Integer BONUS_STRAIGHT_LARGE = 45;
	public static final Integer BONUS_BOAT = 30;
	public static final Integer BONUS_CARRIAGE = 40;
	public static final Integer BONUS_YAMB = 50;

	public static final Integer TOP_SECTION_SUM_BONUS_THRESHOLD = 60;
	public static final Integer TOP_SECTION_SUM_BONUS = 30;

	public static final BoxType[] TOP_SECTION = new BoxType[] {
		BoxType.ONES,
		BoxType.TWOS,
		BoxType.THREES,
		BoxType.FOURS, 
		BoxType.FIVES, 
		BoxType.SIXES
	};

	public static final BoxType[] BOTTOM_SECTION = new BoxType[] {
		BoxType.TRIPS,
		BoxType.STRAIGHT,
		BoxType.CARRIAGE,
		BoxType.BOAT,
		BoxType.YAMB
	};

}
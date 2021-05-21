/**
 * ____________________________________________________________
 * 
 * ____________________________________________________________
 * 
 * @author Matej Đanić <matej.danic@triple-innovations.com>
 * @version 0.1
 * 
 * @created 17.5.2021
 * @modified 21.5.2021
 * ____________________________________________________________
 * 
 */

public with sharing class Form {

    private List<Column> columns;
    private Integer numberSum;
    private Integer differenceSum;
    private Integer labelSum;
    private Integer finalSum;

    public Form(List<Column> columns) {
        this.columns = columns;
        this.numberSum = 0;
        this.differenceSum = 0;
        this.labelSum = 0;
        this.finalSum = 0;
    }

    public List<Column> getColumns() {
        return this.columns;
    }

    public void setColumns(List<Column> columns) {
        this.columns = columns;
    }
    
    public Integer getNumberSum() {
        return this.numberSum;
    }

    public void setNumberSum(Integer numberSum) {
        this.numberSum = numberSum;
    }
    
    public Integer getDifferenceSum() {
        return this.differenceSum;
    }

    public void setDifferenceSum(Integer differenceSum) {
        this.differenceSum = differenceSum;
    }

    public Integer getLabelSum() {
        return this.labelSum;
    }

    public void setLabelSum(Integer labelSum) {
        this.labelSum = labelSum;
    }

    public Integer getFinalSum() {
        return this.finalSum;
    }

    public void setFinalSum(Integer finalSum) {
        this.finalSum = finalSum;
    }

    public boolean isAnnouncementRequired() {
        for (Column column : this.columns) {
            if (column.getType() != ColumnType.ANNOUNCEMENT && !column.isFinished()) {
                return false;
            }
        }
        return true;
    }

    public void updateSums() {
        this.numberSum = 0;
        this.differenceSum = 0;
        this.labelSum = 0;
        for (Column column : this.columns) {
            column.updateSums();
            this.numberSum += column.getNumberSum();
            this.differenceSum += column.getDifferenceSum();
            this.labelSum += column.getLabelSum();
        }
        this.finalSum = this.numberSum + this.differenceSum + this.labelSum;
    }

    public Column getColumnByType(String columnTypeString) {
		for (Column column : this.columns) {
			if (column.getType().name() == columnTypeString) {
				return column;
			}
		}
		return null;
	}
}

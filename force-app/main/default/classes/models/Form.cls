public with sharing class Form {
    private List<Column> columnList { get; private set; }
    private Integer sumA { get; private set; }
    private Integer sumB { get; private set; }
    private Integer sumC { get; private set; }
    public Integer totalSum { get; private set; }

    public Form(List<Column> columnList) {
        this.columnList = columnList;
        this.sumA = 0;
        this.sumB = 0;
        this.sumC = 0;
        this.totalSum = 0;
    }

    public Boolean isAnnouncementRequired() {
        for (Column column : this.columnList) {
            if (
                column.type != ColumnType.ANNOUNCEMENT && !column.isFinished()
            ) {
                return false;
            }
        }
        return true;
    }

    public void updateSums() {
        this.sumA = 0;
        this.sumB = 0;
        this.sumC = 0;
        for (Column column : this.columnList) {
            column.updateSums();
            this.sumA += column.sumA;
            this.sumB += column.sumB;
            this.sumC += column.sumC;
        }
        this.totalSum = this.sumA + this.sumB + this.sumC;
    }

    public void updateSums(ColumnType columnType) {
        this.sumA = 0;
        this.sumB = 0;
        this.sumC = 0;
        Column col = this.getColumnByType(columnType);
        col.updateSums();
        for (Column column : this.columnList) {
            this.sumA += column.sumA;
            this.sumB += column.sumB;
            this.sumC += column.sumC;
        }
        this.totalSum = this.sumA + this.sumB + this.sumC;
    }

    public Column getColumnByType(ColumnType type) {
        for (Column column : this.columnList) {
            if (column.type == type) {
                return column;
            }
        }
        return null;
    }

    public Boolean isFinished() {
        for (Column column : this.columnList) {
            if (!column.isFinished()) {
                return false;
            }
        }
        return true;
    }
}

package com.application.table;

import java.util.List;
import java.util.stream.Stream;

public class FingerTable {
	List<FingerTableRecord> records;

	public FingerTable(List<FingerTableRecord> records) {
		this.records = records;
	}

	public FingerTableRecord getFinger(int index) {
		return records.get(index);
	}

	public Stream<FingerTableRecord> stream() {
		return records.stream();
	}

	public void setRecord(FingerTableRecord record, int recordIndex){
		records.set(recordIndex, record);
	}

	public int size() {
		return records.size();
	}

	public List<FingerTableRecord> getRecords() {
		return records;
	}

	@Override
	public String toString() {
		return "\n\tFingerTable{" + "records=" + records + '}';
	}
}

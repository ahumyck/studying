package com.application.table.impls;

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

	public List<FingerTableRecord> getRecords() {
		return records;
	}

	@Override
	public String toString() {
		return "\n\tFingerTable{" + "records=" + records + '}';
	}
}

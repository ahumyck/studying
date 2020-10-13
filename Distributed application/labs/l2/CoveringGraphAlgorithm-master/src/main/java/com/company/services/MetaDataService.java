package com.company.services;


import com.company.dto.dtoEntites.metadata.MetaDataDTO;
import com.company.entities.chord.Chord;
import com.company.entities.chord.ChordNode;
import com.company.entities.exceptions.ChordNodeIsNotActiveException;
import com.company.entities.table.FingerTable;
import com.company.entities.table.FingerTableRecord;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class MetaDataService {

    public Optional<MetaDataDTO> getChordNodeMetaData(Optional<Chord> optionalChord, int id) {
        if (optionalChord.isPresent()) {
            ChordNode chordNode = optionalChord.get().getChordNode(id);
            StringBuilder builder = new StringBuilder("chord node ").append(chordNode.getId());
            try {
                builder.append(successorAndPredecessorData(chordNode));
                builder.append(getFingerTableMetaData(chordNode.getFingerTable()));
            } catch (ChordNodeIsNotActiveException ignored) {
                builder.append(" is not active");
            }
            return Optional.of(new MetaDataDTO(builder.toString()));
        }
        return Optional.of(new MetaDataDTO(""));
    }

    private String getFingerTableMetaData(FingerTable fingerTable) {
        StringBuilder builder = new StringBuilder();
        List<FingerTableRecord> records = fingerTable.getRecords();
        for (FingerTableRecord record : records) {
            int startId = record.getStart().getId();
            builder.append("start=").append(startId);
            builder.append(", int[").append(startId).append(',').append(record.getEnd().getId()).append(')');
            builder.append(", succ=").append(record.getNode().getId()).append('\n');
        }
        return builder.toString();
    }

    private String successorAndPredecessorData(ChordNode node) throws ChordNodeIsNotActiveException {
        return ", succ=" + node.getSuccessor().getId() +
                ", pred=" + node.getPredecessor().getId() + '\n';
    }
}

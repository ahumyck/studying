package com.company.services.builders;

import com.company.dto.dtoEntites.graphEntities.*;
import com.company.entities.chord.Chord;
import com.company.entities.chord.ChordNode;
import com.company.entities.exceptions.ChordNodeIsNotActiveException;
import com.company.entities.table.FingerTable;
import com.company.entities.table.FingerTableRecord;
import org.springframework.stereotype.Service;

import java.util.LinkedList;
import java.util.List;
import java.util.Optional;

@Service
public class GraphDTOByChordBuilder {

    private String activeNodeColor = "#00FF00";
    private String passiveNodeColor = "#FF0000";
    private String defaultColor = "#888888";

    public Optional<GraphDataDTO> build(Optional<Chord> optionalChord) {
        return optionalChord.map(chord -> new GraphDataDTO(graphDTOBuilder(chord)));
    }

    private GraphDTO graphDTOBuilder(Chord chord) {
        return new GraphDTO(listNodeDataDTOBuilder(chord), listEdgeDataDTOBuilder(chord));
    }

    private List<NodeDataDTO> listNodeDataDTOBuilder(Chord chord) {
        List<NodeDataDTO> nodeDTOList = new LinkedList<>();

        for (int i = 0; i < chord.size(); i++) {
            String id = String.valueOf(i);
            String nodeColor = chord.getChordNode(i).isActive() ? activeNodeColor : passiveNodeColor;
            nodeDTOList.add(new NodeDataDTO(new NodeDTO(id, id, nodeColor)));
        }
        return nodeDTOList;
    }

    private List<EdgeDataDTO> listEdgeDataDTOBuilder(Chord chord) {
        int chordSize = chord.size();
        List<EdgeDataDTO> edgeDataDTOList = new LinkedList<>();
        for (int i = 0; i < chordSize; i++) {
            ChordNode chordNode = chord.getChordNode(i);
            edgeDataDTOList.add(generateEdgeDataDTONext(chordSize, i));
            try {
                edgeDataDTOList.addAll(generateEdgeDataDTOFingerTable(i, chordNode.getFingerTable()));
                //				edgeDataDTOList.addAll(generateSuccessorAndPredecessorEdgeDataDTO(chord.getChordNode(i)));
            } catch (ChordNodeIsNotActiveException ignored) {
            }

        }
        return edgeDataDTOList;
    }

    private List<EdgeDataDTO> generateSuccessorAndPredecessorEdgeDataDTO(ChordNode node) {
        int source = node.getId();
        List<EdgeDataDTO> edgeDataDTOS = new LinkedList<>();
        try {
            ChordNode successor = node.getSuccessor();
            ChordNode predecessor = node.getPredecessor();
            edgeDataDTOS.add(generateEdgeDataDTO(source, successor.getId(), defaultColor));
            edgeDataDTOS.add(generateEdgeDataDTO(source, predecessor.getId(), defaultColor));
        } catch (ChordNodeIsNotActiveException ignored) {
        }
        return edgeDataDTOS;
    }

    private EdgeDataDTO generateEdgeDataDTONext(int chordSize, int id) {
        String source = String.valueOf(id);
        String target = String.valueOf((id + 1) % chordSize);
        return new EdgeDataDTO(new EdgeDTO(source, target, defaultColor));
    }

    private EdgeDataDTO generateEdgeDataDTO(int source, int target, String color) {
        return new EdgeDataDTO(new EdgeDTO(String.valueOf(source), String.valueOf(target), color));
    }

    private EdgeDataDTO generateEdgeDataDTOFingerRecord(int source, FingerTableRecord record) {
        return generateEdgeDataDTO(source, record.getStart().getId(), defaultColor);
    }

    private List<EdgeDataDTO> generateEdgeDataDTOFingerTable(int source, FingerTable table) {
        List<EdgeDataDTO> edgeDataDTOList = new LinkedList<>();
        table.stream().forEach(record -> edgeDataDTOList.add(generateEdgeDataDTOFingerRecord(source, record)));
        return edgeDataDTOList;
    }
}

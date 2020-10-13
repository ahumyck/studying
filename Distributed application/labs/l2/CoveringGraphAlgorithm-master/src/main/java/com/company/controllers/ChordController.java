package com.company.controllers;

import com.company.dto.dtoEntites.graphEntities.GraphDataDTO;
import com.company.dto.dtoEntites.metadata.MetaDataDTO;
import com.company.dto.request.ChordCreationExecutionBody;
import com.company.dto.request.ChordIdExecutionBody;
import com.company.entities.chord.Chord;
import com.company.entities.exceptions.ChordHasNoActiveNodesException;
import com.company.entities.exceptions.ChordNodeIsNotActiveException;
import com.company.services.ChordService;
import com.company.services.MetaDataService;
import com.company.services.builders.GraphDTOByChordBuilder;
import com.company.utils.ApiPaths;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Optional;

@RestController
@RequestMapping(value = ApiPaths.CHORD_CONTROL_SYSTEM)
public class ChordController {

    private final ChordService chordService;
    private final GraphDTOByChordBuilder builder;
    private final MetaDataService metaDataService;

    @Autowired
    public ChordController(ChordService chordService, GraphDTOByChordBuilder builder, MetaDataService metaDataService) {
        this.chordService = chordService;
        this.builder = builder;
        this.metaDataService = metaDataService;
    }


    @PostMapping(value = ApiPaths.CREATE)
    public Optional<GraphDataDTO> createNewChord(HttpServletResponse response, @RequestBody ChordCreationExecutionBody body) throws IOException {
        return builder.build(chordService.createAndStoreNewChord(body.getSize()));
    }

    @PostMapping(value = ApiPaths.GET_METADATA)
    public Optional<MetaDataDTO> getMetaDataInformation(HttpServletResponse response, @RequestBody ChordIdExecutionBody body) throws IOException {
        return metaDataService.getChordNodeMetaData(chordService.getCurrentChord(), body.getId());
    }

    @PostMapping(value = ApiPaths.REMOVE)
    public Optional<GraphDataDTO> removeChordNode(HttpServletResponse response, @RequestBody ChordIdExecutionBody body) throws IOException {
        try {
            return builder.build(chordService.remove(body.getId()));
        } catch (ChordNodeIsNotActiveException e) {
            response.sendError(404, e.getLocalizedMessage());
        }
        return Optional.empty();
    }


    @PostMapping(value = ApiPaths.ADD)
    public Optional<GraphDataDTO> addChordNode(HttpServletResponse response, @RequestBody ChordIdExecutionBody body) throws IOException {
        try {
            Optional<Chord> add = chordService.add(body.getId());
            return builder.build(add);
        } catch (ChordNodeIsNotActiveException | ChordHasNoActiveNodesException e) {
            response.sendError(404, e.getLocalizedMessage());
        }
        return Optional.empty();
    }
}

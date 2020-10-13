package com.company.services;


import com.company.entities.chord.Chord;
import com.company.entities.exceptions.ChordHasNoActiveNodesException;
import com.company.entities.exceptions.ChordNodeIsNotActiveException;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class ChordService {

    private Chord chord = null;

    public Optional<Chord> createAndStoreNewChord(int n) {
        chord = Chord.createChord(n);
        return Optional.of(chord);
    }

    public Optional<Chord> getCurrentChord() {
        if (chord == null) {
            return Optional.empty();
        }
        return Optional.of(chord);
    }

    public Optional<Chord> remove(int id) throws ChordNodeIsNotActiveException {
        if (isExisting()) {
            chord.remove(id);
        }
        return getCurrentChord();
    }

    public Optional<Chord> add(int id) throws ChordNodeIsNotActiveException, ChordHasNoActiveNodesException {
        if (isExisting()) {
            chord.add(id);
        }
        return getCurrentChord();
    }

    public boolean isExisting() {
        return !(chord == null);
    }

}

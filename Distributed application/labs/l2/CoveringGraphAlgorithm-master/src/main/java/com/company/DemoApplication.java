package com.company;

import com.company.entities.chord.Chord;
import com.company.entities.exceptions.ChordHasNoActiveNodesException;
import com.company.entities.exceptions.ChordNodeIsNotActiveException;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;


@SpringBootApplication
public class DemoApplication {


    public static void main(String[] args) {

        SpringApplication.run(DemoApplication.class, args);
    }

//    public static void main(String[] args) throws ChordNodeIsNotActiveException, ChordHasNoActiveNodesException {
//        Chord chord = Chord.createChord(16);
//        chord.add(0);
//        chord.add(4);
//        chord.add(8);
//        chord.add(12);
//        chord.add(1);
//        chord.add(2);
//
//        System.out.println(chord);
//
//    }
}

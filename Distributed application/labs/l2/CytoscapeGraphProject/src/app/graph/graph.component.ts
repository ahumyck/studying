import {Component, OnInit} from '@angular/core';
import {GraphData} from './graph-data';
import {ChordService} from '../services/chord.service';
import {GraphService} from '../services/graph.service';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

@Component({
    selector: 'app-graph',
    templateUrl: './graph.component.html',
    styleUrls: ['./graph.component.scss']
})
export class GraphComponent implements OnInit {
    private message: string;
    private value: string;
    private metadata: string = "metadata field";

    layout = {
        name: 'circle', //concentric
    };

    graphData: GraphData;


    constructor(private chordService: ChordService,
                private formBuilder: FormBuilder,
                private graphService: GraphService) {
    }

    ngOnInit() {
        this.graphData = this.graphService.getGraphData;
    }


    private validateStringParameter(input: string): boolean{
        return !(input === "");
    }

    private castToNumber(input: string): number{
        return Number(input);
    }

    public getNewChord(): void {
        console.log(this.value);
        if(this.validateStringParameter(this.value)) {
            this.chordService.createNewChord(this.castToNumber(this.value)).subscribe(data => {
                this.graphService.updateGraphData = data;
                this.graphData = data.graphDTO;
                this.message = "Chord received";
            },
                error => this.message = error.error.message            
            )
        }
    }

    public removeChordNode(): void {
        if(this.validateStringParameter(this.value)) {
            this.chordService.removeChord(this.castToNumber(this.value)).subscribe(data => {
                this.graphService.updateGraphData = data;
                this.graphData = data.graphDTO;
                this.message = "chord node removed";
            },
                error => this.message = error.error.message
            )
        }
    }

    public addChordNode(): void {
        if(this.validateStringParameter(this.value)) {
            this.chordService.addChord(this.castToNumber(this.value)).subscribe(data => {
                this.graphService.updateGraphData = data;
                this.graphData = data.graphDTO;
                this.message = "chord node added";
            },
                error => this.message = error.error.message
            )
        }
    }

    public getMetaData(): void {
        if(this.validateStringParameter(this.value)) {
            this.chordService.getMetaData(this.castToNumber(this.value)).subscribe(data => {
                this.metadata = data.metadata;
                this.message = "Metadata received";
            },
                error => this.message = error.error.message
            )
        }
    }
}

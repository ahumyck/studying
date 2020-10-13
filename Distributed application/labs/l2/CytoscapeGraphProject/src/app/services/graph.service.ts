import {Injectable} from '@angular/core';
import {HttpClient, HttpHeaders} from '@angular/common/http';
import {Observable} from 'rxjs';
import { GraphData } from '../graph/graph-data';

@Injectable({
    providedIn: 'root'
})
export class GraphService {

    private selectedNode: any;

    private graphData: GraphData = {
        nodes: [
            {data: {id: 'a', name: 'Sign Up', color: 'blue'}},
            {data: {id: 'b', name: 'User Profile', color: 'magenta'}},
            {data: {id: 'c', name: 'Billing', color: 'magenta'}},
            {data: {id: 'd', name: 'Sales', color: 'orange'}},
            {data: {id: 'e', name: 'Referral', color: 'orange'}},
            {data: {id: 'f', name: 'Loan', color: 'orange'}},
            {data: {id: 'j', name: 'Support', color: 'red'}},
            {data: {id: 'k', name: 'Sink Event', color: 'green'}}
        ],
        edges: [
            {data: {source: 'a', target: 'b', color: 'blue'}},
            {data: {source: 'b', target: 'c', color: 'blue'}},
            {data: {source: 'c', target: 'd', color: 'blue'}},
            {data: {source: 'c', target: 'e', color: 'blue'}},
            {data: {source: 'c', target: 'f', color: 'blue'}},
            {data: {source: 'e', target: 'j', color: 'red'}},
            {data: {source: 'e', target: 'k', color: 'green'}}
        ]
    };

    constructor() {
    }


    get getGraphData(): GraphData {
        return this.graphData;
    }

    set updateGraphData(graphData: GraphData) {
        this.graphData = graphData;
    }

    get getSelectedNode(): any {
        return this.selectedNode;
    }

    set updateSelectedNode(selectedNode: any) {
        this.selectedNode = selectedNode;
    }

}

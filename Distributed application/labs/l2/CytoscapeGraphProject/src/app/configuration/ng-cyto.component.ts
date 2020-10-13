import {Component, OnChanges, Renderer, ElementRef, Input, Output, EventEmitter} from '@angular/core';

declare var cytoscape: any;

@Component({
    selector: 'ng2-cytoscape',
    templateUrl: './ng-cyto.component.html',
    styleUrls: ['./ng-cyto.component.css']
})


export class NgCytoComponent implements OnChanges {

    @Input() public elements: any;
    @Input() public style: any;
    @Input() public layout: any;
    @Input() public zoom: any;
    @Input() public cy: any;

    @Output() select: EventEmitter<any> = new EventEmitter<any>();

    public selectedNode: any;

    public constructor(private renderer: Renderer, private el: ElementRef) {

        this.layout = this.layout || {
            name: 'grid',
            directed: true,
            padding: 0
        };

        this.zoom = this.zoom || {
            min: 0.1,
            max: 1.5
        };

        this.style = this.style || cytoscape.stylesheet()

            .selector('node')
            .css({
                //'shape': 'rectangle',
                //'width': 'mapData(weight, 40, 80, 20, 60)',
                'label': 'data(name)',
                'content': 'data(name)',
                'text-valign': 'center',
                'text-outline-width': 1,
                'text-outline-color': 'data(color)',
                'background-color': 'data(color)',
                'color': '#fff',
                'font-size': 24
            })
            .selector(':selected')
            .css({
                'border-width': 1,
                'border-color': 'black'
            })
            .selector('edge')
            .css({
                'curve-style': 'straigth',
                'opacity': 0.666,
                //'width': 'mapData(70, 100, 2, 6)',
                'target-arrow-shape': 'diamond',
                'line-color': 'data(color)',
                'source-arrow-color': 'data(color)',
                'target-arrow-color': 'data(color)'
            })
            .selector('edge.questionable')
            .css({
                'line-style': 'dotted',
                'target-arrow-shape': 'diamond'
            })
            .selector('.faded')
            .css({
                'opacity': 0.25,
                'text-opacity': 0
            });
    }

    public ngOnChanges(): any {
        this.render();
    }

    public render() {
        let cy_contianer = this.renderer.selectRootElement("#cy");
        let cy = cytoscape({
            container: cy_contianer,
            layout: this.layout,
            minZoom: this.zoom.min,
            maxZoom: this.zoom.max,
            style: this.style,
            elements: this.elements,
        });


        cy.on('tap', 'node', function (e) {
            this.selectedNode = e.target;
        });

        cy.on('mouseover', 'node', function(evt){
            this.selectedNode = evt.target;
        });
    }

}

import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppComponent } from './app.component';
import { CytoscapeModule } from 'ngx-cytoscape';
import { GraphComponent } from './graph/graph.component';
import { HttpClientModule } from '@angular/common/http';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MatSidenavModule } from '@angular/material';
import { MatButtonModule } from '@angular/material/button';
import { MaterialModule } from './material.module';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { NgCytoComponent } from './configuration/ng-cyto.component';


@NgModule({
  declarations: [
    AppComponent,
    GraphComponent,
    NgCytoComponent
  ],
  imports: [
    BrowserModule,
    CytoscapeModule,
    HttpClientModule,
    FormsModule,
    ReactiveFormsModule,
    MatButtonModule,
    MatSidenavModule,
    MaterialModule,
    BrowserAnimationsModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }

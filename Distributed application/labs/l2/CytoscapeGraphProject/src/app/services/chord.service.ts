import {Injectable} from '@angular/core';
import {HttpClient, HttpHeaders} from '@angular/common/http';
import {Observable} from 'rxjs';

@Injectable({
    providedIn: 'root'
})
export class ChordService {
    private url = 'http://localhost:8080';
    private chordControlSystem = '/chord';
    private create = '/create';
    private add = '/add';
    private remove = '/remove';
    private metadata = '/metadata';

    constructor(private http: HttpClient) {
    }


    public createNewChord(chordSize: number): Observable<any> {
        const body = {size: chordSize};
        return this.http.post<any>(this.url + this.chordControlSystem + this.create, body);
    }

    public addChord(chordId: number): Observable<any> {
        const body = {id: chordId};
        return this.http.post<any>(this.url + this.chordControlSystem + this.add, body);
    }

    public removeChord(chordId: number): Observable<any> {
        const body = {id: chordId};
        return this.http.post<any>(this.url + this.chordControlSystem + this.remove, body);
    }

    public getMetaData(chordId: number): Observable<any> {
        const body = {id: chordId};
        return this.http.post<any>(this.url + this.chordControlSystem + this.metadata, body);
    }

}

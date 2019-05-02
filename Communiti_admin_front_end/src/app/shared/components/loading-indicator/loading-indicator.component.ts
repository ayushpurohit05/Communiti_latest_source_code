import { Component, OnInit } from '@angular/core';
import { Observable } from 'rxjs/Observable';
import { HttpService } from '../../../core/services/http.service';
import { Subject } from 'rxjs/Subject';
@Component({
  selector: 'app-loading-indicator',
  templateUrl: './loading-indicator.component.html',
  styleUrls: ['./loading-indicator.component.scss']
})
export class LoadingIndicatorComponent implements OnInit {
  loading$: Subject<{loading: boolean, hasError: boolean, hasMsg: string}>

  constructor(private httpService: HttpService) {
    this.loading$ = this.httpService.loading;
  }

  ngOnInit() {
  }

}

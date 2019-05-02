import { Injectable } from '@angular/core';
import { Observable } from 'rxjs/Observable';
import 'rxjs/Rx';
import { Subject } from 'rxjs/Subject';

@Injectable()
export class ChatService {
  public myCount = new Subject<{myCount: number}>();
  constructor() { }
  setChatCount(count){
  	this.myCount.next({
      myCount: count
    });
  }
}

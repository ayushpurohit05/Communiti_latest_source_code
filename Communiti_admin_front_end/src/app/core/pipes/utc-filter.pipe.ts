import { Pipe, PipeTransform } from '@angular/core';
import * as moment from 'moment';

@Pipe({
  name: 'UtcFilterPipe'
})
export class UtcFilterPipe implements PipeTransform {

  transform(value: any, args?: any): any {
  	let time = moment.parseZone(value).local().format('hh:mm a')
    return time;
  }

}

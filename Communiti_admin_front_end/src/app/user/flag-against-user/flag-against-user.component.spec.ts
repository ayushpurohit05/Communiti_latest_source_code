import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { FlagAgainstUserComponent } from './flag-against-user.component';

describe('FlagAgainstUserComponent', () => {
  let component: FlagAgainstUserComponent;
  let fixture: ComponentFixture<FlagAgainstUserComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ FlagAgainstUserComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(FlagAgainstUserComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});

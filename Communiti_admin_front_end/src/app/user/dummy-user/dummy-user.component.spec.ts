import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { DummyUserComponent } from './dummy-user.component';

describe('DummyUserComponent', () => {
  let component: DummyUserComponent;
  let fixture: ComponentFixture<DummyUserComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ DummyUserComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DummyUserComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
